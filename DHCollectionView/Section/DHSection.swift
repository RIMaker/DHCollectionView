//
//  DHSection.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public struct DHSection: Hashable {
    let id: Int
}

public struct DHSectionWrapper: Hashable {
    enum ScrollDirection: Hashable {
        enum Align: Hashable {
            case left
            case center(columns: Int)
        }
        case vertical(align: Align)
        case horizontal(enableDynamicWidth: Bool, columns: Int)
    }
    
    let section: DHSection
    let sectionInsets: DHSectionInsets
    let scrollDirection: ScrollDirection
    let spacing: CGFloat
    let hasScalingEffectOnSelect: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(section)
        hasher.combine(sectionInsets)
        hasher.combine(scrollDirection)
        hasher.combine(spacing)
        hasher.combine(hasScalingEffectOnSelect)
    }
    
    public static func == (lhs: DHSectionWrapper, rhs: DHSectionWrapper) -> Bool {
        return (
            lhs.section == rhs.section &&
            lhs.sectionInsets == rhs.sectionInsets &&
            lhs.scrollDirection == rhs.scrollDirection &&
            lhs.spacing == rhs.spacing &&
            lhs.hasScalingEffectOnSelect == rhs.hasScalingEffectOnSelect
        )
    }
    
}

