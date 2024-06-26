//
//  DHInsets.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

public struct DHInsets: Hashable {
    public static let zero: DHInsets = DHInsets()
    
    private var top: CGFloat
    private var left: CGFloat
    private var bottom: CGFloat
    private var right: CGFloat
    
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    func getInsets() -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
