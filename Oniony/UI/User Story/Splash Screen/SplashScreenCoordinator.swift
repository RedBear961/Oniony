/**
 SplashScreenCoordinator.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
 */

import SwiftUI
import EasySwift
import Swinject

/// Координатор модуля запуска.
final public class SplashScreenCoordinator: NavigationCoordinator {

    /// Контроллер модуля запуска.
    public let controller: SplashScreenController
    
    /// DI-контейнер.
    private let container: Container
    
    /// Основной конструктор.
    public init(container: Container) {
        self.controller = container.resolve(SplashScreenController.self)!
        self.container = container
    }
    
    /// Отображает модуль запуска.
    public func show(on controller: UIViewController) {
        guard let navVC = controller as? UINavigationController else {
            fatalError("SplashScreenCoordinator", "Необходимо предоставить контроллер навигации!")
        }
        
        navVC.pushViewController(self.controller, animated: true)
    }
}
