//
//  ViewController.swift
//  TodoList
//
//  Created by longv on 20/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var todos = [
        Todo(title: "Make vanilla pudding."),
        Todo(title: "Put pudding in a mayo jarl"),
        Todo(title: "Eat it in a public place"),
    ]

    @IBOutlet weak var tableView: UITableView!

    @IBAction func checkchanged(_ sender: Checkbox) {
        print("Checkbox \(sender.checked ? "Checked" : "UnCheck")")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
   
    
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> TodoViewController? {
        
        
        let vc = TodoViewController(coder: coder)
        
        if let indexpath = tableView.indexPathForSelectedRow{
            let todo = todos[indexpath.row]
            vc?.todo = todo
        }
        vc?.delegate = self
        vc?.presentationController?.delegate = self
        return vc
    }
    
    
}


// hàm vuốt sang trái complete
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Complete"){action, view, complete in
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
            cell.set(checked: todo.isComplete)
            
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension ViewController:  UITableViewDataSource {
    
    
    func tableView(_ tabView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tabView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tabView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        
        cell.delegate = self
        
        let todo = todos[indexPath.row]
        
        cell.set(title: todo.title, checked: todo.isComplete)
        
        cell.textLabel?.text  = todo.title
        
        return cell
    }
    
    // xoa todo
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // di chuyen item
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
}

extension ViewController: CheckTabViewCellDelegate{
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else{
            return
        }
        let todo = todos[indexPath.row]
        let newtodo = Todo(title: todo.title,isComplete: checked)
        
        todos[indexPath.row] = newtodo
    }
}

extension ViewController: TodoViewControllerDelegate{
    func todoViewController(_ vc: TodoViewController, didSaveTodo todo: Todo){
     
        dismiss(animated: true){
            //update
            if let indexPath = self.tableView.indexPathForSelectedRow{
                self.todos[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
               }else{
                   //create
                   self.todos.append(todo)
                   self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
               }
        }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

