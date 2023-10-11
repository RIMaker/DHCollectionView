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
    
    public let sectionId: Int
    public let sectionInsets: DHSectionInsets
    public let scrollDirection: ScrollDirection
    public let spacing: CGFloat
    public let hasScalingEffectOnSelect: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sectionId)
        hasher.combine(sectionInsets)
        hasher.combine(scrollDirection)
        hasher.combine(spacing)
        hasher.combine(hasScalingEffectOnSelect)
    }
    
    public static func == (lhs: DHSectionWrapper, rhs: DHSectionWrapper) -> Bool {
        return (
            lhs.sectionId == rhs.sectionId &&
            lhs.sectionInsets == rhs.sectionInsets &&
            lhs.scrollDirection == rhs.scrollDirection &&
            lhs.spacing == rhs.spacing &&
            lhs.hasScalingEffectOnSelect == rhs.hasScalingEffectOnSelect
        )
    }
    
}

