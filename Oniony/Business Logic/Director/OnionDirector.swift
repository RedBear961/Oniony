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
import CoreGraphics

/// Протокол директора сети.
public protocol NetworkDirector {
    
    /// Делегат запуска сети.
    var startupDelegate: NetworkDirectorStartupDelegate? { get set }
    
    /// Подписывает класс на события запуска.
    func subscribe(toStartup delegate: NetworkDirectorStartupDelegate?)
    
    /// Запускает сеть.
    func start()
}

/// Делегат запуска сети.
/// Ему будут рассылаться уведомления о статусе запуска.
public protocol NetworkDirectorStartupDelegate: class {
    
    /// Директор начал запуск сети.
    func networkDidStartLaunching(_ director: NetworkDirector)
    
    /// Директор перешел на следующих шшаг запуска сети.
    func network(_ director: NetworkDirector, didUpdate progress: CGFloat, status: String)
    
    /// Директор запустил сеть.
    func networkDidFinishLaunching(_ director: NetworkDirector)
}

/// Директор тор-сети.
/// Запускает и управляет тор-сетью.
final public class OnionDirector: NetworkDirector {
    
    /// Делегат запуска сети.
    unowned public var startupDelegate: NetworkDirectorStartupDelegate?
    
    public func subscribe(toStartup delegate: NetworkDirectorStartupDelegate?) {
        self.startupDelegate = delegate
    }
    
    /// Запускает сеть.
    public func start() {
    }
}

#if DEBUG
/// Мок директор тор-сети.
/// Не запускает сеть, но имитирует процессы загрузки/перезагрузки.
final public class MockOnionDirector: NetworkDirector {
    
    /// Делегат запуска сети.
    unowned public var startupDelegate: NetworkDirectorStartupDelegate?
    
    /// Таймер для имитации запуска.
    private var timer: Timer?
    
    /// Текущее время.
    private var time: TimeInterval = 0
    
    /// Подписывает класс на события запуска.
    public func subscribe(toStartup delegate: NetworkDirectorStartupDelegate?) {
        self.startupDelegate = delegate
    }
    
    /// Запускает сеть.
    public func start() {
        DispatchQueue.global().async {
            self.startupDelegate?.networkDidStartLaunching(self)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            DispatchQueue.global().async {
                self.tick()
            }
        })
    }
    
    /// Имитирует процесс загрузки тор-сети.
    @objc
    private func tick() {
        time += 1
        
        let progress: CGFloat = CGFloat(time / 10)
        var status: String
        
        switch time {
        case 1:
            status = "Соединения с ретрянсляторами"
            
        case 2...3:
            status = "Обмен рукопожатием с ретрансляторами"
            
        case 4...5:
            status = "Авторизация в тор-сети"
            
        case 6...7:
            status = "Создание цепочки узлов"
            
        case 8...9:
            status = "Подключение цепочки узлов"
            
        case 10:
            status = "Тор-сеть запущена"
            
        default:
            self.timer?.invalidate()
            startupDelegate?.networkDidFinishLaunching(self)
            return
        }
        
        startupDelegate?.network(self, didUpdate: progress, status: status)
    }
}
#endif
