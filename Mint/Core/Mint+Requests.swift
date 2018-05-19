
import Foundation

public extension Mint {
    @discardableResult
    public func get<T: DataSerialization>(_ path: String,
                                          parameter: [String: Any] = [:],
                                          accept: Mint.ContentType? = nil,
                                          completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: .get, parameter: .formURLEncoded(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func get(_ path: String,
                    parameter: [String: Any] = [:],
                    accept: Mint.ContentType? = nil,
                    completion: @escaping Mint.SuccessClosure,
                    failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .get, parameter: .formURLEncoded(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func post<T: DataSerialization>(_ path: String,
                                           parameter: [String: Any] = [:],
                                           accept: Mint.ContentType? = nil,
                                           completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: .post, parameter: .json(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func post(_ path: String,
                     parameter: [String: Any] = [:],
                     accept: Mint.ContentType? = nil,
                     completion: @escaping Mint.SuccessClosure,
                     failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .post, parameter: .json(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func form<T: DataSerialization>(_ path: String,
                                           method: Mint.Method = .post,
                                           parameter: [FormDataPart],
                                           accept: Mint.ContentType? = nil,
                                           completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: method, parameter: .multipartFormData(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func form(_ path: String,
                     method: Mint.Method = .post,
                     parameter: [FormDataPart],
                     accept: Mint.ContentType? = nil,
                     completion: @escaping Mint.SuccessClosure,
                     failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: method, parameter: .multipartFormData(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func put<T: DataSerialization>(_ path: String,
                                          parameter: [String: Any] = [:],
                                          accept: Mint.ContentType? = nil,
                                          completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: .put, parameter: .json(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func put(_ path: String,
                    parameter: [String: Any] = [:],
                    accept: Mint.ContentType? = nil,
                    completion: @escaping Mint.SuccessClosure,
                    failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .put, parameter: .json(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func delete<T: DataSerialization>(_ path: String,
                                             parameter: [String: Any] = [:],
                                             accept: Mint.ContentType? = nil,
                                             completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: .delete, parameter: .formURLEncoded(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func delete(_ path: String,
                       parameter: [String: Any] = [:],
                       accept: Mint.ContentType? = nil,
                       completion: @escaping Mint.SuccessClosure,
                       failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .delete, parameter: .formURLEncoded(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func patch<T: DataSerialization>(_ path: String,
                                            parameter: [String: Any] = [:],
                                            accept: Mint.ContentType? = nil,
                                            completion: @escaping (Result<NSError, T>) -> Void) -> Mint.RequestID {
        return request(path, method: .patch, parameter: .json(parameter), accept: accept, completion: completion)
    }
    
    @discardableResult
    public func patch(_ path: String,
                      parameter: [String: Any] = [:],
                      accept: Mint.ContentType? = nil,
                      completion: @escaping Mint.SuccessClosure,
                      failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .patch, parameter: .json(parameter), accept: accept, completion: completion, failure: failure)
    }
}

public extension Mint {
    @discardableResult
    public func downloadImage(_ path: String,
                              parameter: Mint.Parameter = .none,
                              completion: @escaping (ImageResult) -> Void) -> Mint.RequestID {
        return downloadImage(path, parameter: parameter, completion: { image, resp in
            completion(ImageResult.success(image, resp))
        }, failure: { (error, resp) in
            completion(ImageResult.failure(error, resp))
        })
    }
    
    @discardableResult
    public func downloadImage(_ path: String,
                              parameter: Mint.Parameter = .none,
                              completion: @escaping (MintImage, HTTPURLResponse) -> Void,
                              failure: @escaping Mint.FailureClosure) -> Mint.RequestID {
        return request(path, method: .get, parameter: parameter, accept: .bin, completion: { data, resp in
            guard let image = MintImage.init(data: data) else {
                failure(NSError(domain: Mint.domain, code: URLError.cannotParseResponse.rawValue, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Malformed data", comment: "")]), resp)
                return
            }
            completion(image, resp)
        }, failure: failure)
    }
}


