//
//  DHSupplementaryElementsModel.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public typealias DHSupplementaryElement = UICollectionReusableView & DHSupplementaryElementInput

protocol DHSupplementaryElementModelContract {
    var data: DHSupplementaryElementModelData? { get }
    var viewType: DHSupplementaryElement.Type { get }
    var kind: DHSupplementaryElementKind  { get }
    init(
        data: DHSupplementaryElementModelData?,
        viewType: DHSupplementaryElement.Type
    )
    func reusableId() -> String
}

extension DHSupplementaryElementModelContract {
    func reusableId() -> String {
        return String(describing: viewType)
    }
}

public struct DHSupplementaryElementsModel {
    let header: DHHeaderModel?
    let footer: DHFooterModel?
}

public struct DHHeaderModel: DHSupplementaryElementModelContract {
    
    var data: DHSupplementaryElementModelData?
    var viewType: DHSupplementaryElement.Type
    var kind: DHSupplementaryElementKind
    
    init(
        data: DHSupplementaryElementModelData?,
        viewType: DHSupplementaryElement.Type
    ) {
        self.data = data
        self.viewType = viewType
        self.kind = .header
    }
    
}

public struct DHFooterModel: DHSupplementaryElementModelContract {
    
    var data: DHSupplementaryElementModelData?
    var viewType: DHSupplementaryElement.Type
    var kind: DHSupplementaryElementKind
    
    init(
        data: DHSupplementaryElementModelData?,
        viewType: DHSupplementaryElement.Type
    ) {
        self.data = data
        self.viewType = viewType
        self.kind = .footer
    }
    
}

public enum DHSupplementaryElementKind: String {
    case header
    case footer
}

//MARK: Data
public protocol DHSupplementaryElementModelData {}
