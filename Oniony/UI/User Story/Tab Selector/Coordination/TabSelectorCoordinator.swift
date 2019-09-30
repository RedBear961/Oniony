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
import UIKit

/// Координатор модуля переключения вкладок.
final public class TabSelectorCoordinator: NavigationCoordinator {

    /// Модуль переключения вкладок.
    public private(set) var controller: TabSelectorController!
    
    /// DI-контейнер для работы координатора.
    private var container: Container
    
    /// Делегат перехода на контроллер переключения вкладок.
    private var transitiongDelegate = TabSelectorTransitioningDelegate()
    
    /// Контроллер навигации.
    private var navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.navigationBar.barStyle = .black
        nc.isToolbarHidden = false
        nc.toolbar.barStyle = .black
        return nc
    }()

    /// Основной конструктор координатора.
    /// - Parameter container: DI-контейнер приложения.
    public init(container: Container) {
        self.container = container
        self.controller = container.resolve(TabSelectorController.self, argument: self)!
        navigationController.transitioningDelegate = transitiongDelegate
        navigationController.modalPresentationStyle = .fullScreen
    }

    /// Запускает показ модуля.
    public func show(on controller: SplashScreenController) {
        navigationController.pushViewController(self.controller!, animated: true)
        controller.present(navigationController, animated: true)
    }
}
