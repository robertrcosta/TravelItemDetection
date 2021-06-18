//
//  ViewController.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var presenter = MainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        
        let background = UIImageView()
        background.image = UIImage(named: "background")
        background.contentMode = .scaleAspectFill
        
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviewWithPinnedConstraints(view: background, top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(blurEffectView)
        
        let contentStackView = UIStackView()
        contentStackView.alignment = .fill
        contentStackView.axis = .vertical
        contentStackView.spacing = 60
        contentStackView.layer.cornerRadius = 20
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviewWithPinnedConstraints(view: contentStackView, top: 30, leading: 30, bottom: 30, trailing: 30)
        
        let descStackView = UIStackView()
        descStackView.alignment = .fill
        descStackView.axis = .vertical
        descStackView.spacing = 40
        
        let titleLbl = UILabel()
        titleLbl.text = "Travel Checklist"
        titleLbl.font = UIFont.boldSystemFont(ofSize: 30)
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .center
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        let firstLbl = UILabel()
        firstLbl.text = "Welcome to your\npersonal travel items\nreminder assistant"
        firstLbl.font = UIFont.boldSystemFont(ofSize: 21)
        firstLbl.numberOfLines = 0
        firstLbl.textAlignment = .center
        
        let secondLbl = UILabel()
        secondLbl.text = "Shot us a picture with\nyour items!"
        secondLbl.font = UIFont.systemFont(ofSize: 17)
        secondLbl.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        secondLbl.numberOfLines = 0
        secondLbl.textAlignment = .center
        
        descStackView.addArrangedSubview(titleLbl)
        descStackView.addArrangedSubview(firstLbl)
        descStackView.addArrangedSubview(separator)
        descStackView.addArrangedSubview(secondLbl)
        
        let btnsStackView = UIStackView()
        btnsStackView.alignment = .fill
        btnsStackView.axis = .vertical
        btnsStackView.spacing = 8
        
        let cameraBtn = UIButton(type: .system)
        cameraBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cameraBtn.setTitle("Enable Camera Access", for: .normal)
        cameraBtn.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        let orText = UILabel()
        orText.text = "or"
        orText.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        orText.textAlignment = .center
        
        let galleryBtn = UIButton(type: .system)
        galleryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        galleryBtn.setTitle("Get Picture From Camera Roll", for: .normal)
        galleryBtn.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        
        btnsStackView.addArrangedSubview(cameraBtn)
        btnsStackView.addArrangedSubview(orText)
        btnsStackView.addArrangedSubview(galleryBtn)
        
        contentStackView.addArrangedSubview(descStackView)
        contentStackView.addArrangedSubview(btnsStackView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc
    func openCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true)
    }
    
    @objc
    func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            self.navigationController?.show(DetectionScreenViewController(mediaInfo: info), sender: nil)
        })   
    }
}
