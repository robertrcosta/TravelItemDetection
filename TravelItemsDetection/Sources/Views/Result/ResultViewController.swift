//
//  ResultViewController.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 18/6/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    let presenter = ResultPresenter()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        view.backgroundColor = .white
        
        let background = UIImageView()
        background.image = UIImage(named: "background")
        background.contentMode = .scaleAspectFill
        
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviewWithPinnedConstraints(view: background, top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        let contentScrollView = UIView()
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubviewWithPinnedConstraints(view: contentScrollView, top: 0, leading: 0, bottom: 0, trailing: 0)
        contentScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentStackView = UIStackView()
        contentStackView.alignment = .fill
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubviewWithPinnedConstraints(view: contentStackView, top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let stackCollection = UIStackView()
        stackCollection.alignment = .fill
        stackCollection.axis = .vertical
        stackCollection.spacing = 0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = stackCollection.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.addSubview(blurEffectView)
        
        contentStackView.addArrangedSubview(stackCollection)
        
        let contentCollectionView = UIView()
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        stackCollection.addArrangedSubview(contentCollectionView)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.isUserInteractionEnabled = false
        stackCollection.addArrangedSubview(pageControl)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.register(PhraseCell.self, forCellWithReuseIdentifier: "PhraseCell")
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.addSubviewWithPinnedConstraints(view: collectionView, top: 15, leading: 15, bottom: 15, trailing: 15)
        collectionView.reloadData()
    }
    
    func cellForPhrase(at indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhraseCell", for: indexPath) as? PhraseCell {
            let phrase = presenter.items[indexPath.row].phrase
            cell.phraseLbl.text = phrase
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = presenter.items.count
        return presenter.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellForPhrase(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
