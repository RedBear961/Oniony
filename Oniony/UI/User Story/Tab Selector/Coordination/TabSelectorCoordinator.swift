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

import Swinject
import SwiftUI

/// Координатор модуля переключения вкладок.
final public class TabSelectorCoordinator: NavigationCoordinator {

    /// Модуль переключения вкладок.
    public private(set) var controller: TabSelectorController
    
    /// DI-контейнер для работы координатора.
    private var container: Container
    
    /// Делегат перехода на контроллер переключения вкладок.
    private var transitiongDelegate = TabSelectorTransitioningDelegate()

    /// Основной конструктор координатора.
    /// - Parameter container: DI-контейнер приложения.
    public init(container: Container) {
        let controller = container.resolve(TabSelectorController.self)!
        controller.transitioningDelegate = transitiongDelegate
        controller.modalPresentationStyle = .fullScreen
        
        self.controller = controller
        self.container = container
    }

    /// Запускает показ модуля.
    public func show(on controller: SplashScreenController) {
        controller.present(self.controller, animated: true)
    }
}