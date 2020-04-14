//
//  SceneDelegate.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AuthCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            // create a basic UIWindow
            let window = UIWindow(windowScene: windowScene)

            // Select the root view controller based on logged in status
            let rootVC = self.setRootVC(window: window)
            window.rootViewController = rootVC
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func setRootVC(window: UIWindow) -> UIViewController {

        if Auth.auth().currentUser != nil {
            // User is logged in, go to tab bar controller
            return MainTabBarController()
        } else {
            // User is not logged in, go to root view
            let navController = UINavigationController()
            navController.setNavigationBarHidden(true, animated: false)
            
            // Start auth coordinator to control navigation
            coordinator = AuthCoordinator(navigationController: navController)
            coordinator?.start()
            
            return navController
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        // Log out session when app terminates
        _ = AuthManager.logout()
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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

