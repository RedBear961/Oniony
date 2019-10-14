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
import Swinject

// swiftlint:disable line_length force_cast

final public class WebViewAssembly: AutoAssembly {

    /// Контроллер модуля.
    internal func webViewController() {
        container?.register(WebViewController.self, factory: { (resolver, coordinator: WebViewCoordinator) -> WebViewController in
            let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! WebViewController
            controller.tabsManager = resolver.resolve(TabsManager.self)!
            return controller
        })
    }
}

// swiftlint:enable line_length force_cast
