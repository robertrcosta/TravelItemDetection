//
//  Item.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 18/6/21.
//

import Foundation

enum TravelItemLabel: String, CaseIterable {
    case backPack = "Bagpack"
    case camera = "Camera"
    case charger = "Charger"
    case faceMask = "Face mask"
    case flipFlops = "Flip flops"
    case pastport = "Pastport"
    case shirt = "Shirt"
    case socks = "Socks"
    case suncream = "Suncream"
    case sunglasses = "Sunglasses"
}

struct TravelItem {
    var name: String?
    var phrase: String?
    var checked = false
    
    init(identifier: String, enabled: Bool = false) {
        name = identifier
        checked = enabled
        
        switch identifier {
        case "Bagpack":
            phrase = "How do you pretend to carry your things?"
        case "Camera":
            phrase = "How do you pretend to craete visualizable memories of your beautiful experiences?"
        case "Charger":
            phrase = "How do you pretend to be adicted to your social feeds while you should enjoy your vacations?"
        case "Face mask":
            phrase = "How do you pretend to proctect against the COVID-19?"
        case "Flip flops":
            phrase = "Do you really want to walk barefooted on your vacations?"
        case "Pastport":
            phrase = "What are you going to show on the Airport's police control?"
        case "Shirt":
            phrase = "It's your identity, you shouldn't go outside without one"
        case "Socks":
            phrase = "How do you pretend to protect your foot?"
        case "Suncream":
            phrase = "You're gonna burn your skin"
        case "Sunglasses":
            phrase = "You'll be blind without those"
        default:
            break
        }
    }
}
