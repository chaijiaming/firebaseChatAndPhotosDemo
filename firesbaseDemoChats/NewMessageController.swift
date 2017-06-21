//
//  NewMessageController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 5/17/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import Firebase



let userSearch = UISearchController(searchResultsController: nil)

class NewMessageController: UITableViewController {
    
    
    let cellID = "ID"
    
    var users = [UserDatabase]()
    var filteredUsers = [UserDatabase]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.title = "全部用户"
        let userSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        userSearchBar.placeholder = "搜索用户"
        self.tableView.tableHeaderView = userSearchBar
        
        let userSearch = UISearchController(searchResultsController: nil)
        userSearch.searchResultsUpdater = self
        userSearch.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = userSearch.searchBar
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(userSearchBar)
        
        fetchUser()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var contentOffset: CGPoint = self.tableView.contentOffset
        contentOffset.y += (self.tableView.tableHeaderView?.frame)!.height
        self.tableView.contentOffset = contentOffset
    }
    
    func filteredSearchText(searchText: String, scope: String = "ALL"){
        filteredUsers = users.filter({ (UserDatabase) -> Bool in
            return (UserDatabase.Name?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }

    func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observe( .childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let current = UserDatabase()
                current.setValuesForKeys(dic)
                
                self.users.append(current)
                
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userSearch.isActive && userSearch.searchBar.text! == "" {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // a hack
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let user : UserDatabase
        if  userSearch.isActive && userSearch.searchBar.text! == ""{
            user = filteredUsers[indexPath.row]
        }else{
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.Name
        cell.detailTextLabel?.text = user.Email
        
        return cell
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredSearchText(searchText:(userSearch.searchBar.text!))
    }
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error exists!")
    }
}
