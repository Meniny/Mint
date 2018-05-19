
import Foundation

public protocol DataSerialization {
    associatedtype SerializedType
    static func serialize(_ data: Data) throws -> SerializedType
}

public extension Mint {
    public enum Result<E: Error, S: DataSerialization> {
        case success(S.SerializedType, HTTPURLResponse)
        case failure(E, HTTPURLResponse)
        
        public init(data: Data, response: HTTPURLResponse) {
            do {
                let target = try S.serialize(data)
                self = .success(target, response)
            } catch {
                self = .failure(error as! E, response)
            }
        }
    }
    
    public struct DataSerializer: DataSerialization {
        public typealias SerializedType = Data
        public static func serialize(_ data: Data) throws -> Data {
            return data
        }
    }
    
    public struct JSONSerializer: DataSerialization {
        public typealias SerializedType = JSON
        public static func serialize(_ data: Data) throws -> JSON {
            return try JSON.init(data)
        }
    }
    
    public struct StringSerializer: DataSerialization {
        public typealias SerializedType = String
        public static func serialize(_ data: Data) throws -> String {
            guard let str = String.init(data: data, encoding: .utf8) else {
                let ne = NSError(domain: Mint.domain, code: 0, userInfo: [ NSLocalizedDescriptionKey: NSLocalizedString("Malformed data", comment: "")])
                throw ne
            }
            return str
        }
    }
    
    public struct ImageSerializer: DataSerialization {
        public typealias SerializedType = MintImage
        public static func serialize(_ data: Data) throws -> MintImage {
            guard let image = MintImage.init(data: data) else {
                let ne = NSError(domain: Mint.domain, code: 0, userInfo: [ NSLocalizedDescriptionKey: NSLocalizedString("Malformed data", comment: "")])
                throw ne
            }
            return image
        }
    }
    
    public typealias DataResult = Result<NSError, Mint.DataSerializer>
    public typealias JSONResult = Result<NSError, Mint.JSONSerializer>
    public typealias StringResult = Result<NSError, Mint.StringSerializer>
    public typealias ImageResult = Result<NSError, Mint.ImageSerializer>
}
