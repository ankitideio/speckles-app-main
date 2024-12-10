//
//  AppDelegate.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//


import UIKit
import SwiftKeychainWrapper
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        Thread.sleep(forTimeInterval: 3.0)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainNavigationBarColor()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkText]
        
        UINavigationBar.appearance().tintColor = .darkText
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        NotificationCenter.default.addObserver(self, selector: #selector(_applicationDidEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let firstLaunch = !UserDefaults.standard.bool(forKey: "FirstiSignLaunch")
        if firstLaunch {
            UserDefaults.standard.set(true, forKey: "FirstiSignLaunch")
            KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.apiToken.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationPasscode.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
        }
        
       SyncManager.shared.startSync()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    // MARK: -
    
    @objc private func _applicationDidEnterBackground() {
        UserDefaults.standard.set(Date(), forKey: "LastEnterBackground")
    }

    @objc private func _applicationWillEnterForeground() {

        guard APIManager.shared.currentUserState == .signedIn else {
            return
        }

        let passcodeEnabled = !(KeychainWrapper.standard.string(forKey: .applicationPasscode) ?? "").isEmpty
        let biometricsEnabled = !(KeychainWrapper.standard.string(forKey: .applicationBiometricsEnabled) ?? "").isEmpty
        guard passcodeEnabled || biometricsEnabled else {
            return
        }

        guard let lastEnterBackground = UserDefaults.standard.value(forKey: "LastEnterBackground") as? Date else {
            return
        }

        guard Date().timeIntervalSince(lastEnterBackground) > 20 else {
            return
        }

        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard var topController = keyWindow?.rootViewController else {
            return
        }

        while let presentedViewController = topController.presentedViewController {
            if let alert = presentedViewController as? UIAlertController {
                alert.dismiss(animated: false)
                break
            }
            topController = presentedViewController
        }

        if let _ = topController as? LocalAuthViewController {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "localAuth") as? LocalAuthViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        topController.present(vc, animated: false)

    }

    func changeStoryboard() {

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeStoryboard()
        }

    }


}

