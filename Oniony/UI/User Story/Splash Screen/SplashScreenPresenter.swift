/**
 SplashScreenPresenter.swift
 
 Oniony
 
 Copyright (c) 2019 Georgiy Cheremnykh. All rights reserved.
 */

import SwiftUI
import Combine

/// Презентер модуля запуска.
final public class SplashScreenPresenter: ObservableObject {
    
    /// Прогресс загрузки.
    public var progress = CGFloat()
    
    /// Описание текущего процента загрузки.
    public var description = "Идет загрузка тор-сети..."
}
