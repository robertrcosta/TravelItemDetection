//
//  Presenter.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import UIKit
import CoreML
import Vision

class DetectionScreenPresenter {
    
    public var items = [
        Item(
            name: "Bagpack",
            phrase: "How do you pretend to carry your things?",
            checked: false
        ),
        Item(
            name: "Camera",
            phrase: "How do you pretend to craete visualizable memories of your beautiful experiences?",
            checked: false
        ),
        Item(
            name: "Charger",
            phrase: "How do you pretend to be adicted to your social feeds while you should enjoy your vacations?",
            checked: false
        ),
        Item(
            name: "Face mask",
            phrase: "How do you pretend to proctect against the COVID-19?",
            checked: false
        ),
        Item(
            name: "Flip flops",
            phrase: "Do you really want to walk barefooted on your vacations?",
            checked: false
        ),
        Item(
            name: "Pastport",
            phrase: "What are you going to show on the Airport's police control?",
            checked: false
        ),
        Item(
            name: "Shirt",
            phrase: "How do you pretend to carry your things?",
            checked: false
        ),
        Item(
            name: "Socks",
            phrase: "How do you pretend to protect your foot?",
            checked: false
        ),
        Item(
            name: "Suncream",
            phrase: "You're gonna burn your skin",
            checked: false
        ),
        Item(
            name: "Sunglasses",
            phrase: "You'll be blind without those",
            checked: false
        )
    ]

    weak var output: DetectionScreenViewController?
    let model = try? TravelItemDetectionModel(configuration: MLModelConfiguration())
    var labelsArr = [String]()

    func processImage(info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let screenWidth = UIScreen.main.bounds.width
        let adjustedHeight = screenWidth/image.size.width * image.size.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: screenWidth, height: adjustedHeight), true, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: screenWidth, height: adjustedHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
        var pixelBuffer : CVPixelBuffer?
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        guard let mlModel = try? model?.model,
              let detector = try? VNCoreMLModel(for: mlModel) else {
            print("Failed to load detector!")
            return
        }

        let request = VNCoreMLRequest(model: detector) { [weak self] request, error in
            guard let `self` = self else { return }
            guard let results = request.results else {
                return
            }
            
            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
                }
                
                let screenWidth = UIScreen.main.bounds.width
                
                let topLabelObservation = objectObservation.labels[0]
                let objectBounds = VNImageRectForNormalizedRect(
                    objectObservation.boundingBox,
                    Int(screenWidth),
                    Int(newImage.size.width/screenWidth * newImage.size.height))
                
                
                let verticalFlip = CGAffineTransform(scaleX: 1, y: -1)
                let translate = CGAffineTransform(translationX: 0, y: -newImage.size.height)
                let newBounds = objectBounds.applying(translate).applying(verticalFlip)
                
                self.output?.drawBox(rect: newBounds, identifier: topLabelObservation.identifier, confidence: topLabelObservation.confidence)
                self.labelsArr.append(topLabelObservation.identifier)
            }
            
            print("labelsArr: \(self.labelsArr)")
            
            guard self.labelsArr.count > 0 else { return }
            
            for (index,item) in self.items.enumerated() {
                for n in 0...self.labelsArr.count-1 {
                    let label = self.labelsArr[n]
                    if item.name == label {
                        self.items[index].checked = true
                    }
                }
            }
            
            print("items: \(self.items)")
            self.output?.enableNextBtn()
        }
        // .scaleFill results in a slight skew but the model was trained accordingly
        // see https://developer.apple.com/documentation/vision/vnimagecropandscaleoption for more information
        request.imageCropAndScaleOption = .scaleFit
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer!, orientation: .up, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("CoreML request failed with error: \(error.localizedDescription)")
        }
    }

}

