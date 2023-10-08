//
//  UIView + makeScale.swift
//  DHCollectionView
//
//  Created by Zhora Agadzhanyan on 08.10.2023.
//

import UIKit

extension UIView {
    
    func makeScale(_ sx: CGFloat, _ sy: CGFloat, completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.transform = CGAffineTransformMakeScale(sx, sy)
        } completion: { isCompleted in
            if isCompleted {
                completion?()
            }
        }
    }
}
