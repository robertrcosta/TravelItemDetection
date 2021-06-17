//
//  ItemCell.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import UIKit

class ItemCell: UITableViewCell {
    
    let nameLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        let contentStackView = UIStackView()
        contentStackView.alignment = .fill
        contentStackView.axis = .horizontal
        contentStackView.spacing = 10
        
        nameLbl.numberOfLines = 1
        
        contentStackView.addArrangedSubview(nameLbl)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviewWithPinnedConstraints(view: contentStackView, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
