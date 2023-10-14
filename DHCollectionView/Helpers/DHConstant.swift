//
//  DHConstant.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 14.10.2023.
//

import UIKit

internal struct DHConstant {

    internal struct UI {

        static let backgroundColor: UIColor = UIColor.white
        static let placeholderImageViewHeight: CGFloat = 100
        static let placeholderImageViewWidth: CGFloat = 100
        static let refreshControlTintColor: UIColor = .gray
        static let placeholderViewBackgroundColor: UIColor = .white
        static let placeholderTitleLabelTextColor: UIColor = .black
        static let placeholderTitleLabelTextAlignment: NSTextAlignment = .center
        static let placeholderTitleLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let placeholderMessageLabelTextColor: UIColor = .black
        static let placeholderMessageLabelTextAlignment: NSTextAlignment = .center
        static let placeholderMessageLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let cellEstimatedSize: CGFloat = 40
        static let supplementaryItemsEstimatedSize: CGFloat = 40

    }

    internal struct Animation {

        static let downScale = 0.95

    }

}
