/**
 SceneDelegate.swift

 Oniony

 Copyright (c) 2019 WebView, Lab. All rights reserved.
*/

import SwiftUI
import EasySwift

/// Делегат сцены приложения.
final public class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// Основное окно приложения.
    public var window: UIWindow?
    
    /// Корневой координатор навигации.
    public var coordinator: AppCoordinator?

    /// Сцена была создана.
    public func windowSceneWillConnect(_ scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        let container = SwinjectConfigurator.shared.container
        let coordinator = AppCoordinator(for: window, in: container)
        coordinator.start()
        
        self.coordinator = coordinator
        self.window = window
    }
}
