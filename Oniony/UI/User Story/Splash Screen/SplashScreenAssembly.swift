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
        container?.register(SplashScreen.self, factory: { (resolver) -> SplashScreen in
            let p = resolver.resolve(SplashScreenPresenter.self)!
            let spl = SplashScreen(presenter: p)
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
    
    /// Презентер модуля.
    internal func splashScreenPresenter() {
        container?.register(SplashScreenPresenter.self, factory: { (_) -> SplashScreenPresenter in
            let p = SplashScreenPresenter()
            return p
        })
    }
}
