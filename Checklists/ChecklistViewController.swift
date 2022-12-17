//
//  ViewController.swift
//  Checklists
//
//  Created by Boris Ofon on 12/14/22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemViewControllerDelegate {
    
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
        loadChecklistItems()
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
        
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        print(editingStyle)
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        saveChecklistItems()
    }
    
    
    // MARK: - table view cell for row at
    func configureCheckmark(for cell: UITableViewCell, with item : ChecklistItem)  {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
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
    func ItemViewController(_ controller: ItemTableViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    func ItemViewController(_ controller: ItemTableViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) {
              configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemTableViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemTableViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    //MARK: - data persistance
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        // 1
        let path = dataFilePath()
        // 2
        if let data = try? Data(contentsOf: path) {
 
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ChecklistItem].self,from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}

