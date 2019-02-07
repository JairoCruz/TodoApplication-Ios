//
//  TodoTableTableViewController.swift
//  TodoApplication
//
//  Created by jairo cruz on 1/31/19.
//  Copyright © 2019 jairo cruz. All rights reserved.
//

import UIKit

class TodoTableTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "pajaro"

        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completion) in
            // TODO: Delete todo
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "delete")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let action = UIContextualAction(style: .destructive, title: "Check"){
            (action, view, completion) in
            // TODO: Delete todo
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "done")
        action.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
 

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
