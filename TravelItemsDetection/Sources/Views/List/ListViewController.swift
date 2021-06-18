//
//  ListViewController.swift
//  TravelItemsDetection
//
//  Created by Gerard Riera Puig on 17/6/21.
//

import UIKit

class ListViewController: UIViewController {
    
    let tableView = UITableView()
    let presenter = ListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviewWithPinnedConstraints(view: tableView, top: 0, leading: 0, bottom: 0, trailing: 0)
        tableView.reloadData()
    }
    
    
    func cellForItem(at indexPath: IndexPath) -> ItemCell {
        let cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        let item = presenter.items[indexPath.row]
        cell.nameLbl.text = item
        return cell
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
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
