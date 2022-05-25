//
//  SceneDelegate.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 18.04.2022.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
    }
    //MARK: TabBarController
    
    func createAteroidsViewController() -> UINavigationController {
        let asteroidsViewController = AsteroidViewController()
        asteroidsViewController.title = "Армагеддон 2022"
        asteroidsViewController.tabBarItem = UITabBarItem(title: "Астероиды", image: UIImage(systemName: "doc.richtext"), tag: 0)
        return UINavigationController(rootViewController: asteroidsViewController)
    }
    func createDestroyViewController() -> UINavigationController {
        let destroyViewController = DestructionViewController()
        destroyViewController.title = "Уничтожение"
        destroyViewController.tabBarItem = UITabBarItem(title: "Уничтожение", image: UIImage(systemName: "person.circle"), tag: 1)
        destroyViewController.viewDidLoad()
        let count = destroyViewController.arrayOfDestroy.count
        destroyViewController.tabBarItem.badgeValue = "\(count)"
        return UINavigationController(rootViewController: destroyViewController)
    }
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        UITabBar.appearance().backgroundColor = .white
        tabBarController.viewControllers = [self.createAteroidsViewController(), self.createDestroyViewController()]
        
        
        
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

