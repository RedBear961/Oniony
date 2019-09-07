/**
 NavigationCoordinator.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
 */

import UIKit
import Swinject

/// Протокол координатора навигации в приложении.
public protocol NavigationCoordinator {
    
    /// Обобщение над управляемым модулем.
    associatedtype Controller: UIViewController
    
    /// Управляемый модуль.
    var controller: Controller { get }
    
    /// Основной конструктор координатора.
    /// - Parameter container: DI-контейнер приложения.
    init(container: Container)
    
    /// Запускает показ модуля.
    func show(on controller: UIViewController)
}
