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

public protocol WebViewCoordinatorDelegate: class {
}

final public class WebViewCoordinator: NSObject, NavigationCoordinator {

    /// Модуль переключения вкладок.
    public private(set) var controller: WebViewController!
    
    /// Контекст перехода на модуль веб отображения.
    public private(set) var context: WebViewTransitionContext?
    
    /// Делегат координатора.
    public weak var delegate: WebViewCoordinatorDelegate?
    
    /// DI-контейнер для работы координатора.
    private var container: Container
    
    /// Основной конструктор координатора.
    /// - Parameter container: DI-контейнер приложения.
    public init(container: Container) {
        self.container = container
        super.init()
        self.controller = container.resolve(WebViewController.self, argument: self)!
        self.controller.modalPresentationStyle = .fullScreen
    }

    /// Запускает показ модуля.
    public func show(on controller: UINavigationController) {
        controller.delegate = self
        controller.pushViewController(self.controller, animated: false)
    }
    
    /// Запускает показ модуля, используя контекст представления.
    public func show(on controller: UINavigationController, using context: WebViewTransitionContext) {
        self.context = context
        controller.delegate = self
        controller.pushViewController(self.controller, animated: true)
    }
    
    /// Закрывает модуль.
    ///
    /// Если для показа модуля был использован контекст,
    /// этот контекст будет использован и для закрытия.
    public func close() {
        controller.navigationController?.popViewController(animated: true)
    }
}

extension WebViewCoordinator: UINavigationControllerDelegate {
    
    /// Создает аниматора перехода.
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let context = context else {
            return nil
        }
        
        switch fromVC {
            case is TabSelectorController:
                return WebViewAnimatedPresenting(using: context)
            
            case is WebViewController:
                return WebViewAnimatedDismissing(using: context)
            
            default:
                return nil
        }
    }
}
