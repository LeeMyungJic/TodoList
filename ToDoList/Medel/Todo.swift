//
//  Todo.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import Foundation

struct TodoList: Codable {
    var month: Date
    var todoList: [Todo]
}

struct Todo: Codable {
    let todo: String
    let date: Date
}
