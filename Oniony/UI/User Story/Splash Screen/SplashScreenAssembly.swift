/**
 SplashScreenAssembly.swift
 
 Oniony
 
 Copyright (c) 2019  WebView, Lab. All rights reserved.
 */

import Swinject
import SwiftUI

/// Сборщик модуля запуска.
@objcMembers
final public class SplashScreenAssembly: AutoAssembly {
    
    /// Отображение модуля.
    internal func splashScreen() {
        container?.register(SplashScreen.self, factory: { (_) -> SplashScreen in
            let spl = SplashScreen()
            return spl
        })
    }
    
    /// Контроллер модуля.
    internal func splashScreenController() {
        container?.register(SplashScreenController.self, factory: { (resolver) -> SplashScreenController in
            let view = resolver.resolve(SplashScreen.self)!
            let c = SplashScreenController(rootView: view)
            return c
        })
    }
}
