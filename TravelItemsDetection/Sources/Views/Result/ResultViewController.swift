//
//  ResultViewController.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 18/6/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    let presenter = ResultPresenter()
    
    // MARK: - View Variables
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let tableView = UITableView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        title = "Don't you miss something?"
        
        view.backgroundColor = .white
        
        let background = UIImageView()
        background.image = UIImage(named: "background")
        background.contentMode = .scaleAspectFill
        
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviewWithPinnedConstraints(view: background, top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
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
        
        stackCollection.addSubview(blurEffectView)
        
        contentStackView.addArrangedSubview(stackCollection)
        
        let contentCollectionView = UIView()
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackCollection.addArrangedSubview(contentCollectionView)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.isUserInteractionEnabled = false
        stackCollection.addArrangedSubview(pageControl)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhraseCell.self, forCellWithReuseIdentifier: "PhraseCell")
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.addSubviewWithPinnedConstraints(view: collectionView, top: 15, leading: 15, bottom: 15, trailing: 15)
        
        collectionView.reloadData()
        
        let travelItemsLbl = UILabel()
        travelItemsLbl.text = "Your travel items: "
        travelItemsLbl.font = UIFont.boldSystemFont(ofSize: 25)
        
        contentStackView.addArrangedSubview(travelItemsLbl)
        
        let contentTableView = UIView()
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let blurEffectTableView = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectViewTableView = UIVisualEffectView(effect: blurEffectTableView)
        blurEffectViewTableView.layer.cornerRadius = 20
        blurEffectViewTableView.clipsToBounds = true
        blurEffectViewTableView.frame = contentTableView.bounds
        blurEffectViewTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectViewTableView.translatesAutoresizingMaskIntoConstraints = false
        
        contentTableView.addSubview(blurEffectViewTableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.addSubviewWithPinnedConstraints(view: tableView, top: 0, leading: 0, bottom: 0, trailing: 0)
        
        contentStackView.addArrangedSubview(contentTableView)
        
        tableView.reloadData()
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
    
    func cellForItem(at indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        let item = presenter.items[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = item.checked ? .checkmark : .none
        cell.nameLbl.text = item.name
        
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.1)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubviewWithPinnedConstraints(view: separator, leading: 0, bottom: 0, trailing: 0)
        
        return cell
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForItem(at: indexPath)
    }
}
