
import Foundation
import Mint

public struct SampleProject {
    public static let mint = Mint.init(baseURL: "https://meniny.cn/api/v2/")
    
    public static func common() {
        print("Requesting...")
        mint.request("portfolio_repos.json", method: .get, parameter: .none, completion: { (data, resp) in
            print("Done.")
            print(String.init(data: data, encoding: .utf8) ?? "nil", resp.statusCode)
        }, failure: { error, resp in
            print("Done.")
            print(error.localizedDescription, resp.statusCode)
        })
    }
    
    public static func getJSON() {
        print("Requesting...")
        mint.get("blogroll.json") { (result: Mint.JSONResult) in
            print("Done.")
            switch result {
            case .success(let json, _):
                print(json.dictionary)
            case .failure(let error, let response):
                print(error.localizedDescription, response.statusCode)
            }
        }
    }
    
    public static let downloader = Mint.init(baseURL: "https://meniny.cn/assets/images/")
    
    public static func getImage() {
        print("Downloading...")
        downloader.downloadImage("fire.jpg") { (result) in
            print("Done.")
            switch result {
            case .success(let image, _):
                print(image)
            case .failure(let error, let response):
                print(error, response.statusCode)
            }
        }
    }
}
