//
//  TodoTableTableViewController.swift
//  TodoApplication
//
//  Created by jairo cruz on 1/31/19.
//  Copyright © 2019 jairo cruz. All rights reserved.
//

import UIKit
import CoreData

class TodoTableTableViewController: UITableViewController {
    
    // MARK: Properties
    var resultsController: NSFetchedResultsController<Todo>!
    let  coreDataStack = CoreDataStack()
    let segment: UISegmentedControl = UISegmentedControl(items: ["All","Done"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Initializar segmented control
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .gray
        segment.tintColor = .white
        segment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        self.navigationItem.titleView = segment
        
        
        // MARK: Request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        request.predicate = NSPredicate(format: "state == %@", NSNumber(booleanLiteral: false))
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        // Init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        // Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error : \(error)")
        }
        
    }
    
    // MARK: Action Segmented Control
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // MARK: Request
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            
            request.predicate = NSPredicate(format: "state == %@", NSNumber(booleanLiteral: false))
            let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
            // Init
            request.sortDescriptors = [sortDescriptors]
            resultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: coreDataStack.managedContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            resultsController.delegate = self
            
            // Fetch
            do {
                try resultsController.performFetch()
            } catch {
                print("Perform fetch error : \(error)")
            }
            self.tableView.reloadData()
            
            
        case 1:
            // MARK: Request
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            
            request.predicate = NSPredicate(format: "state == %@", NSNumber(booleanLiteral: true))
            let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
            // Init
            request.sortDescriptors = [sortDescriptors]
            resultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: coreDataStack.managedContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            resultsController.delegate = self
            
            // Fetch
            do {
                try resultsController.performFetch()
            } catch {
                print("Perform fetch error : \(error)")
            }
            
            self.tableView.reloadData()
            
        default:
            //print("All")
            break
        }
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        // Configure the cell...
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        // cell.detailTextLabel?.text = dateFormatter.string(from: todo.date ?? Date())
        cell.detailTextLabel?.text = String(todo.state)

        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completion) in
            // TODO: Delete todo
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
            
        }
        
        action.image = #imageLiteral(resourceName: "delete")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let action = UIContextualAction(style: .normal, title: "Check"){
            (action, view, completion) in
            let todo = self.resultsController.object(at: indexPath)
            todo.state = true
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
        }
        
        action.image = #imageLiteral(resourceName: "done")
        action.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "ShowAddTodo", sender: tableView.cellForRow(at: indexPath))
    }
 

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
        
    }
    

}

extension TodoTableTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
            tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            print("soy pr")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
    
}
