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
import EasySwift

/// Модель веб-вкладки.
public struct Tab {
    
    /// Экземпляр веб отображения
    ///
    /// Хранит отображение для повышения производительности.
    /// Экземпляр этого отображения уже отрисовал свой
    /// контент, что необходимо вво избежании перезагрузок
    /// при каждом новом появлении вкладки на экране.
    public let webView: WebView
    
    /// Заголовок текущей страницы.
    public var title: String? {
        return webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    /// Создает новую вкладку с адресом `about:blank`.
    public init() {
        let webView = WebView()
        webView.loadHTMLString("", baseURL: URL(string: "about:blank"))
        self.webView = webView
    }
    
    /// Получает заголовок текущей страницы без использования JS.
    @available(*, unavailable)
    public func titleWithoutJS() -> String? {
        return nil
    }
}
