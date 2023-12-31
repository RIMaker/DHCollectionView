//
//  DHSectionData.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import Foundation

public struct DHSectionData {
    public let cellModels: [DHCellModel]
    public let supplementaryElementModels: DHSupplementaryElementsModel
    
    public init(
        cellModels: [DHCellModel],
        supplementaryElementModels: DHSupplementaryElementsModel
    ) {
        self.cellModels = cellModels
        self.supplementaryElementModels = supplementaryElementModels
    }
}
