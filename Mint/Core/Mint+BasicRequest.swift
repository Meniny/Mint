
import Foundation

public extension Mint {
    public typealias RequestID = String
    public typealias SuccessClosure = (_ response: Data, _ response: HTTPURLResponse) -> Void
    public typealias FailureClosure = (_ error: NSError, _ response: HTTPURLResponse) -> Void
}

public extension Mint {
    
    @discardableResult
    public func request<T: DataSerialization>(_ path: String,
                        method: Mint.Method,
                        parameter: Mint.Parameter,
                        accept: Mint.ContentType? = nil,
                        completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: method, parameter: parameter, accept: accept, completion: { (data, resp) in
            let result = Result<NSError, T>.init(data: data, response: resp)
            completion(result)
        }, failure: { (error, resp) in
            completion(Result<NSError, T>.failure(error, resp))
        })
    }
    
    @discardableResult
    public func request(_ path: String,
                        method: Mint.Method,
                        parameter: Mint.Parameter,
                        accept: Mint.ContentType? = nil,
                        completion: @escaping Mint.SuccessClosure,
                        failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return task(path, method: method, parameter: parameter, accept: accept, completion: { (data, response, error) in
            
            if let unauthorizedRequestCallback = self.unauthorizedRequestCallback,
                let ne = error as NSError?, ne.code == 403 || ne.code == 401 {
                unauthorizedRequestCallback()
                
            } else {
                
                let resp = response as! HTTPURLResponse
                
                if let ne = error as NSError? {
                    failure(ne, resp)
                } else {
                    
                    if let resturnData = data {
                        completion(resturnData, resp)
                    } else {
                        let ne = NSError(domain: Mint.domain,
                                         code: URLError.cannotParseResponse.rawValue,
                                         userInfo: [
                                            NSLocalizedDescriptionKey: NSLocalizedString("Malformed data", comment: "")
                            ])
                        failure(ne, resp)
                    }
                }
            }
        })
    }
    
    @discardableResult
    public func task(_ path: String,
                        method: Mint.Method,
                        parameter: Mint.Parameter,
                        accept: Mint.ContentType? = nil,
                        completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Mint.RequestID {
        
        let requestID = UUID().uuidString
        
        let url = try! composedURL(with: path)
        
        var request = URLRequest(url: url,
                                 method: method,
                                 contentType: parameter.contentType(boundary),
                                 accept: accept,
                                 authorizationHeaderValue: authorizationHeaderValue,
                                 token: token,
                                 authorizationHeaderKey: authorizationHeaderKey,
                                 headerFields: headerFields)
        
        DispatchQueue.main.async {
            NetworkActivityIndicator.sharedIndicator.visible = true
        }
        
        var serializingError: NSError?
        switch parameter {
        case .none: break
        case .json(let j):
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: j, options: [])
            } catch let error as NSError {
                serializingError = error
            }
        case .formURLEncoded(let d):
            do {
                let formattedParameters = try d.urlEncodedString()
                switch method {
                case .get, .delete:
                    let urlEncodedPath: String
                    if path.contains("?") {
                        if let lastCharacter = path.last, lastCharacter == "?" {
                            urlEncodedPath = path + formattedParameters
                        } else {
                            urlEncodedPath = path + "&" + formattedParameters
                        }
                    } else {
                        urlEncodedPath = path + "?" + formattedParameters
                    }
                    request.url = try! composedURL(with: urlEncodedPath)
                //                case .post, .put, .patch:
                default:
                    request.httpBody = formattedParameters.data(using: .utf8)
                }
            } catch let error as NSError {
                serializingError = error
            }
        case .multipartFormData(let p):
            var bodyData = Data()
            for part in p {
                bodyData.append(part.formData(boundary: boundary))
            }
            
            bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = bodyData as Data
        case .custom(let d, _):
            request.httpBody = d
        }
        
        if let serializingError = serializingError {
            let url = try! composedURL(with: path)
            let response = HTTPURLResponse(url: url, statusCode: serializingError.code)
            completion(nil, response, serializingError)
            
        } else {
            
            let session = self.session.dataTask(with: request) { data, response, error in
                
                completion(data, response, error)
                
                DispatchQueue.main.async {
                    NetworkActivityIndicator.sharedIndicator.visible = false
                }
            }
            
            session.taskDescription = requestID
            session.resume()
        }
        
        return requestID
    }
    
    public func cancel(method: Method, url: URL, taskType: TaskType) {
        let semaphore = DispatchSemaphore(value: 0)
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            var sessionTasks = [URLSessionTask]()
            switch taskType {
            case .data:
                sessionTasks = dataTasks
            case .download:
                sessionTasks = downloadTasks
            case .upload:
                sessionTasks = uploadTasks
            }
            
            for sessionTask in sessionTasks {
                if sessionTask.originalRequest?.httpMethod == method.rawValue && sessionTask.originalRequest?.url?.absoluteString == url.absoluteString {
                    sessionTask.cancel()
                    break
                }
            }
            
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: DispatchTime.now() + 60.0)
    }
}
