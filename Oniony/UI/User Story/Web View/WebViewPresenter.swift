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

/// Протокол презентера модуля веб представления,
public protocol WebViewPresenting: Presenter {
    
    /// Текущая рабочая вкладка.
    func currentTab() -> Tab
    
    /// Показать выбор вкладок.
    func showTabSelector()
}

/// Презентер модуля веб представления.
final public class WebViewPresenter: WebViewPresenting {
    
    /// Контроллер модуля.
    public var controller: WebViewInput!
    
    /// Координатор модуля.
    public var coordinator: WebViewCoordinator!
    
    /// Менеджер вкладок.
    public var tabsManager: TabsManagement!
    
    // MARK: - WebViewPresenting
    
    /// Текущая модель вкладки.
    public func currentTab() -> Tab {
        return tabsManager.currentTab()
    }
    
    /// Показать выбор вкладок.
    public func showTabSelector() {
        coordinator.close()
    }
}
