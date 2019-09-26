/*
* Copyright (c) 2019  WebView, Lab
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Swinject

/// Основной координатор навигации приложения.
final public class SplashScreenCoordinator {
    
    /// Основное окно приложения.
    public let window: UIWindow
    
    /// DI-контейнер для работы координатора.
    private let container: Container
    
    /// Основной конструктор координатора для указанного окна и
    /// DI-контейнера.
    public init(for window: UIWindow, in container: Container) {
        self.window = window
        self.container = container
    }
    
    /// Запускает навигацию проекта.
    /// Презентует модуль запуска приложения.
    public func start() {
        self.window.rootViewController = container.resolve(SplashScreenController.self)!
        self.window.makeKeyAndVisible()
    }
}
