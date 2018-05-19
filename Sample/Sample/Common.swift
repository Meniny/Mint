
import Foundation
import Mint

public struct SampleProject {
    public static let mint = Mint.init(baseURL: "https://meniny.cn/api/v2/")
    
    public static func getPosts() {
        print("Requesting...")
        self.mint.get("posts.json") { (result) in
            print("Done.")
            switch result {
            case .success(let response):
                print(response.dictionaryBody)
            case .failure(let response):
                print(response.error.localizedDescription)
            }
        }
    }
    
    public static let downloader = Mint.init(baseURL: "https://meniny.cn/assets/images/")
    
    public static func getImage() {
        print("Downloading...")
        self.downloader.downloadImage("fire.jpg") { (result) in
            print("Done.")
            switch result {
            case .success(let resp):
                print(resp.image)
            case .failure(let resp):
                print(resp.error.localizedDescription)
            }
        }
    }
}
