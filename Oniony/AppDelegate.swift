/**
 AppDelegate.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
 */

import UIKit
import EasySwift

/// Делегат приложения.
@UIApplicationMain
final public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// Конфигурутор системы внедрения зависимостей проекта.
    private let configurator: SwinjectConfigurator = {
        let c = SwinjectConfigurator.shared
        c.configure()
        return c
    }()

    /// Настраивает стандартную конфигурацию сцены.
    func application(
        _ application: UIApplication,
        didConnect session: UISceneSession
    ) -> UISceneConfiguration {
        return UISceneConfiguration.default(role: session.role)
    }
}
