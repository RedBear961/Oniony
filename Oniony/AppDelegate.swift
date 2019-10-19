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

/// Делегат приложения.
@UIApplicationMain
final public class AppDelegate: ESAppDelegate {
    
    /// Глобальный экземпляр делегата.
    public class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /// Основная оконная сцена приложения.
    public private(set) var windowScene: UIWindowScene!
    
    /// Текущая ориентация интерфейса.
    public var orientation: UIInterfaceOrientation {
        return windowScene.interfaceOrientation
    }
    
    /// Контроллер вкладок.
    lazy private var tabsManager: TabsManagement = {
        let container = configurator.container
        return container.resolve(TabsManagerMock.self)!
    }()
    
    /// Конфигурутор системы внедрения зависимостей проекта.
    private let configurator: SwinjectConfigurator = {
        let c = SwinjectConfigurator.shared
        c.configure()
        return c
    }()
    
    /// Обновляет оконную цену приложения.
    public func update(_ scene: UIWindowScene) {
        DispatchQueue.once {
            self.windowScene = scene
        }
    }
    
    // MARK: - Application life-cycle
    
    /// Приложение было запущено.
    public func applicationDidFinishLaunching(_ application: UIApplication) {
        tabsManager.beginSession()
    }
    
    /// Приложение будет завершено.
    public func applicationWillTerminate(_ application: UIApplication) {
        tabsManager.finishSession()
    }
}

/// Текущая ориентация девайса.
public func interfaceOrientation() -> UIInterfaceOrientation {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.windowScene.interfaceOrientation
}
