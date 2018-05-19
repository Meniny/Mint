
import Foundation

public extension Mint {
    
    public enum CachePolicy: UInt, Equatable {
        case useProtocolCachePolicy = 0
        case reloadIgnoringLocalCacheData = 1
        case returnCacheDataElseLoad = 2
        case returnCacheDataDontLoad = 3
    }
}
