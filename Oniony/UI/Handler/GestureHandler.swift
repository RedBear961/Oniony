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

/// Делегат обработчика жестов.
///
/// Наследника класса `GestureHandler` могут наследовать
/// протоколы своих делегатов от этого, если переносят ответственность
/// за определение рабочего отображения на своего делегата.
public protocol GestureHandlerDelegate: class {
    
    /// Оповещает делегата, что собирается начать обработку жеста.
    ///
    /// В момент начала обработки жеста, запрашивает делегата
    /// отображение, с которым будет работать.
    /// Если возвращаемое значение равно `nil`, прекратит обработку.
    func gestureHandler(viewAt point: CGPoint) -> UIView?
}

/// Протокол конкретного распознавателя жестов.
///
/// Абстрактный класс `GestureHandler` определеяет
/// этот протокол пустыми реализациями. Наследники
/// этого класса должны переопределить эти методы,
/// чтобы обеспечить обработку жеста.
public protocol ConcreteGestureHandler {
    
    /// Рабочее отображение.
    associatedtype WorkView: UIView
    
    /// Запрашивает рабочее отображение в координате.
    /// - Parameter point: Точка в координатной системе отображения
    /// к которому прикреплен распознаватель.
    func view(at point: CGPoint) -> WorkView?
    
    /// Обработать начало жеста.
    /// - Parameter point: Точка в координатной системе рабочего отображения.
    func handleBegan(for view: WorkView, at point: CGPoint)
    
    /// Обработать продолжение жеста.
    /// - Parameter point: Точка в координатной системе рабочего отображения.
    func handleChanged(for view: WorkView, at point: CGPoint)
    
    /// Обработать конец жеста.
    /// - Parameter point: Точка в координатной системе рабочего отображения.
    func handleEnded(for view: WorkView, at point: CGPoint)
    
    /// Обработать остальные состояния жеста.
    /// - Parameter point: Точка в координатной системе рабочего отображения.
    func handleOther(for view: WorkView, at point: CGPoint)
}

/// Абстрактный класс обработчика жестов.
///
/// Используйте конкретные реализации обработчика.
/// Вы также можете создать собственный экземпляр
/// и переопределить методы протокола `ConcreteGestureHandler`
/// для произвольной обработки.
open class GestureHandler<Recognizer: UIGestureRecognizer, View: UIView>: ConcreteGestureHandler {
    
    /// Экземпляр получателя жестов.
    public let gesture: Recognizer
    
    /// Отображение, на котором расположен распознаватель.
    public let parentView: UIView
    
    /// Экземпляр UIView с которой будет работать обработчик.
    public var view: View?
    
    /// Основной конструктор.
    /// - Parameter view: Отображение на котором будет работать жест.
    public init(for view: UIView) {
        self.parentView = view
        self.gesture = Recognizer()
        self.gesture.addTarget(self, action: #selector(handle(_:)))
        view.addGestureRecognizer(self.gesture)
    }
    
    /// Первоначальная обработка жеста.
    @objc private func handle(_ gesture: UIGestureRecognizer) {
        guard let view = obtainView() else {
            return
        }
        
        let parentView = gesture.view!
        let pos = gesture.location(in: parentView)
        let convertedPos = view.convert(pos, from: parentView)
        
        switch gesture.state {
            case .began:
                self.handleBegan(for: view, at: convertedPos)
            
            case .changed:
                self.handleChanged(for: view, at: convertedPos)
                
            case .ended:
                self.handleEnded(for: view, at: convertedPos)
            
            default:
                break
        }
    }
    
    /// Пытается получить экземмпляр рабочего отображения.
    private func obtainView() -> View? {
        guard let view = view else {
            let parentView = gesture.view!
            let point = gesture.location(in: parentView)
            let workView = self.view(at: point)
            self.view = workView
            return self.view
        }
        return view
    }
    
    /// Отображение для точки начала жеста.
    ///
    /// Реализация абстрактного класса всегда возвращает `nil`.
    /// Наследники должны переопределить этот метод.
    public func view(at point: CGPoint) -> View? { return nil }
    
    /// Обработчик начала жеста, распознаватель перешел в статус `began`.
    ///
    /// Наследники должны переопределить этот метод.
    public func handleBegan(for view: View, at point: CGPoint) {}
    
    /// Обработчик продолжения жеста, распознаватель перешел в статус `changed`.
    ///
    /// Наследники должны переопределить этот метод.
    public func handleChanged(for view: View, at point: CGPoint) {}
    
    /// Обработчик конца жеста, распознаватель перешел в статус `ended`.
    ///
    /// Наследники должны переопределить этот метод.
    public func handleEnded(for view: View, at point: CGPoint) {}
    
    /// Обработчик остальных состояний жеста.
    ///
    /// Наследники могут переопределить этот метод.
    public func handleOther(for view: View, at point: CGPoint) {}
}
