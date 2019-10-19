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

/// Делегат обработчика жеста движения.
public protocol PanHandlerDelegate: GestureHandlerDelegate {
    
    /// Жест начался в точке.
    /// - Parameter point: Точка в координатной системе `view`.
    func panDidStart(in point: CGPoint, for view: UIView)
    
    /// Жест продолжен с изменением от изначальной позиции.
    func panContinued(with translation: CGPoint, for view: UIView)
    
    /// Жест закончен в точке.
    /// - Parameter point: Точка в координатной системе `view`.
    func panEnded(in point: CGPoint, for view: UIView)
}

public extension PanHandlerDelegate {
    
    /// Жест начался в точке.
    func panDidStart(in point: CGPoint, for view: UIView) {}
    
    /// Жест продолжен с изменением от изначальной позиции.
    func panContinued(with translation: CGPoint, for view: UIView) {}
    
    /// Жест закончен в точке.
    func panEnded(in point: CGPoint, for view: UIView) {}
}

/// Обработчика жеста движения.
public final class PanGestureHandler<View: UIView>: GestureHandler<UIPanGestureRecognizer, View> {
    
    /// Делегат обработчика жестов.
    public weak var delegate: PanHandlerDelegate?
    
    /// Изначальный центр рабочего отображения.
    public var defaultCenter: CGPoint?
    
    /// Отображение для точки начала жеста.
    public override func view(at point: CGPoint) -> View? {
        return delegate?.gestureHandler(viewAt: point) as? View
    }
    
    /// Обработать начало жеста.
    public override func handleBegan(for view: View, at point: CGPoint) {
        defaultCenter = view.center
        delegate?.panDidStart(in: point, for: view)
    }
    
    /// Обработать продолжение жеста.
    public override func handleChanged(for view: View, at point: CGPoint) {
        let translation = gesture.translation(in: view)
        delegate?.panContinued(with: translation, for: view)
    }
    
    /// Обработать конец жеста.
    public override func handleEnded(for view: View, at point: CGPoint) {
        delegate?.panEnded(in: point, for: view)
        self.view = nil
        self.defaultCenter = nil
    }
}
