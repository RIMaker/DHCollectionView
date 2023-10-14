//
//  DHCollectionView + appearance.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 14.10.2023.
//

import UIKit

extension DHCollectionView {

    public class func setupDefaultAppearance() {
        let appearance = DHCollectionView.appearance()

        appearance.backgroundColor = DHConstant.UI.backgroundColor
        appearance.placeholderImageViewHeight = DHConstant.UI.placeholderImageViewHeight
        appearance.placeholderImageViewWidth = DHConstant.UI.placeholderImageViewWidth
        appearance.refreshControlTintColor = DHConstant.UI.refreshControlTintColor
        appearance.placeholderViewBackgroundColor = DHConstant.UI.placeholderViewBackgroundColor
        appearance.placeholderTitleLabelTextColor = DHConstant.UI.placeholderTitleLabelTextColor
        appearance.placeholderTitleLabelTextAlignment = DHConstant.UI.placeholderTitleLabelTextAlignment
        appearance.placeholderTitleLabelFont = DHConstant.UI.placeholderTitleLabelFont
        appearance.placeholderMessageLabelTextColor = DHConstant.UI.placeholderMessageLabelTextColor
        appearance.placeholderMessageLabelTextAlignment = DHConstant.UI.placeholderMessageLabelTextAlignment
        appearance.placeholderMessageLabelFont = DHConstant.UI.placeholderMessageLabelFont
        appearance.cellEstimatedSize = DHConstant.UI.cellEstimatedSize
        appearance.supplementaryItemsEstimatedSize = DHConstant.UI.supplementaryItemsEstimatedSize
        appearance.cellDownScale = DHConstant.Animation.downScale
    }

}
