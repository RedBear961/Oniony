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
import PureLayout

/// Протокол контроллера модуля веб представления.
public protocol WebViewInput where Self: UIViewController {
}

/// Контроллер веб представления.
public final class WebViewController: UIViewController, WebViewInput {
    
    /// Презентер модуля,
    public var presenter: WebViewPresenting!
    
    /// Вкладка, которую отображает этот контроллер.
    /// - Note: Это свойство имеет force unwrap, так как при отсутствие
    /// вкладки продолжать работу бессмысленно, этот сценарий
    /// на данный момент не представляется.
    public var tab: Tab!
    
    /// Веб-отображение этого контроллера.
    public var webView: WebView {
        return tab.webView
    }
    
    /// Отступы веб контента по X и Y.
    public var contentOffset: CGPoint {
        get {
            return webView.scrollView.contentOffset
        }
        set(value) {
            webView.scrollView.contentOffset = value
        }
    }
    
    /// Стиль бара статуса.
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Заглушка в стиле визуального эффекта, что верх смотрелся красиво.
    @IBOutlet var topView: UIVisualEffectView!
    
    /// Основной контейнер контента.
    @IBOutlet var container: _IBContainer!
    
    /// Бар управления вебом.
    private var toolbarView: WebToolbarView!
    
    /// Модуль загружен.
    public override func viewDidLoad() {
        navigationController?.isToolbarHidden = true
        prepareWebView()
    }
    
    /// Модуль был загружен.
    public override func viewDidAppear(_ animated: Bool) {
        let frame = CGRect(x: 0, y: view.height, width: view.width, height: 130)
        toolbarView = WebToolbarView(frame: frame)
        toolbarView.delegate = self
        view.addSubview(toolbarView)
        UIView.spring(with: 0.5, damping: 0.7, velocity: 0.2, animations: {
            self.toolbarView.y -= 130
        }, completion: { (_) in
            self.toolbarView.autoSetDimension(.height, toSize: frame.height)
            self.toolbarView.autoPinEdge(toSuperviewEdge: .bottom)
            self.toolbarView.autoPinEdge(toSuperviewEdge: .leading)
            self.toolbarView.autoPinEdge(toSuperviewEdge: .trailing)
        })
    }
    
    /// Модуль будет отображен.
    public override func viewWillAppear(_ animated: Bool) {
        let navVC = navigationController!
        navVC.isNavigationBarHidden = true
    }
    
    /// Выполняет первоначальную настройку веб отображения.
    private func prepareWebView() {
        tab = presenter.currentTab()
        let webView = tab.webView
        container.addSubview(webView)
        webView.autoPinEdgesToSuperviewEdges()
    }
}

extension WebViewController: WebToolbarDelegate {
    
    public func tabsDidTouch(_ toolbar: WebToolbarView) {
        toolbarView.hide(with: 0.3)
        presenter.showTabSelector()
    }
}
