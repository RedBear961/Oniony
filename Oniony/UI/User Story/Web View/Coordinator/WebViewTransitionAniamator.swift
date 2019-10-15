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
    public var ratio: CGFloat
    
    /// Радиус углов.
    public var radius: CGFloat
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
        return WebViewAnimatedPresenting(using: context)
    }
    
    /// Создает аниматор закрытия модуля.
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return WebViewAnimatedDismissing(using: context)
    }
}

open class WebViewAnimatedTransitioning<FromVC, ToVC>: AnimatedTransitioning<FromVC, ToVC> {
    
    /// Контекст перехода.
    public let context: WebViewTransitionContext
    
    /// Основной конструктор.
    public init(using context: WebViewTransitionContext) {
        self.context = context
        super.init()
    }
    
    /// Находит отступы координат веб контроллера, чтобы он
    /// находился в центре ячейки.
    fileprivate func toOffset(
        to view: UIView,
        for context: WebViewTransitionContext
    ) -> CGPoint {
        let ratio = context.relation(to: view.frame)
        let size = view.size.scaledBy(0.5)
        let x = size.width * ratio.wRatio
        let y = size.height * ratio.hRatio
        return CGPoint(x: x, y: y)
    }
    
    fileprivate func adjust(
        _ to: UIView,
        with from: UIView,
        for context: WebViewTransitionContext
    ) {
        let wRatio = context.relation(to: from.frame).wRatio
        let offset = toOffset(to: from, for: context)
        let center = CGPoint(
            x: context.x + offset.x,
            y: context.y + offset.y
        )
        let radius = context.radius / wRatio
        var size = from.size
        size.height = size.width * context.ratio
        
        to.frame.size = size
        to.center = center
        to.transform = CGAffineTransform(scaled: wRatio)
        to.cornerRadius = radius
    }
}

/// Аниматор перехода на контроллер модуля веб отображения.
final public class WebViewAnimatedPresenting: WebViewAnimatedTransitioning<Never, UINavigationController> {
    
    /// Анимирует переход.
    public override func animateTransition(
        from: UIView,
        to: UIView,
        toVC: UINavigationController,
        using transitioningContext: UIViewControllerContextTransitioning
    ) {
        //  Настройка свойств начала анимации.
        toVC.setToolbarHidden(false, animated: false)
        let webview = toVC.root as! WebViewController
        let contentOffset = webview.contentOffset
        let container = transitioningContext.containerView
        
        adjust(to, with: from, for: context)
        container.addSubview(to)
        
        UIView.spring(with: duration, damping: 0.7, velocity: 0.2, animations: {
            to.transform = CGAffineTransform(scaled: 1)
            to.frame = from.frame
            to.cornerRadius = 0
            
            webview.contentOffset = contentOffset
        }, completion: { (_) in
            transitioningContext.completeTransition(true)
        })
    }
}

final public class WebViewAnimatedDismissing: WebViewAnimatedTransitioning<UINavigationController, Never> {
    
    /// Длительность закрытия.
    public override var duration: TimeInterval {
        return 0.4
    }
    
    /// Анимирует закрытие.
    public override func animateTransition(
        from: UIView,
        fromVC: UINavigationController,
        to: UIView,
        using transitioningContext: UIViewControllerContextTransitioning
    ) {
        //  Настройка свойств начала анимации.
        fromVC.setToolbarHidden(true, animated: true)
        let webview = fromVC.root as! WebViewController
        let contentOffset = webview.contentOffset
        let container = transitioningContext.containerView
        to.frame = from.frame
        container.insertSubview(to, belowSubview: from)
        
        // Анимирует переход.
        UIView.animate(with: duration, animations: {
            self.adjust(from, with: to, for: self.context)
            
            webview.contentOffset = .zero
        }, completion: { (_) in
            
            webview.contentOffset = contentOffset
            transitioningContext.completeTransition(true)
        })
    }
}
