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

/// Ячейка коллекции для отображения вкладки.
final public class TabViewCell: UICollectionViewCell {
    
    /// Имя вкладки.
    @IBOutlet var name: UILabel!
    
    /// Обводка вкладки.
    @IBOutlet var borderView: UIView!
    
    /// Изображение вкладки.
    @IBOutlet var imageView: UIImageView!
    
    /// Настраивает ячейку после загрузки из XIB.
    public override func awakeFromNib() {
        layer.cornerRadius = 10
        borderView.layer.borderWidth = 5
        borderView.layer.borderColor = UIColor.gray.cgColor
        borderView.layer.cornerRadius = 10
    }
    
    /// Настраивает ячейку с помощью модели.
    public func configure(using tab: Tab) {
        name.text = tab.title
        let image = tab.snapshot(in: bounds)
        imageView.image = image
    }
}
