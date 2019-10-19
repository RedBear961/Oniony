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
    
    /// Радиус закругления ячейки.
    public static let cornerRadius: CGFloat = 10
    
    /// Текущая ориентация ячейки.
    public var orientation: UIInterfaceOrientation = AppDelegate.shared.orientation
    
    /// Имя вкладки.
    @IBOutlet var name: UILabel!
    
    /// Изображение вкладки.
    @IBOutlet var imageView: UIImageView!
    
    /// Ширина ячейки.
    @IBOutlet var width: NSLayoutConstraint!
    
    /// Высота ячейки.
    @IBOutlet var height: NSLayoutConstraint!
    
    /// Настраивает ячейку после загрузки из XIB.
    public override func awakeFromNib() {
        layer.cornerRadius = TabViewCell.cornerRadius
    }
    
    /// Настраивает ячейку с помощью модели.
    public func configure(
        using tab: Tab,
        size: CGSize,
        and newOrientation: UIInterfaceOrientation
    ) {
        name.text = tab.title
        update(with: size)
        var isRedraw = false
        
        // Меняет ограничения и добавляет перерисовку
        // из-за смены ориентации.
        if newOrientation != orientation {
            orientation = newOrientation
            isRedraw = true
        }
        
        tab.snapshot(in: frame, redraw: isRedraw) { (image) in
            self.imageView.image = image
        }
    }
    
    /// Обновляет ограничения.
    private func update(with size: CGSize) {
        width.constant = size.width
        height.constant = size.height
    }
}
