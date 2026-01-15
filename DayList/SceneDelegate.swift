//
//  SceneDelegate.swift
//  DayList
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check for existing session
        if SessionManager.shared.restoreSession() {
            // User has active session - Go to Today screen
            showTodayViewController()
        } else {
            // No session - Show Onboarding
            showOnboardingViewController()
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func showOnboardingViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        window?.rootViewController = onboardingVC
    }
    
    private func showTodayViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let todayVC = storyboard.instantiateViewController(withIdentifier: "TodayViewController")
        window?.rootViewController = todayVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
