
import Foundation

extension CharacterSet {
    static var urlQueryParametersAllowed: CharacterSet {
        /// Does not include "?" or "/" due to RFC 3986 - Section 3.4
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return allowedCharacterSet
    }
}

public extension Dictionary where Key: ExpressibleByStringLiteral {

    /// Encodes the contents of the dictionary
    ///
    /// - Returns: Returns the parameters in using URL-enconding, for example ["username": "Michael", "age": 20] will become "username=Michael&age=20".
    /// - Throws: Returns an error if it wasn't able to encode the dictionary.
    public func urlEncodedString() throws -> String {

        let pairs = try reduce([]) { current, keyValuePair -> [String] in
            if let encodedValue = "\(keyValuePair.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryParametersAllowed) {
                return current + ["\(keyValuePair.key)=\(encodedValue)"]
            } else {
                throw NSError(domain: Mint.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't encode \(keyValuePair.value)"])
            }
        }

        let converted = pairs.joined(separator: "&")

        return converted
    }
}

extension String {

    func encodeUTF8() -> String? {
        if let _ = URL(string: self) {
            return self
        }

        var components = self.components(separatedBy: "/")
        guard let lastComponent = components.popLast(),
            let endcodedLastComponent = lastComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryParametersAllowed) else {
            return nil
        }

        return (components + [endcodedLastComponent]).joined(separator: "/")
    }
}

extension FileManager {

    public func exists(at url: URL) -> Bool {
        let path = url.path

        return fileExists(atPath: path)
    }

    public func remove(at url: URL) throws {
        let path = url.path
        guard FileManager.default.isDeletableFile(atPath: url.path) else { return }

        try FileManager.default.removeItem(atPath: path)
    }
}

extension URLRequest {
    init(url: URL,
         method: Mint.Method,
         contentType: Mint.ContentType?,
         accept: Mint.ContentType?,
         authorizationHeaderValue: String?,
         token: String?,
         authorizationHeaderKey: String,
         headerFields: [String: String]?) {
        
        self = URLRequest(url: url)
        httpMethod = method.rawValue

        if let contentType = contentType {
            addValue(contentType.rawValue, forHTTPHeaderField: Mint.HeaderFieldKey.contentType.stringValue)
        }

        if let accept = accept {
            addValue(accept.rawValue, forHTTPHeaderField: Mint.HeaderFieldKey.accept.stringValue)
        }

        if let authorizationHeader = authorizationHeaderValue {
            setValue(authorizationHeader, forHTTPHeaderField: authorizationHeaderKey)
        } else if let token = token {
            setValue("Bearer \(token)", forHTTPHeaderField: authorizationHeaderKey)
        }

        if let headerFields = headerFields {
            for (key, value) in headerFields {
                setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}

extension URL {
    func getData() -> Data {
        let path = self.path
        guard let data = FileManager.default.contents(atPath: path) else { fatalError("Couldn't get image in destination url: \(self)") }

        return data
    }
}

extension HTTPURLResponse {
    convenience init(url: URL, statusCode: Int) {
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
