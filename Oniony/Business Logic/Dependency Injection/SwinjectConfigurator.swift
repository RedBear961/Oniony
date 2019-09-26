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

/// Координатор DI в проекте.
/// Настраивает и управляет сборщиками.
final public class SwinjectConfigurator {
    
    /// Статический экземпляр конфигуратора.
    public static let shared = SwinjectConfigurator()
    
    /// Основной контейнер зависимостей.
    public let container = Container()
    
    /// Провайдер сборщиков проекта.
    public let assembler: Assembler
    
    /// Основной конструктор.
    private init() {
        self.assembler = Assembler(container: container)
    }
    
    /// Находит все сборщики в проекте и активирует их.
    public func configure() {
        let assemblies = assemblyList()
        assembler.apply(assemblies: assemblies)
    }
    
    /// Находит все сборщики в проекте и возвращает их в виде массива.
    private func assemblyList() -> [Assembly] {
        let classCount = objc_getClassList(nil, 0)
        
        // Получает список всех классов, наследующих от NSObject, используя Runtime ObjC.
        var classList = [AnyClass](repeating: NSObject.self, count: Int(classCount))
        classList.withUnsafeMutableBufferPointer { (buffer) in
            let pointer = AutoreleasingUnsafeMutablePointer<AnyClass>(buffer.baseAddress)
            objc_getClassList(pointer, classCount)
        }
        
        // Быстрое перечисление, чтобы найти классы, реализующие протокол Assembly.
        var list = [Assembly]()
        for aClass in classList {
            guard Bundle(for: aClass) == Bundle.main else {
                continue
            }
            
            if let assembly = aClass as? (NSObject & Assembly).Type {
                let instance = assembly.init()
                if type(of: instance) != AutoAssembly.self {
                    list.append(instance)
                }
            }
        }
        
        return list
    }
}
