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
    public static let noModel: DHSupplementaryElementsModel = DHSupplementaryElementsModel()
    
    public let header: DHHeaderModel?
    public let footer: DHFooterModel?
    public let backgroundView: DHBackgroundViewModel?
    
    public init(header: DHHeaderModel? = nil, footer: DHFooterModel? = nil, backgroundView: DHBackgroundViewModel? = nil) {
        self.header = header
        self.footer = footer
        self.backgroundView = backgroundView
    }
}

public struct DHHeaderModel: DHSupplementaryElementModelContract {
    
    public var data: DHSupplementaryElementModelData?
    public var viewType: DHSupplementaryElement.Type
    public var kind: DHSupplementaryElementKind
    
    public init(
        data: DHSupplementaryElementModelData?,
        viewType: DHSupplementaryElement.Type
    ) {
        self.data = data
        self.viewType = viewType
        self.kind = .header
    }
    
}

public struct DHFooterModel: DHSupplementaryElementModelContract {
    
    public var data: DHSupplementaryElementModelData?
    public var viewType: DHSupplementaryElement.Type
    public var kind: DHSupplementaryElementKind
    
    public init(
        data: DHSupplementaryElementModelData?,
        viewType: DHSupplementaryElement.Type
    ) {
        self.data = data
        self.viewType = viewType
        self.kind = .footer
    }
    
}

public struct DHBackgroundViewModel {
    public var viewType: UICollectionReusableView.Type
    public var insets: DHInsets
    
    public init(
        viewType: UICollectionReusableView.Type,
        insets: DHInsets
    ) {
        self.viewType = viewType
        self.insets = insets
    }
    
    func reusableId() -> String {
        return String(describing: viewType)
    }
    
}

public enum DHSupplementaryElementKind: String {
    case header
    case footer
}

//MARK: Data
public protocol DHSupplementaryElementModelData {}
