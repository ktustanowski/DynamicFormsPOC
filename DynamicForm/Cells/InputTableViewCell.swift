//
//  InputTableViewCell.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

class InputTableViewCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomTextField: UITextField!
    var inputDidChange: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomTextField.delegate = self        
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputDidChange?(textField.text)
    }
}
