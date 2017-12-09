//
//  TasksVC.swift
//  AFSample
//
//  Created by Shadi Matter on 11/1/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit

class TasksVC: UIViewController {
fileprivate let celIdentifre = "taskCell"
    fileprivate let cellHight:CGFloat = 60
    @IBOutlet weak var tableView: UITableView!
    
    var usertasks = [tasks]()
    // do refresh when pull the screen
    lazy var refresher : UIRefreshControl = {
       let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tasks"
        self.tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        
        // call refresher
        tableView.addSubview(refresher)
       // tableView.contentInset = .zero
    tableView.register(TaskCell.self, forCellReuseIdentifier: celIdentifre)
     //   tableView.dataSource = self
        
       // let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewTask))
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddNewTask))
        navigationItem.rightBarButtonItem = addButton
        
        handleRefresh()
    }
    
    @objc private func handleAddNewTask(){
        let alert = UIAlertController(title: "alert", message: "Add New Task Title", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Title"
            $0.borderStyle = .roundedRect
            $0.textAlignment = .center
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .destructive, handler: { (action:UIAlertAction) in
           guard let title = alert.textFields?.first?.text?.trimmed , !title.isEmpty
                    else {return  }
            self.addTaskToDB(tilte: title)
            
        }))
    self.present(alert, animated: true, completion: nil)
    }
    var isloading :Bool = false
    var current_page = 1
    var last_page = 1
    
    private func addTaskToDB(tilte:String){
      // let newTsk = tasks(title: tilte)
        let newTsk = tasks(title: tilte)
            //tasks(title: tilte,completed:)
        API.NewTask(newtask:  newTsk) { (error:Error?, task:tasks?) in
           if let task = task {
            self.usertasks.insert(task, at: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath.init(row:0,section:0)], with: .automatic)
            self.tableView.endUpdates()
                
            }
        }
        
    }
    
    @objc private func handleRefresh()
    {
        
        self.refresher.endRefreshing()
        guard !isloading else {return}
        
        isloading = true
        API.Tasks { (error:Error?, tasks:[tasks]?,last_page:Int) in
            self.isloading = false
            if let tasks = tasks {
                self.usertasks = tasks
                self.tableView.reloadData()
                // at the first time the data returned
                 self.current_page = 1
                self.last_page = last_page
                                                
            }
        }
     }
    
    fileprivate func loadeMore(){
        guard !isloading else{return}
        guard current_page < last_page else {return}
        isloading = true
        
        API.Tasks(page:current_page+1) { (error:Error?, tasks:[tasks]?,last_page:Int) in
            self.isloading = false
            if let tasks = tasks {
                self.usertasks.append(contentsOf: tasks)
                self.tableView.reloadData()
                self.current_page+=1
                self.last_page = last_page
        
    }
        }
}
}



extension TasksVC: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        <#code#>
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usertasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: celIdentifre, for: indexPath) as?  TaskCell else{
            return UITableViewCell()
        }
        
        let task = usertasks[indexPath.row]
//        cell.textLabel?.text = task.task
//       // cell.backgroundColor = task.completed ? .red : .clear
//        if task.completed {
//            cell.backgroundColor = .yellow
//            
//        }else{
//            cell.backgroundColor = .clear
//        }
        cell.configreCell(task: task)
        return cell
    }

}

extension TasksVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHight
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.usertasks.count
        if indexPath.row == count-1 {
            //means we in last row
            loadeMore()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let task = usertasks[indexPath.row]
//
//        let editTask = task.copy() as! tasks
//        editTask.completed = !editTask.completed
//
//        API.editTask(task: editTask) { (error:Error?, edittask:tasks?) in
//            if edittask == edittask{
//
//                if let index = self.usertasks.index(of: editTask){
//                self.usertasks.remove(at: index)
//                self.usertasks.insert(editTask, at: index)
//
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self.tableView.endUpdates()
//                }else{
//                    tableView.reloadData()
//                }
//
//            }
//            else{
//                // show alert to user to try again
//            }
//        }
        
        self.handleCompleted(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
         let task = self.usertasks[indexPath.row]
        
        // Delete
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction,indexPath: IndexPath) in
        
            self.handelDelete(task:task,indexPath: indexPath)
            
        }
        deleteAction.backgroundColor = .red
        // Edit
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action:UITableViewRowAction, indexPath:IndexPath) in
            self.handelEdit(task: task, indexpath: indexPath)
        }
        editAction.backgroundColor = .gray
        // Completed
        
        let completedAction = UITableViewRowAction(style: .default, title: "Completed") { (action:UITableViewRowAction, indexPath:IndexPath) in
       
          self.handleCompleted(indexPath: indexPath)
            
            
            
        }
        completedAction.backgroundColor = .green
        
        return [deleteAction,editAction,completedAction]
    }
    
    // Delete function
    private func handelDelete(task:tasks , indexPath:IndexPath){
        
        API.deleteTask(task: task) { (error:Error?, success:Bool?) in
            if success! {
                
                // remove task form model
                if let index = self.usertasks.index(of: task) {
                    self.usertasks.remove(at: index)
                }
                // remove row
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                
            }
            else{
                self.tableView.reloadData()
            }
        }
    }
    
    // Edit Function
    private func handelEdit(task:tasks,indexpath:IndexPath)
    {
        let alert = UIAlertController(title: "Edit", message: "Enter Title ", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField(configurationHandler:{
            $0.text = task.task
            $0.textAlignment = .center
            $0.placeholder = "Enter Title of task"
        })
        
        alert.addAction(UIAlertAction(title: "Edit", style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text?.trimmed , !title.isEmpty else{return}
            
            let editTask = task.copy() as! tasks
            editTask.task = title
            API.editTask(task:editTask, completion: { (error:Error?, editedtask:tasks?) in
                if let editedtask = editedtask{
                    if let index = self.usertasks.index(of: editTask){
                        
                        self.usertasks.remove(at: index)
                        self.usertasks.insert(editTask, at: index)
                        
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [indexpath], with: .automatic)
                        self.tableView.endUpdates()
                        
                    }else {
                        self.handleRefresh()
                    }

                }
                
            })
        }))
       
    
         self.present(alert, animated: true, completion: nil)
        
    }
    
    private func handleCompleted(indexPath:IndexPath){
        
        let task = self.usertasks[indexPath.row]
        let copttask = task.copy() as! tasks
        
        copttask.completed = !copttask.completed
        
        API.editTask(task: copttask, completion: { (error:Error?, edittask:tasks?) in
            
            if edittask == edittask {
                if let index = self.usertasks.index(of: copttask){
                    self.usertasks.remove(at: index)
                    self.usertasks.insert(copttask, at: index)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                    
                    
                }else{
                    self.tableView.reloadData()
                }
            }
            else{
                print("ERROR")
            }
        })
    }
}

