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

import Foundation
import EasySwift

/// Базовый протокол презентера модуля.
public protocol Presenter {
    
    /// Модуль был загружен.
    func viewDidLoad()
    
    /// Отображение будет показано.
    func viewWillAppear()
    
    /// Отображение было показано.
    func viewDidAppear()
}

public extension Presenter {
    
    /// Модуль был загружен.
    func viewDidLoad() {
        fatalError("\(type(of: self))", "viewDidLoad is not implemented.")
    }
    
    /// Отображение будет показано.
    func viewWillAppear() {
        fatalError("\(type(of: self))", "viewWillAppear is not implemented.")
    }
    
    /// Отображение было показано.
    func viewDidAppear() {
        fatalError("\(type(of: self))", "viewDidAppear is not implemented.")
    }
}

/// Базовый протокол модуля, управляющего коллекцией.
public protocol CollectionPresenter: Presenter {
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int
    
    /// Удаляет ячейку по индексу пути.
    /// - Returns: Количество секций после удаления.
    func removeItem(at indexPath: IndexPath) -> Int
}

public extension CollectionPresenter {
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int {
        fatalError("\(type(of: self))", "numberOfSections is not implemented.")
    }
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int {
        fatalError("\(type(of: self))", "numberOfItems is not implemented.")
    }
    
    /// Удаляет ячейку по индексу пути.
    /// - Returns: Количество секций после удаления.
    func removeItem(at indexPath: IndexPath) -> Int {
        fatalError("\(type(of: self))", "removeItem is not implemented.")
    }
}
