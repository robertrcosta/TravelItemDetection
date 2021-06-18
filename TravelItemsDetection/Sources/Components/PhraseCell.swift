//
//  PhraseCell.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 18/6/21.
//

import Foundation
import UIKit

class PhraseCell: UICollectionViewCell {
    
    let phraseLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        phraseLbl.font = UIFont.boldSystemFont(ofSize: 25)
        phraseLbl.numberOfLines = 0
        phraseLbl.textAlignment = .center
        
        phraseLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviewWithPinnedConstraints(view: phraseLbl, top: 0, leading: 0, bottom: 0, trailing: 10)
    }
}
