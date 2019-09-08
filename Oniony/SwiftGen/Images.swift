/**
 Image.swift

 Oniony SwiftGen

 This file was automatically generated and should not be edited.
 */

import UIKit.UIImage

/// Перечисление всех имен изображений проекта.
/// Прозволяет получить доступ к любому изображению.
public enum Images {

    public enum app {

        public static var logo: UIImage {
            return image(named: "Logo")
        }
    }
}

/// Приватное расширение для получения изображений по имени.
private extension Images {

    /// Получает изображение по его имени в каталоге.
    static func image(named name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            fatalError("[SwiftGen] Не удалось получилось изображение с именем \(name).")
        }
        return image
    }
}
