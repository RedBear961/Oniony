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
import PureLayout

/// Протокол отображение, загружаемого из XIB-файла.
/// Это отображение управляет неким XIB-файлом.
public protocol NibLoadable where Self: UIView {
    
    /// Тип отображение, описанного в XIB-файле.
    associatedtype Content: UIView
    
    /// Отображение, загружаемое из XIB-файла.
    var content: Content! { get }
}

public extension NibLoadable {
    
    /// Загружает контент из XIB-файла.
    /// Имя XIB-файла должно соответствовать имени класса.
    func loadContent() -> Content {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        let content = nib.instantiate(withOwner: self)
        
        guard let result = content.first as? Content else {
            fatalError("""
                        [ViewContainer] Отображение, полученное из XIB, не
                        соответствует типу \(type(of: Content.self))
                        """
                        )
        }
        
        return result
    }
}

/// Абстрактный контейнер отображения.
///
/// Наследуйте от него и создайте одноимменный XIB-файл.
/// Контент XIB-файла будет загружен в свойство `content`
/// и расположен на всей доступной площади отображения.
/// Вы также можете добавить любые аутлеты или действия в наследника.
open class ViewContainer<Content: UIView>: UIView {
    
    /// Контент XIB-файла, которым управляет данный контейнер.
    public var content: Content!
    
    /// Вызовет ошибку, если вы не наследник не валиден или
    /// не удалось получить XIB-файл.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        adjustContent()
    }
    
    /// Вызовет ошибку, если вы не наследник не валиден или
    /// не удалось получить XIB-файл.
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustContent()
    }
    
    /// Добавляет контент на отображение.
    private func adjustContent() {
        guard type(of: self) != ViewContainer.self else {
            fatalError("[ViewContainer] Необходимо наследовать от ViewContainer и создать одноименную XIB.")
        }
        
        content = loadContent()
        addSubview(content)
        content.autoPinEdgesToSuperviewEdges()
        self.awakeFromNib()
    }
}

extension ViewContainer: NibLoadable {
}

/// Вспомогательный класс, добавляющий более очевидную верстку.
/// Всегда прозрачен, является просто контейнером, для упрощения верстки.
final public class _IBContainer: UIView {
    
    /// Подготавливает класс к отображению в строителе интерфейса.
    public override func prepareForInterfaceBuilder() {
        backgroundColor = .clear
    }
}
