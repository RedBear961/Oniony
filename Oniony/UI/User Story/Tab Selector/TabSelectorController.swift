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
import EasySwift

/// Стандартный отступ между ячейками.
private let kCellIndent: CGFloat = 20

/// Половинный отступ между ячейками (для выравнивания по ввертикали).
private let kHalfCellIndent = kCellIndent / 2

/// Соотношение сторон ячейки для портретной ориентации.
private let kCellPortraitRatio: CGFloat = 1.1

/// Соотношение сторон ячейки для альбомной ориентации.
private let kCellLandscapeRatio: CGFloat = 0.6

/// Модуль переключения вкладок.
final public class TabSelectorController: UICollectionViewController {
    
    /// Презентер модуля.
    internal var presenter: TabSelectorPresenting!
    
    /// Обработчик жеста движения.
    private var panHandler: PanGestureHandler<TabViewCell>?
    
    /// Модуль был загружен.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Обработчик жеста движения для удаления ячеек.
        panHandler = PanGestureHandler(for: collectionView)
        panHandler?.delegate = self
        
        let nib = UINib(for: TabViewCell.self)
        collectionView.register(nib, forCellWithReuseIdentifier: TabViewCell.selfIdentifier)
        presenter.viewDidLoad()
    }
    
    /// Отображение будет показано.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
        collectionView.reloadData()
    }
    
    /// Произошла смена ориентации.
    public override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

public extension TabSelectorController {
    
    /// Количество секций в таблице.
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }
    
    /// Количество ячеек в секции.
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    /// Ячейка для индекса пути.
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let data = presenter.item(at: indexPath)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TabViewCell.selfIdentifier,
            for: indexPath
        ) as! TabViewCell
        cell.configure(using: data)
        return cell
    }
}

extension TabSelectorController: UICollectionViewDelegateFlowLayout {
    
    /// Размер ячейки.
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return itemSize()
    }
    
    /// Отступы для ячейки.
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let endSection = presenter.numberOfSections() - 1
        let numItems = presenter.numberOfItems(in: section)
        var insets = numItems == 1 ? singleInsets() : UIEdgeInsets(kCellIndent)

        // Делает фикс верха и низа для равномерного размещения
        // всех ячеек в коллекции.
        let fix = kHalfCellIndent
        switch section {
        case 0:
            insets.bottom = fix

        case endSection:
            insets.top = fix

        default:
            insets.top = fix
            insets.bottom = fix
        }

        return insets
    }
    
    /// Вычисляет размер ячейки.
    private func itemSize() -> CGSize {
        let screenSize = collectionView.frame.size
        let orientation = UIDevice.current.statusBarOrientation
        let ratio = orientation.isPortrait ? kCellPortraitRatio : kCellLandscapeRatio
        
        // На экране 3 промежутка между отступами и 2 ячейки на нем.
        let width = (screenSize.width - kCellIndent * 3) / 2
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
    
    /// Создает шаблон отступом для секции с одиночном ячейкой.
    /// Эти отступы требуют фикса верха и низа.
    private func singleInsets() -> UIEdgeInsets {
        let screenWidth = collectionView.frame.width
        var insets = UIEdgeInsets(kCellIndent)
        insets.left = kCellIndent
        insets.right = screenWidth - (itemSize().width + kCellIndent)
        return insets
    }
}

extension TabSelectorController: PanHandlerDelegate {
    
    /// Запрашивает отображение для работы.
    public func panHandler(viewIn point: CGPoint) -> UIView? {
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return nil
        }
        return collectionView.cellForItem(at: indexPath)
    }
    
    /// Жест начался в точке.
    public func panDidStart(in point: CGPoint, for view: UIView) {
    }
    
    /// Жест продолжен с изменением от изначальной позиции.
    public func panContinued(with translation: CGPoint, for view: UIView) {
        guard let x = panHandler?.defaultCenter?.x else {
            return
        }
        view.center.x = x + translation.x
    }
    
    /// Жест закончен в точке.
    public func panEnded(in point: CGPoint, for view: UIView) {
        guard let center = panHandler?.defaultCenter else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            view.center = center
        }
    }
}
