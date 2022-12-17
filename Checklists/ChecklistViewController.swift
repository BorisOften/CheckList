//
//  ViewController.swift
//  Checklists
//
//  Created by Boris Ofon on 12/14/22.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistItem",for: indexPath)
        
        configureText(for: cell, with: item)
        configureCheckmark(for:cell, with: item)
        
        return cell
    }
    
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
    }
    
    
    // MARK: - table view cell for row at
    func configureCheckmark(for cell: UITableViewCell, with item : ChecklistItem)  {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - add item delegates
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemTableViewController
            controller.delegate = self
        }
    }
}

