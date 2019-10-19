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

/// Протокол управляющего вкладками.
public protocol TabsManagement {
    
    /// Текущее количество вкладок.
    var count: Int { get }
    
    /// Текущая вкладка.
    ///
    /// Если вкладки отсутствуют, создаст
    /// новую руководствуясь политикой
    /// создания вкладок.
    func currentTab() -> Tab
    
    /// Выдает вкладку по ее индексу.
    func tab(at index: UInt) -> Tab?
    
    /// Назначает новую действующую вкладку.
    ///
    /// Действующуй вкладкой считается вкладка,
    /// имеющая индекс `0`.
    /// Назначение новой вкладки переммещает
    /// ее в начало массива, в индекс `0`.
    ///
    /// - Parameter index: Индекс выбираемой
    /// вкладки. Выбор уже выбранной вкладки
    /// (вкладки с индексом `0`) или выбор вкладки за
    /// пределами массива не приведет к  результату,
    /// функция проигнорирует выбор.
    func selectTab(at index: UInt)
    
    /// Удаляет вкладку по индексу.
    func removeTab(at index: UInt)
    
    /// Начинает новую сессию.
    ///
    /// При запуске приложения, выполнит проверку
    /// на существование сохраненных вкладок в БД.
    /// Этой проверки  не будет, если политика вкладок
    /// запрещает их сохранение.
    func beginSession()
    
    /// Выполняет действия по завершению сессии
    /// пользователя.
    ///
    /// Если политика вкладок разрешает их сохранение,
    /// выполнит сохранение, иначе просто удалит их.
    ///
    /// - Note: Эту функцию необходимо вызвать по
    /// завершению приложения.
    func finishSession()
}

/// Делегат, контролирующий изменения вкладок.
public protocol TabsControlDelegate: class {
}

/// Управляющий вкладками класс.
final public class TabsManager: TabsManagement {

    /// Все открытые вкладки.
    public var tabs: [Tab] = []
    
    /// Текущее количество вкладок.
    public var count: Int {
        return tabs.count
    }
    
    /// Основной конструктор.
    public init() {
    }
    
    /// Текущая вкладка.
    public func currentTab() -> Tab {
        if let tab = tabs.first {
            return tab
        }

        let new = Tab()
        tabs.append(new)
        return new
    }
    
    /// Выдает вкладку по ее индексу.
    public func tab(at index: UInt) -> Tab? {
        let i = Int(index)
        guard i < tabs.count else {
            return nil
        }
        
        return tabs[i]
    }
    
    /// Назначает новую действующую вкладку.
    public func selectTab(at index: UInt) {
        let i = Int(index)
        guard i < tabs.count, i != 0 else {
            return
        }
        
        let tab = tabs[i]
        tabs.remove(at: i)
        tabs.insert(tab, at: 0)
    }
    
    /// Удаляет вкладку по индексу.
    public func removeTab(at index: UInt) {
        let i = Int(index)
        guard i < tabs.count else {
            return
        }
        
        tabs.remove(at: i)
    }
    
    /// Начинает новую сессию.
    public func beginSession() {
    }
    
    /// Выполняет действия по завершению сессии
    /// пользователя.
    public func finishSession() {
    }
}

/// Мок мменеджера вкладок.
public final class TabsManagerMock: TabsManagement {
    
    /// Все открытые вкладки.
    public var tabs: [Tab] = [
        Tab(with: URL(string: "https://yandex.ru")!),
        Tab(with: URL(string: "https://google.com")!),
        Tab(with: URL(string: "https://mail.ru")!),
        Tab(with: URL(string: "https://yandex.ru")!),
        Tab(with: URL(string: "https://google.com")!),
        Tab(with: URL(string: "https://mail.ru")!),
        Tab(with: URL(string: "https://yandex.ru")!),
        Tab(with: URL(string: "https://google.com")!)
    ]
    
    /// Текущее количество вкладок.
    public var count: Int {
        return tabs.count
    }
    
    private var _currentTab: Tab
    
    /// Основной конструктор.
    public init() {
        _currentTab = tabs.first!
    }
    
    /// Текущая вкладка.
    public func currentTab() -> Tab {
        return _currentTab
    }

    /// Выдает вкладку по ее индексу.
    public func tab(at index: UInt) -> Tab? {
        let i = Int(index)
        guard i < tabs.count else {
            return nil
        }
        
        return tabs[i]
    }
    
    /// Назначает новую действующую вкладку.
    public func selectTab(at index: UInt) {
        let i = Int(index)
        guard i < tabs.count else {
            return
        }
        
        let tab = tabs[i]
        _currentTab = tab
    }
    
    /// Удаляет вкладку по индексу.
    public func removeTab(at index: UInt) {
        let i = Int(index)
        guard i < tabs.count else {
            return
        }
        
        tabs.remove(at: i)
    }
    
    /// Начинает новую сессию.
    public func beginSession() {
    }
    
    /// Выполняет действия по завершению сессии
    /// пользователя.
    public func finishSession() {
    }
}
