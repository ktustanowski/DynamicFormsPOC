//
//  UITableViewCell+Management.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

extension UITableViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    static func register(in tableView: UITableView) {
        let cellNib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: self))
        tableView.register(cellNib, forCellReuseIdentifier: reuseIdentifier)
    }
}
