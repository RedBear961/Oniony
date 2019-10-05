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

public protocol PanHandlerDelegate: class {
    
    /// Оповещает делегата, что собирается начать обработку жеста.
    ///
    /// В момент начала обработки жеста, запрашивает делегата
    /// отображение, с которым будет работать.
    /// Если возвращаемое значение равно `nil`, прекратит обработку.
    func panHandler(viewIn point: CGPoint) -> UIView?
    
    /// Жест начался в точке.
    /// - Parameter point: Точка в координатной системе `view`.
    func panDidStart(in point: CGPoint, for view: UIView)
    
    /// Жест продолжен с изменением от изначальной позиции.
    func panContinued(with translation: CGPoint, for view: UIView)
    
    /// Жест закончен в точке.
    /// - Parameter point: Точка в координатной системе `view`.
    func panEnded(in point: CGPoint, for view: UIView)
}

/// Обработчика жеста движения.
public final class PanGestureHandler<View: UIView> {
    
    /// Экземмпляр получателя жестов.
    public let pan: UIPanGestureRecognizer
    
    /// Делегат обработчика жестов.
    public unowned var delegate: PanHandlerDelegate?
    
    /// Экземпляр UIView с которой будет работать обработчик.
    public var view: View?
    
    /// Изначальный центр рабочего отображения.
    public var defaultCenter: CGPoint?
    
    /// Основной конструктор.
    /// - Parameter view: Отображение на котором будет работать жест.
    public init(for view: UIView) {
        self.pan = UIPanGestureRecognizer()
        self.pan.addTarget(self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(self.pan)
    }
    
    /// Получает обновление жеста.
    @objc private func didPan(_ gesture: UIPanGestureRecognizer) {
        guard let view = workView() else {
            return
        }
        
        let parentView = pan.view!
        let pos = pan.location(in: parentView)
        let convertedPos = view.convert(pos, from: parentView)
        
        switch gesture.state {
            case .began:
                defaultCenter = view.center
                delegate?.panDidStart(in: convertedPos, for: view)
            
            case .changed:
                let translation = gesture.translation(in: view)
                delegate?.panContinued(with: translation, for: view)
                
            case .ended:
                delegate?.panEnded(in: convertedPos, for: view)
                fallthrough
            
            default:
                self.view = nil
                self.defaultCenter = nil
        }
    }
    
    /// Пытается получить рабочее отображение.
    private func workView() -> View? {
        guard let view = view else {
            let parentView = pan.view!
            let pos = pan.location(in: parentView)
            let workView = delegate?.panHandler(viewIn: pos) as? View
            self.view = workView
            return self.view
        }
        return view
    }
}
