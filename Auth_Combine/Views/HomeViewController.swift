//
//  HomeViewController.swift
//  Auth_Combine
//
//  Created by Edgar Cisneros on 18/05/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    private var users = [User]()
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        Networking.shared.delegate = self
        Networking.shared.loadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
        
    }

}

extension HomeViewController: NetworkingDelegate{
    func updateTable(users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
