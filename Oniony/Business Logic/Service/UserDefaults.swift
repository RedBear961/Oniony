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

import Combine
import Foundation
import EasySwift

/// Обертка над свойством, связывающая
/// его с полем в пользовательских настройках.
///
/// Установка такого свойства, вызовет запись
/// нового значение в базу данных.
/// Получение такого свойство, вызовет чтение
/// из базы данных.
///
/// Любое свойство с таким модификатором является
/// рассчитываемым свойством и не хранит свое значение
/// в оперативной памяти.
@propertyWrapper
public struct UserDefaults<Value: Any> {
    
    /// Ключ, используемый для хранения объекта в БД.
    public let key: String
    
    /// Значение по-умолчанию, которое будет выдано, если
    /// в БД нет записи об этом свойстве.
    public let defaultValue: Value
    
    /// Экземпляр БД, с которым работает  структура.
    private let userDefaults: Foundation.UserDefaults
    
    /// Основной конструктор.
    /// - Parameter userDefaults:
    ///     Экземпляр UserDefaults для работы. По-умолчанию `standard`.
    public init(
        key: String,
        default: Value,
        userDefaults: Foundation.UserDefaults = Foundation.UserDefaults.standard
    ) {
        self.key = key
        self.defaultValue = `default`
        self.userDefaults = userDefaults
    }
    
    /// Управляемое структурой значение.
    public var wrappedValue: Value {
        get {
            guard let value = userDefaults.value(forKey: key) as? Value else {
                userDefaults.setValue(defaultValue, forKey: key)
                return defaultValue
            }
            
            return value
        }
        
        set(value) {
            userDefaults.setValue(value, forKey: key)
        }
    }
}
