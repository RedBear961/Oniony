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

import SwiftUI

/// Презентер модуля запуска.
final public class SplashScreenPresenter: ObservableObject {
    
    /// Прогресс загрузки.
    @Published public var progress: CGFloat = 0
    
    /// Описание текущего процента загрузки.
    @Published public var description = "Идет загрузка тор-сети..."
    
    /// Директор тор-сети.
    internal var onionDirector: NetworkDirector!
    
    /// Координатор модуля.
    internal var coordinator: SplashScreenCoordinator!
    
    /// Начинает запуск приложения, загрузку тор-сети.
    public func beginLaunch() {
        self.onionDirector.subscribe(toStartup: self)
        self.onionDirector.start()
    }
}

extension SplashScreenPresenter: NetworkDirectorStartupDelegate {
    
    /// Начат запуск тор-сети.
    public func networkDidStartLaunching(_ director: NetworkDirector) {
    }
    
    /// Статус запуска  тор-сети обновился.
    public func network(_ director: NetworkDirector, didUpdate progress: CGFloat, status: String) {
        DispatchQueue.main.async {
            self.progress = progress
            self.description = status
        }
    }
    
    /// Тор-сеть запущена.
    public func networkDidFinishLaunching(_ director: NetworkDirector) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.coordinator.showTabSelector()
        }
    }
}
