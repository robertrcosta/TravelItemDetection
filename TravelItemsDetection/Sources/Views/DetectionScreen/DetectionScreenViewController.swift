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
    
    init(mediaInfo: [UIImagePickerController.InfoKey : Any]) {
        super.init(nibName: nil, bundle: nil)
        
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
        view.backgroundColor = UIColor.gray
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        guard let image = mediaInfo[.originalImage] as? UIImage else { return }
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubviewWithPinnedConstraints(view: imageView, top: 0, leading: 0, bottom: 0, trailing: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY + 200)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
}

