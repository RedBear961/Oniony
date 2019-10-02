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
import SwiftUI
import EasySwift

/// Псевдонимм адреса, для внесения ясности, что
/// используемый адрес зарезервирован браузером.
public typealias ReservedURL = URL

/// Расширение URL, определяющее зарезервированные
/// адреса.
public extension URL {
    
    /// Адрес пустой страницы `about:blank`.
    static var blank: ReservedURL {
        return URL(string: "about:blank")!
    }
}

/// Модель веб-вкладки.
public struct Tab {
    
    /// Экземпляр веб отображения
    ///
    /// Хранит отображение для повышения производительности.
    /// Экземпляр этого отображения уже отрисовал свой
    /// контент, что необходимо во избежании перезагрузок
    /// при каждом новом появлении вкладки на экране.
    public let webView: WebView
    
    /// Кэш хранения картинки для повышения производительности.
    private let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        c.countLimit = 1
        return c
    }()
    
    /// Уникальный идентификатор вкладки для использования кэша.
    private let identifier: NSString = UUID().uuidString as NSString
    
    /// Заголовок текущей страницы.
    public var title: String {
        if webView.request.isNone {
            return URL.blank.absoluteString
        }
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        return title ?? "Без названия"
    }
    
    /// Создает новую вкладку с адресом `about:blank`.
    public init() {
        let webView = WebView()
        webView.loadHTMLString("", baseURL: .blank)
        self.webView = webView
        webView.frame = defaultRect()
    }
    
    /// Создает новую вкладку и загружает адрес.
    public init(with url: URL) {
        let webView = WebView()
        self.webView = webView
        webView.frame = defaultRect()
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    /// Создает снэпшот текущей страницы.
    public func snapshot(in rect: CGRect = .zero, redraw: Bool = false) -> UIImage {
        var image = screenshot(redraw)
        
        if rect != .zero,
            let scaled = image.scaled(toWidth: rect.width),
            let cropped = scaled.cropped(in: rect) {
            image = cropped
        }
        
        return image
    }
    
    /// Создает скриншот вкладки полного размера.
    ///
    /// Вернет кэшированное изображение, если не указана
    /// принудительная перерисовка. Если кэш пуст, выполнит
    /// перерисовку без  указания флага.
    private func screenshot(_ redraw: Bool) -> UIImage {
        let cached = cache.object(forKey: identifier)
        if redraw || cached.isNone {
            let screenRect = UIScreen.main.bounds
            let image = webView.draw(in: screenRect, scale: 1) ?? UIImage()
            cache.setObject(image, forKey: identifier)
            return image
        }
        
        return cached!
    }
    
    /// Получает заголовок текущей страницы без использования JS.
    @available(*, unavailable)
    public func titleWithoutJS() -> String? {
        return nil
    }
    
    /// Вычисляет размер вкладки по-умолчанию.
    private func defaultRect() -> CGRect {
        let screenSize = UIScreen.main.bounds.size
        let resultSize = screenSize.applying(CGAffineTransform(scaleX: 0.4, y: 0.4))
        return CGRect(origin: .zero, size: resultSize.rounded)
    }
}
