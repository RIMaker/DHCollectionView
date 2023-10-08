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
        case vertical
        case horizontal(enableDynamicWidth: Bool)
    }
    
    let section: DHSection
    let sectionInsets: DHSectionInsets
    let scrollDirection: ScrollDirection
    let spacing: CGFloat
    let columns: Int
    let hasScalingEffectOnSelect: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(section)
        hasher.combine(sectionInsets)
        hasher.combine(scrollDirection)
        hasher.combine(spacing)
        hasher.combine(columns)
        hasher.combine(hasScalingEffectOnSelect)
    }
    
    public static func == (lhs: DHSectionWrapper, rhs: DHSectionWrapper) -> Bool {
        return (
            lhs.section == rhs.section &&
            lhs.sectionInsets == rhs.sectionInsets &&
            lhs.scrollDirection == rhs.scrollDirection &&
            lhs.spacing == rhs.spacing &&
            lhs.columns == rhs.columns &&
            lhs.hasScalingEffectOnSelect == rhs.hasScalingEffectOnSelect
        )
    }
    
}

