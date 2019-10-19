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

/// Количество элементов в секции.
private let kItemsInSection = 2

/// Протокол презентера модуля переключения вкладок.
public protocol TabSelectorPresenting: CollectionPresenter {
    
    /// Порядковый номер последней секции.
    var lastSection: Int { get }
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab
    
    /// Был нажат элемент по индексу.
    func didSelectItem(at indexPath: IndexPath, in frame: CGRect)
    
    /// Заполнена ли последняя секции.
    func isFulled(_ section: Int) -> Bool
}

/// Презентер модуля переключения вкладок.
final public class TabSelectorPresenter: TabSelectorPresenting {

    /// Координатор модуля.
    public var coordinator: TabSelectorCoordinator!
    
    /// Контроллер вкладок.
    public var tabsManager: TabsManagement!
    
    /// Контроллер модуля.
    public var tabSelector: TabSelector!
    
    /// Первый ли раз показывается контроллер.
    private var isFirstShow = true
    
    /// Модуль был загружен.
    public func viewDidLoad() {
        if isFirstShow {
            coordinator.toWebView()
            isFirstShow = false
        }
    }
}

public extension TabSelectorPresenter {
    
    /// Порядковый номер последней секции.
    var lastSection: Int {
        return numberOfSections() - 1
    }
    
    /// Количество секций коллекции.
    func numberOfSections() -> Int {
        let count = tabsManager.count
        let sections = count / kItemsInSection
        let isOdd = count - sections > 0
        return isOdd ? sections + 1 : sections
    }
    
    /// Количество элементов в секции.
    func numberOfItems(in section: Int) -> Int {
        let full = section * kItemsInSection
        let remaining = tabsManager.count - full
        return min(remaining, kItemsInSection)
    }
    
    /// Модель ячейки для индекса пути.
    func item(at indexPath: IndexPath) -> Tab {
        let index: UInt = indexPath.absolute(with: kItemsInSection)
        return tabsManager.tab(at: index)!
    }
    
    /// Удаляет вкладку по индексу пути.
    func removeItem(at indexPath: IndexPath) -> Int {
        let index: UInt = indexPath.absolute(with: kItemsInSection)
        tabsManager.removeTab(at: index)
        return numberOfSections()
    }
    
    /// Был нажат элемент по индексу.
    func didSelectItem(at indexPath: IndexPath, in frame: CGRect) {
        let index: UInt = indexPath.absolute(with: kItemsInSection)
        tabsManager.selectTab(at: index)
        
        let context = WebViewTransitionContext(
            frame: frame,
            ratio: tabSelector.aspectRatio,
            radius: tabSelector.cornerRadius
        )
        coordinator.toWebView(using: context)
    }
    
    /// Заполнена ли последняя секции.
    func isFulled(_ section: Int) -> Bool {
        return numberOfItems(in: section) > 1
    }
}
