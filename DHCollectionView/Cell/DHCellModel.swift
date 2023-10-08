//
//  DHCellModel.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public typealias DHCell = UICollectionViewCell & DHCellInput

public struct DHCellModel {
    
    let data: DHCellModelData?
    let cellType: DHCell.Type
    var id: String {
        return String(describing: cellType)
    }
    
    init(
        data: DHCellModelData?,
        cellType: DHCell.Type
    ) {
        self.data = data
        self.cellType = cellType
    }
    
}

//MARK: Data
public protocol DHCellModelData {}
