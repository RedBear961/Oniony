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
public class Tab: NSObject {
    
    /// Экземпляр веб отображения
    ///
    /// Хранит отображение для повышения производительности.
    /// Экземпляр этого отображения уже отрисовал свой
    /// контент, что необходимо во избежании перезагрузок
    /// при каждом новом появлении вкладки на экране.
    public let webView: WebView
    
    /// Кэш хранения картинки для повышения производительности.
    private var image: UIImage?
    
    /// Заголовок текущей страницы.
    public var title: String {
        if webView.request.isNone {
            return URL.blank.absoluteString
        }
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        return title ?? "Без названия"
    }
    
    /// Создает новую вкладку с адресом `about:blank`.
    public override init() {
        let webView = WebView()
        self.webView = webView
        super.init()
        
        webView.delegate = self
        webView.loadHTMLString("", baseURL: .blank)
        webView.frame = defaultRect()
    }
    
    /// Создает новую вкладку и загружает адрес.
    public init(with url: URL) {
        let webView = WebView()
        self.webView = webView
        super.init()
        
        webView.frame = defaultRect()
        webView.delegate = self
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    /// Создает снэпшот текущей страницы.
    public func snapshot(
        in rect: CGRect,
        redraw: Bool = false,
        completion block: @escaping (UIImage) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var image = UIImage()
            DispatchQueue.main.sync {
                 image = self.screenshot(in: rect, redraw: redraw)
            }
            
            if rect != .zero, let ciImage = image.ciImage() {
                let ratio = image.size.relation(to: rect.size)
                let size = rect.size.scaledBy(ratio.width)
                let origin = CGPoint(x: 0, y: ciImage.extent.height - size.height)
                let frame = CGRect(origin: origin, size: size)
                let cropped = ciImage.cropped(to: frame)
                
                image = cropped.uiImage
            }
            
            DispatchQueue.main.async {
                block(image)
            }
        }
    }
    
    /// Создает скриншот вкладки полного размера.
    ///
    /// Вернет кэшированное изображение, если не указана
    /// принудительная перерисовка. Если кэш пуст, выполнит
    /// перерисовку без  указания флага.
    public func screenshot(in rect: CGRect, redraw: Bool) -> UIImage {
        if redraw || image.isNone {
            let screenRect = UIScreen.main.bounds
            let drawed = webView.draw(in: screenRect, scale: 1) ?? UIImage()
            image = drawed
            return drawed
        }
        
        return image!
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

extension Tab: UIWebViewDelegate {
    
    /// Веб отображение было загружено.
    public func webViewDidFinishLoad(_ webView: WebView) {
        let rect = UIScreen.main.bounds
        _ = screenshot(in: rect, redraw: true)
    }
}
