/**
 AutoAssembly.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
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
