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

/// Делегат перехода на контроллер переключения вкладок.
final public class TabSelectorTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    /// Создает аниматор перехода для контроллера переключения вкладок.
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return TabSelectorAnimatedTransitioning()
    }
}

/// Аниматор перехода на контроллер модуля переключения вкладок.
final public class TabSelectorAnimatedTransitioning: AnimatedTransitioning<Never, Never> {
    
    /// Анимирует переход.
    public override func animateTransition(
        from: UIView,
        to: UIView,
        using context: UIViewControllerContextTransitioning
    ) {
        let container = context.containerView
        let transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        to.alpha = 0
        to.frame = from.frame
        to.transform = transform
        container.addSubview(to)
        
        UIView.animate(withDuration: 0.8, animations: {
            to.alpha = 1
            to.transform = CGAffineTransform(scaled: 1)
            
            from.alpha = 0
            from.transform = transform
            
        }, completion: { (_) in
            context.completeTransition(true)
        })
    }
}
