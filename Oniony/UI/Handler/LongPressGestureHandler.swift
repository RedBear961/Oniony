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

/// Делегат обработчика длительного нажатия.
public protocol LongPressHandlerDelegate: GestureHandlerDelegate {
    
    /// Началось длительное нажатие.
    /// - Parameter point: Точка в координатной системе `view`.
    func longPressBegan(in point: CGPoint, for view: UIView)
    
    /// Закончилось длительное нажатие.
    /// - Parameter point: Точка в координатной системе `view`.
    func longPressEnded(in point: CGPoint, for view: UIView)
}

/// Обработчик жеста длительного нажатия.
public final class LongPressGestureHandler<View: UIView>: GestureHandler<UILongPressGestureRecognizer, View> {
    
    /// Делегат обработчика жестов.
    public weak var delegate: LongPressHandlerDelegate?
    
    /// Отображение для точки начала жеста.
    public override func view(at point: CGPoint) -> View? {
        return delegate?.gestureHandler(viewAt: point) as? View
    }
    
    /// Обработать начало жеста.
    public override func handleBegan(for view: View, at point: CGPoint) {
        delegate?.longPressBegan(in: point, for: view)
    }
    
    /// Обработать конец жеста.
    public override func handleEnded(for view: View, at point: CGPoint) {
        delegate?.longPressEnded(in: point, for: view)
        self.view = nil
    }
}
