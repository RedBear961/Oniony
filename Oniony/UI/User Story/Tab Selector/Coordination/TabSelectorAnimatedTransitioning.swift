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

/// Аниматор перехода на контроллер модуля переключения вкладок.
final public class TabSelectorAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Длительность перехода.
    private let duration: TimeInterval = 0.8
    
    /// Длительность перехода в зависимости от контекста (протокольный метод).
    public func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /// Функция анимации перехода.
    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        let from = context.view(forKey: .from)!
        let to = context.view(forKey: .to)!
        let container = context.containerView
        let reducedScale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        to.alpha = 0
        to.frame = from.frame
        to.transform = reducedScale
        container.addSubview(to)
        
        UIView.animate(withDuration: duration, animations: {
            to.alpha = 1
            to.transform = CGAffineTransform.unit
            
            from.alpha = 0
            from.transform = reducedScale
            
        }, completion: { (_) in
            context.completeTransition(true)
        })
    }
}
