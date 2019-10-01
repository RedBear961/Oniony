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

/// Модуль переключения вкладок.
final public class TabSelectorController: UICollectionViewController {
    
    /// Презентер модуля.
    public var presenter: TabSelectorPresenting!
    
    /// Модуль был загружен.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(for: TabViewCell.self)
        collectionView.register(nib, forCellWithReuseIdentifier: TabViewCell.selfIdentifier)
        presenter.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
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
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let itemSize = screenSize.applying(CGAffineTransform(scaleX: 0.4, y: 0.4))
        return itemSize
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let endSection = presenter.numberOfSections() - 1
        switch section {
        case 0:
            return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
            
        case endSection:
            return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
            
        default:
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }
}
