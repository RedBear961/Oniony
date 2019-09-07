/**
 SwinjectConfigurator.swift
 
 Oniony
 
 Copyright (c) 2019 WebView, Lab. All rights reserved.
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
