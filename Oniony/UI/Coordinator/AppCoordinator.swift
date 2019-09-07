/**
 AppCoordinator.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
 */

import UIKit
import Swinject

/// Основной координатор навигации приложения.
final public class AppCoordinator {
    
    /// Основное окно приложения.
    public let window: UIWindow
    
    /// Корневой контроллер навигации приложения.
    public let navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }()
    
    /// DI-контейнер для работы координатора.
    private let container: Container
    
    /// Основной конструктор координатора для указанного окна и
    /// DI-контейнера.
    public init(window: UIWindow, container: Container) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        self.container = container
    }
    
    /// Запускает навигацию проекта.
    /// Презентует модуль запуска приложения.
    public func start() {
    }
}
