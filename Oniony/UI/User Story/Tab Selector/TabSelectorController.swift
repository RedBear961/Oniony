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
    
    /// Обработчик длительного нажатия.
    private var longPressHandler: LongPressGestureHandler<TabViewCell>?
    
    /// Модуль был загружен.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        panHandler = PanGestureHandler(for: collectionView)
        panHandler?.delegate = self
        panHandler?.gesture.delegate = self
        
        longPressHandler = LongPressGestureHandler(for: collectionView)
        longPressHandler?.delegate = self
        longPressHandler?.gesture.delegate = self
        
        let nib = UINib(for: TabViewCell.self)
        collectionView.register(nib, forCellWithReuseIdentifier: TabViewCell.selfIdentifier)
        presenter.viewDidLoad()
    }
    
    /// Отображение будет показано.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        presenter.viewWillAppear()
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
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.cellForItem(at: indexPath)!
        var frame = cell.frame
        frame.y -= collectionView.contentOffset.y
        presenter.didSelectItem(at: indexPath, in: frame)
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

extension TabSelectorController: PanHandlerDelegate, LongPressHandlerDelegate, UIGestureRecognizerDelegate {
    
    /// Запрашивает отображение для работы.
    public func gestureHandler(viewAt point: CGPoint) -> UIView? {
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
        
        let tab = view as! TabViewCell
        let row = collectionView.indexPath(for: tab)!.row
        let newX = x + translation.x
        let diff = newX - x
        
        switch row {
            case 0 where diff < 0,
                 1 where diff > 0:
                view.center.x = newX
                
            default:
                view.center.x = x
        }
    }
    
    /// Жест закончен в точке.
    public func panEnded(in point: CGPoint, for view: UIView) {
        guard let center = panHandler?.defaultCenter else {
            return
        }
        
        let tab = view as! TabViewCell
        let indexPath = collectionView.indexPath(for: tab)!
        let diff = abs(view.center.x - center.x)
        if diff > view.frame.size.width / 2 {
            deleteCell(tab, at: indexPath)
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            view.center = center
        }
    }
    
    /// Разрешает начать жест движение, если активен жест длительное нажатие.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer { return true }
        return longPressHandler?.view != nil
    }
    
    /// Расзрешает продолжить жест движение после жеста длительного нажатия.
    public func gestureRecognizer(
        _ first: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool {
        return first is UILongPressGestureRecognizer &&
               other is UIPanGestureRecognizer
    }
    
    /// Начался жест длительное нажатие.
    public func longPressBegan(in point: CGPoint, for view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform(scaled: 0.9)
        }
    }
    
    /// Закончился жест длительное нажатие.
    public func longPressEnded(in point: CGPoint, for view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform(scaled: 1)
        }
    }
    
    /// Удаляет ячейку из таблицы.
    private func deleteCell(_ cell: TabViewCell, at indexPath: IndexPath) {
        let sign: CGFloat = indexPath.row == 0 ? -1 : 1
        UIView.animate(withDuration: 0.1, animations: {
            cell.frame = cell.frame.offsetBy(dx: sign * 1000, dy: 0)
            cell.alpha = 0
        }) { (_) in
            self.batchUpdates(at: indexPath)
        }
    }
    
    /// Проводит обновление таблицы.
    private func batchUpdates(at indexPath: IndexPath) {
        let before = presenter.numberOfSections()
        collectionView.performBatchUpdates({
            let after = self.presenter.removeItem(at: indexPath)
            
            if before != after {
                self.collectionView.deleteSections(IndexSet(arrayLiteral: after))
            } else {
                self.collectionView.deleteItems(at: [indexPath])
            }
        })
    }
}
