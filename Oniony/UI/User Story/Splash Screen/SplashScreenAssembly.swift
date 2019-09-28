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

import Swinject
import SwiftUI

// swiftlint:disable line_length

/// Сборщик модуля запуска.
@objcMembers
final public class SplashScreenAssembly: AutoAssembly {
    
    /// Отображение модуля.
    internal func splashScreen() {
        container?.register(SplashScreen.self, factory: { (resolver, coordinator: SplashScreenCoordinator) -> SplashScreen in
            let p = resolver.resolve(SplashScreenPresenter.self, argument: coordinator)!
            return SplashScreen(presenter: p)
        })
    }
    
    /// Контроллер модуля.
    internal func splashScreenController() {
        container?.register(SplashScreenController.self, factory: { (resolver, coordinator: SplashScreenCoordinator) -> SplashScreenController in
            let view = resolver.resolve(SplashScreen.self, argument: coordinator)!
            let c = SplashScreenController(rootView: view)
            return c
        })
    }
    
    /// Презентер модуля.
    internal func splashScreenPresenter() {
        container?.register(SplashScreenPresenter.self, factory: { (resolver, coordinator: SplashScreenCoordinator) -> SplashScreenPresenter in
            let p = SplashScreenPresenter()
            p.onionDirector = resolver.resolve(MockOnionDirector.self)!
            p.coordinator = coordinator
            return p
        })
    }
}

internal extension EnvironmentValues {
    
    /// Презентер модуля запуска.
    var splashScreenPresenter: SplashScreenPresenter {
        let container = SwinjectConfigurator.shared.container
        return container.resolve(SplashScreenPresenter.self)!
    }
}

// swiftlint:enable line_length
