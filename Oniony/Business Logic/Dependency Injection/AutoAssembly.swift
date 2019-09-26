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
import EasySwift

/// Общий родитель всех сборщиков проекта.
/// Автоматически вызывает все методы регистрации объектов.
/// - Note: Будут вызваны только методы, отмеченные, как `@objc`,
/// и не принимающие аргументы.
@objcMembers
open class AutoAssembly: NSObject, Assembly {
    
    /// DI-контейнер для регистрации объектов.
    public var container: Container?
    
    /// Выполняет сборку объектов.
    @nonobjc
    public func assemble(container: Container) {
        self.container = container
        invoke()
    }
    
    /// Определяет все методы регистрации и выполняет их вызов.
    private func invoke() {
        guard container.isSome else {
            fatalError("[Swinject] DI-контейнер не предоставлен!")
        }
        
        var count = UInt32()
        let list = class_copyMethodList(type(of: self), &count)
        
        guard let methodList = list else {
            return
        }
        
        for i in 0..<Int(count) {
            let pointer = methodList[i]
            let method = ObjCMethod(pointer)
            
            if method.name == #selector(NSObject.init) ||
                method.numberOfArguments != 2 ||
                !method.isVoid {
                continue
            }
            
            perform(method.name)
        }
    }
}
