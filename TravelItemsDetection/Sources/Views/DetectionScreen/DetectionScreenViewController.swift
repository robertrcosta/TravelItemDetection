//
//  DetectionScreenViewController.swift
//  TravelItemsDetection
//
//  Created by Robert Rodriguez on 18/6/21.
//

import UIKit
import Vision

class DetectionScreenViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView.init(style: .medium)
    var presenter: DetectionScreenPresenter = DetectionScreenPresenter()
    var mediaInfo: [UIImagePickerController.InfoKey : Any] = [:]
    
    var imageView: UIImageView!
    
    let nextBtn = UIButton(type: .system)
    
    init(mediaInfo: [UIImagePickerController.InfoKey : Any]) {
        super.init(nibName: nil, bundle: nil)
        
        nextBtn.setTitle("Check list", for: .normal)
        nextBtn.addTarget(self, action: #selector(pushResultVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextBtn)
        
        presenter.output = self
        
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
        view.backgroundColor = UIColor.white
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        guard let image = mediaInfo[.originalImage] as? UIImage else { return }
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (image.size.height/image.size.width) * UIScreen.main.bounds.width).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.processImage(info: mediaInfo)
    }
    
    func drawBox(rect: CGRect, identifier: String, confidence: VNConfidence) {
        let shapeLayer = self.createRoundedRectLayerWithBounds(rect)
        
        let textLayer = self.createTextSubLayerInBounds(
            rect,
            identifier: identifier,
            confidence: confidence)
        
        imageView.layer.insertSublayer(shapeLayer, at: 10)
        imageView.layer.insertSublayer(textLayer, at: 11)
    }
    
    func enableNextBtn() {
        nextBtn.isHidden = false
    }
    
    @objc
    func pushResultVC() {
        navigationController?.show(ResultViewController(items: presenter.items), sender: nil)
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)"))
        let largeFont = UIFont(name: "Helvetica", size: 13.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: formattedString.length))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.foregroundColor = UIColor.black.cgColor
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.borderWidth = 2
        shapeLayer.borderColor = UIColor.cyan.cgColor
        shapeLayer.backgroundColor = UIColor.white.withAlphaComponent(0.4).cgColor
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}

