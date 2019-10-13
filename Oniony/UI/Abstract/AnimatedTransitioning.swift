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

/// Аниматор перехода.
open class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Длительность перехода, равна `0.8`.
    open var duration: TimeInterval {
        return 0.8
    }
    
    /// Длительность перехода, равна свойству `duration`.
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return duration
    }
    
    /// Анимирует переход.
    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let from = context.view(forKey: .from),
            let to = context.view(forKey: .to) else {
            return
        }
        
        self.animateTransition(
            from: from,
            to: to,
            using: context
        )
    }
    
    /// Более удобный метод анимации перехода.
    /// В него уже переданы от куда и куда идет переход.
    public func animateTransition(
        from: UIView,
        to: UIView,
        using context: UIViewControllerContextTransitioning) {
        fatalError(
            "AnimatedTransitioning",
            "Невозможно использовать абстрактный класс AnimatedTransitioning в качестве прямой реализации."
        )
    }
}
