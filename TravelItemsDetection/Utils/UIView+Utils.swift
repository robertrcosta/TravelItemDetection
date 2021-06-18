//
//  UIView+Utils.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import Foundation
import UIKit

extension UIView {
    public func addSubviewWithPinnedConstraints(view: UIView, top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil) {
        addSubview(view)

        if let top = top {
            let topConstraint = view.topAnchor.constraint(equalTo: topAnchor, constant: top)
            topConstraint.identifier = "topConstraint"

            topConstraint.isActive = true
        }

        if let leading = leading {
            let leadingConstraint = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading)
            leadingConstraint.identifier = "leadingConstraint"

            leadingConstraint.isActive = true
        }

        if let bottom = bottom {
            let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            bottomConstraint.identifier = "bottomConstraint"

            bottomConstraint.isActive = true
        }

        if let trailing = trailing {
            let trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)
            trailingConstraint.identifier = "trailingConstraint"

            trailingConstraint.isActive = true
        }
    }
}
