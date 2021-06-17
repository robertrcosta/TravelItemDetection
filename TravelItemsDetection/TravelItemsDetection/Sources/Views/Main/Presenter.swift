//
//  Presenter.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import UIKit

class Presenter {
    
    func getImage(info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let data = image.jpegData(compressionQuality: 1)
    }
}
