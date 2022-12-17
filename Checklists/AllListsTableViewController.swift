//
//  AllListTableViewController.swift
//  Checklists
//
//  Created by Boris Ofon on 12/17/22.
//

import UIKit

class AllListsTableViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Add placeholder data
          var list = Checklist(name: "Birthdays")
          lists.append(list)
          list = Checklist(name: "Groceries")
          lists.append(list)
          list = Checklist(name: "Cool Apps")
          lists.append(list)
          list = Checklist(name: "To Do")
          lists.append(list)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel!.text = lists[indexPath.row].name
        return cell
    }
    
    // MARK: - table view delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as!
            ChecklistViewController
            controller.checklist = sender as? Checklist
        }
    }
}
