//
//  Todo.swift
//  TodoList
//
//  Created by longv on 20/11/2023.
//

import Foundation

struct Todo {
    let title: String
    var isComplete: Bool = false
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
    
    func completeToggled() -> Todo{
        return Todo(title: title, isComplete: !isComplete)
    }
}
