//
//  SceneDelegate.swift
//  StorableExample
//
//  Created by Артемий on 16.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = Factory.build(scene: .main)
        window.makeKeyAndVisible()
        
        self.window = window
    }

}

