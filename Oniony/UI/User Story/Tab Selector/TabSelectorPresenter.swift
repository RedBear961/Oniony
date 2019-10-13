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
import UIKit
import EasySwift

private let kItemsInSection = 2

/// Протокол презентера модуля переключения вкладок.
public protocol TabSelectorPresenting: CollectionPresenter {
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab
    
    /// Был нажат элемент по индексу.
    func didSelectItem(at indexPath: IndexPath, in frame: CGRect)
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
}

public extension TabSelectorPresenter {
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int {
        let tabsCount = tabsController.tabs.count
        let sections = tabsController.tabs.count / kItemsInSection
        let isIncrease = tabsCount - sections > 0
        return isIncrease ? sections + 1 : sections
    }
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int {
        let fullSections = section * kItemsInSection
        let remaining = tabsController.tabs.count - fullSections
        return remaining < kItemsInSection ? remaining : kItemsInSection
    }
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab {
        let fullSections = indexPath.section * kItemsInSection
        return tabsController.tabs[fullSections + indexPath.row]
    }
    
    /// Удаляет вкладку по индексу пути.
    func removeItem(at indexPath: IndexPath) -> Int {
        let fullSections = indexPath.section * kItemsInSection
        let index = UInt(fullSections + indexPath.row)
        tabsController.removeTab(at: index)
        return numberOfSections()
    }
    
    /// Был нажат элемент по индексу.
    func didSelectItem(at indexPath: IndexPath, in frame: CGRect) {
        let fullSections = indexPath.section * kItemsInSection
        let index = UInt(fullSections + indexPath.row)
        tabsController.selectTab(at: index)
        
        let context = WebViewTransitionContext(
            frame: frame,
            cornerRadius: 10
        )
        coordinator.toWebView(using: context)
    }
}
