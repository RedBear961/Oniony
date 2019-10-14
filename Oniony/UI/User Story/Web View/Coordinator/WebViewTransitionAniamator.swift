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
import EasySwift

/// Контекст перехода с экрана вкладок на экран браузера.
///
/// Содержит основные параметры начального состояния
/// контроллера веб отображения.
public struct WebViewTransitionContext: RectPresentable, Relatable {
    
    /// Начальный фрейм контроллера.
    public var frame: CGRect
    
    /// Начальное соотношение сторон.
    public var aspectRatio: CGFloat
    
    /// Радиус углов.
    public var cornerRadius: CGFloat
}

/// Делегат перехода на контроллер веб отображения.
final public class WebViewTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /// Контекст перехода.
    public let context: WebViewTransitionContext
    
    /// Основной конструктор.
    public init(with context: WebViewTransitionContext) {
        self.context = context
        super.init()
    }

    /// Создает аниматор перехода для контроллера переключения вкладок.
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return WebViewAnimatedTransitioning(using: context)
    }
}

/// Аниматор перехода на контроллер модуля веб отображения.
final public class WebViewAnimatedTransitioning: AnimatedTransitioning {
    
    /// Контекст перехода.
    public let context: WebViewTransitionContext
    
    /// Основной конструктор.
    public init(using context: WebViewTransitionContext) {
        self.context = context
        super.init()
    }
    
    /// Анимирует переход.
    public override func animateTransition(
        from: UIView,
        to: UIView,
        using transitioningContext: UIViewControllerContextTransitioning
    ) {
        let toVC = transitioningContext.viewController(forKey: .to)
        let navigationController = toVC as? UINavigationController
        navigationController?.setToolbarHidden(false, animated: true)
        
        let container = transitioningContext.containerView
        let ratio = context.relation(to: from.frame)
        let xOffset = from.size.width / 2 * ratio.wRatio
        let yOffset = from.size.height / 2 * ratio.hRatio
        
        var initialSize = from.size
        initialSize.height = initialSize.width * context.aspectRatio
        
        to.frame.size = initialSize
        to.center = CGPoint(x: context.x + xOffset, y: context.y + yOffset)
        to.transform = CGAffineTransform(scaled: ratio.wRatio)
        to.backgroundColor = .white
        to.cornerRadius = context.cornerRadius / ratio.wRatio
        container.addSubview(to)
        
        UIView.spring(with: duration, damping: 0.7, velocity: 0.2, animations: {
            to.transform = CGAffineTransform(scaled: 1)
            to.frame = from.frame
            to.cornerRadius = 0
        }, completion: { (_) in
            transitioningContext.completeTransition(true)
        })
    }
}
