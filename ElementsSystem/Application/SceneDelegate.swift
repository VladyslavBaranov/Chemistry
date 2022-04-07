//
//  SceneDelegate.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 03.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let controller = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav = UINavigationController(rootViewController: controller)
        window?.rootViewController = nav
		
		let appearanceId = UserDefaultsHelper.shared.getAppearanceId()
		switch appearanceId {
		case 0:
			window?.overrideUserInterfaceStyle = .unspecified
		case 1:
			window?.overrideUserInterfaceStyle = .light
		case 2:
			window?.overrideUserInterfaceStyle = .dark
		default:
			break
		}
		
		
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

