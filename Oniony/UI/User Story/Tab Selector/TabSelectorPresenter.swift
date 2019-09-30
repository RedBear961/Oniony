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

/// Протокол презентера модуля переключения вкладок.
public protocol TabSelectorPresenting {
    
    /// Модуль был загружен.
    func viewDidLoad()
    
    /// Отображение будет показано.
    func viewWillAppear()
    
    /// Отображение было показано.
    func viewDidAppear()
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab
}

/// Презентер модуля переключения вкладок.
final public class TabSelectorPresenter: TabSelectorPresenting {

    /// Координатор модуля.
    internal var coordinator: TabSelectorCoordinator!
    
    /// Контроллер вкладок.
    internal var tabsController: TabsManagement!
    
    /// Модуль был загружен.
    public func viewDidLoad() {
    }
    
    /// Отображение будет показано.
    public func viewWillAppear() {
    }
    
    /// Отображение было показано.
    public func viewDidAppear() {
    }
}

public extension TabSelectorPresenter {
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int {
        return 2
    }
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab {
        return tabsController.tabs[indexPath.section + indexPath.row]
    }
}
