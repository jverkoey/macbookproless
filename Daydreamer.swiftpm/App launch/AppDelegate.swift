import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = MainSceneDelegate.self
        
        return config
    }
    
}


//let fileKey = "lUfHc6IcPjXVgVVVWjDgpx"
//
//let data = Config.fileData.data(using: .utf8)!
//let decoder = JSONDecoder()
//
//do {
//    let file = try decoder.decode(Figma.File.self, from: data)
//    file
//    let node = file.document.children![0]
//    print("id: \(node.id)")
//    print("type: \(node.type)")
//    print("data: \(node.data)")
//} catch {
//    print("Failed to decode file \(error)")
//    print(String(data: data, encoding: .utf8)!)
//    exit(0)
//}
