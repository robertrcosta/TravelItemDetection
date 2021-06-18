//
//  DetectionScreenViewController.swift
//  TravelItemsDetection
//
//  Created by Robert Rodriguez on 18/6/21.
//

import UIKit

class DetectionScreenViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView.init(style: .medium)
    var presenter: DetectionScreenPresenter = DetectionScreenPresenter()
    var mediaInfo: [UIImagePickerController.InfoKey : Any] = [:]
    
    init(mediaInfo: [UIImagePickerController.InfoKey : Any]) {
        super.init(nibName: nil, bundle: nil)
        
        self.mediaInfo = mediaInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        guard let image = mediaInfo[.originalImage] as? UIImage else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubviewWithPinnedConstraints(view: imageView, top: 0, leading: 0, bottom: 0, trailing: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.processImage(info: mediaInfo)
    }
    
}

