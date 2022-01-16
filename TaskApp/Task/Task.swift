//
//  Task.swift
//  TaskApp
//
//  Created by Игорь Андрианов on 03.01.2022.
//

import Foundation

enum TaskType {
    case mainTask
    case subTask
}

protocol TaskProtocol{
    var type: TaskType { get }
    var name: String { get }
    var description: String { get }
    var subTasks: [TaskProtocol] { get set }
    func addTask(subTask: TaskProtocol)
    func countOfSubTasks() -> Int
}

class Task: TaskProtocol{
    let type: TaskType = .mainTask
    let name: String
    let description: String
    var subTasks: [TaskProtocol] = []

    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    
    init(from task: SubTask, with subTask: SubTask){
        self.name = task.name
        self.description = task.description
        self.addTask(subTask: subTask)
    }
    
    func addTask(subTask: TaskProtocol){
        self.subTasks.append(subTask)
    }
    func countOfSubTasks() -> Int{
        var summ = 1
        subTasks.forEach { subTask in
            summ += subTask.countOfSubTasks()
        }
        return summ
    }
}

class SubTask: TaskProtocol{
    let type: TaskType = .subTask
    let name: String
    let description: String
    var subTasks: [TaskProtocol] = []
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    func addTask(subTask: TaskProtocol){
        return
    }
    
    func countOfSubTasks() -> Int{
        return 1
    }
}
