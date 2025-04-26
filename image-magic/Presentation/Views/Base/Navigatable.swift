//
//  Navigatable.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import Foundation

protocol Navigatable {
    
    associatedtype Navigation: Hashable
    
    var path: [Navigation] { get set }
    
}

extension Navigatable {
    
    mutating func push(_ item: Navigation) {
        path.append(item)
    }
    
    mutating func pop() {
        path.removeLast()
    }
    
    mutating func popToRoot() {
        path.removeAll()
    }
}
