//
//  DHSection.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public struct DHSectionWrapper: Hashable {
    public enum ScrollDirection: Hashable {
        public enum Align: Hashable {
            case left
            case center(columns: Int)
        }
        case vertical(align: Align)
        case horizontal(enableDynamicWidth: Bool, columns: Int)
    }
    
    public static func == (lhs: DHSectionWrapper, rhs: DHSectionWrapper) -> Bool {
        return lhs.sectionId == rhs.sectionId
    }
    ///sections will be sorted by this property
    public let sectionId: Int
    public let sectionInsets: DHSectionInsets
    public let scrollDirection: ScrollDirection
    ///spacing between items of collection view
    public let spacing: CGFloat
    public let hasScalingEffectOnSelect: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sectionId)
    }
    
    public init(
        sectionId: Int,
        sectionInsets: DHSectionInsets,
        scrollDirection: ScrollDirection,
        spacing: CGFloat,
        hasScalingEffectOnSelect: Bool
    ) {
        self.sectionId = sectionId
        self.sectionInsets = sectionInsets
        self.scrollDirection = scrollDirection
        self.spacing = spacing
        self.hasScalingEffectOnSelect = hasScalingEffectOnSelect
    }
    
}

