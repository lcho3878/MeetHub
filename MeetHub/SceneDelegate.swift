//
//  SceneDelegate.swift
//  MeetHub
//
//  Created by 이찬호 on 8/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var networkMonitor = NetworkMonitor()
    
    var window: UIWindow?
    
    var errorWindow: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        if !UserDefaultsManager.shared.token.isEmpty {
            window?.rootViewController = TabBarController()
//            window?.rootViewController = UINavigationController(rootViewController: PostingViewController())
        }
        else {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
            
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        networkMonitor.stopMonitoring()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        networkMonitor.startMonitoring { [weak self] connection in
            switch connection {
            case .satisfied:
                print("네트워크 연결 정상")
                self?.removeNetworkErrorView()
            case .unsatisfied:
                print("네트워크 연결 불량")
                self?.loadNetworkErrorView(on: scene)
            default: break
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func loadNetworkErrorView(on scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = .statusBar
        window.makeKeyAndVisible()
        
        let noNetworkView = NetworkErrorView(frame: window.bounds)
        window.addSubview(noNetworkView)
        self.errorWindow = window
    }

    private func removeNetworkErrorView() {
        errorWindow?.resignKey()
        errorWindow?.isHidden = true
        errorWindow = nil
    }
}
