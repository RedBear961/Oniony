/**
 AppDelegate.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
 */

import UIKit
import EasySwift

/// Делегат приложения.
@UIApplicationMain
final public class AppDelegate: ESAppDelegate {
    
    /// Конфигурутор системы внедрения зависимостей проекта.
    private let configurator: SwinjectConfigurator = {
        let c = SwinjectConfigurator.shared
        c.configure()
        return c
    }()
}
