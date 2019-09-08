/**
 Localization.swift

 Oniony SwiftGen

 This file was automatically generated and should not be edited.
 */

import Foundation

/// Перечисление ключей локализации.
/// Позволяет получить доступ к любой строке локализации.
public enum Strings {
}

/// Приватное расширение для получения строк локализации по ключам.
private extension Strings {

    /// Получает строку локализации по ключу.
    static func localize(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format,
                      locale: Locale.current,
                      arguments: args)
    }
}
