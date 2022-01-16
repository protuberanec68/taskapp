//
//  TaskTableController.swift
//  TaskApp
//
//  Created by Игорь Андрианов on 03.01.2022.
//

import UIKit

let mainTask = Task(name: "Мои задачи", description: "Здесь вы можете добавить свои задачи")

class TaskTableController: UITableViewController {

    var task: TaskProtocol = mainTask
    var indexTaskOpened: Int = 0
    var superVC: TaskTableController?
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = task.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return task.subTasks.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : task.subTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = (indexPath.row == 0) ? task.description : "Подзадачи этой задачи:"
            cell.contentConfiguration = content
            cell.backgroundColor = .systemGray3
            return cell
        default:
            let task = task.subTasks[indexPath.row]
            var cell: UITableViewCell!
            if task.type == .mainTask {
                cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = "\(indexPath.row + 1). \(task.name)"
                content.secondaryText = "Всего подзадач - \(task.countOfSubTasks()-1)"
                cell.contentConfiguration = content
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "subTaskCell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = "\(indexPath.row + 1). \(task.name)"
                cell.contentConfiguration = content
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath.section > 0 {
            indexTaskOpened = indexPath.row
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TaskTableController") as! TaskTableController
            controller.task = task.subTasks[indexPath.row]
            controller.superVC = self
            controller.modalPresentationStyle = .fullScreen
            navigationController?.show(controller, sender: nil)
        }
    }
    
    //MARK: - Add new subtask
    @IBAction func addTap(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить", message: "Укажите имя и описание новой подзадачи", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Имя"
        }
        alert.addTextField() { textField in
            textField.placeholder = "Описание"
        }
        guard let textFields = alert.textFields else { return }
        let addButton = UIAlertAction(title: "Добавить", style: .cancel) {_ in
            defer {
                self.tableView.reloadData()
            }
            let subTask = SubTask(name: textFields[0].text ?? "_", description: textFields[1].text ?? "_")
            if self.task.type == .subTask {
                self.task = Task(from: self.task as! SubTask, with: subTask)
            } else {
                self.task.addTask(subTask: subTask)
            }
            guard let superVC = self.superVC else { return }
            superVC.task.subTasks[superVC.indexTaskOpened] = self.task
//            superVC.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .default)
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}
