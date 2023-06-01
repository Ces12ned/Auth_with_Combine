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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.fill"), style: .done, target: self, action: #selector(returnToAuth))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 187/255, green: 145/255, blue: 248/255, alpha: 1)
        title = "Names"
        
        Networking.shared.delegate = self
        Networking.shared.loadData()
        
    }
    
    @objc func returnToAuth(){

        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name
        
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        
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
