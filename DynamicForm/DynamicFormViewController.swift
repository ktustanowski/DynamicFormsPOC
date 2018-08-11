//
//  DynamicFormViewController.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol DynamicFormViewModelProtocol {
    var fieldCount: Int { get }
    func field(at indexPath: IndexPath) -> FormFieldProtocol
    func add(fields: [FormFieldProtocol])
}

public class DynamicFormViewController: UITableViewController, StoryboardMakeable {
    public static var storyboardName: String = "Main"
    public typealias StoryboardMakeableType = DynamicFormViewController
    
    public lazy var viewModel: DynamicFormViewModelProtocol! = {
        return DynamicFormViewModel()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        let formJsonString =
        """
[
    {
        "id": "1",
        "displayText": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        "inputType": "none"
    },
    {
        "id": "2",
        "displayText": "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",
        "inputType": "string",
        "placeholder": "Sed ut perspiciatis unde"
    },
    {
        "id": "3",
        "displayText": "Input int",
        "inputType": "int"
    },
    {
        "id": "4",
        "displayText": "Input double",
        "inputType": "double"
    }

]
"""
        
        struct FormField: FormFieldProtocol, Codable {
            let id: String
            let displayText: String?
            let inputType: InputType
            let placeholder: String?
        }
        
        var formProvider = FormProvider<FormField>()
        formProvider.formJsonString = formJsonString
        let fields = formProvider.loadForm() ?? []
        
        viewModel.add(fields: fields)
    }
    
    private func registerCells() {
        LabelTableViewCell.register(in: tableView)
        InputTableViewCell.register(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fieldCount
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell //TODO: make cell handling more elegant
        let field = viewModel.field(at: indexPath)
        switch field.inputType {
        case .int, .string, .double:
            cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.reuseIdentifier,
                                                 for: indexPath)
            (cell as? InputTableViewCell)?.topLabel.text = field.displayText
            (cell as? InputTableViewCell)?.bottomTextField.placeholder = field.placeholder
            switch field.inputType {
            case .int:
                (cell as? InputTableViewCell)?.bottomTextField.keyboardType = .numberPad
            case .double:
                (cell as? InputTableViewCell)?.bottomTextField.keyboardType = .decimalPad
            default:
                break
            }
        case .none, .unsupported:
            cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier,
                                                 for: indexPath)
            (cell as? LabelTableViewCell)?.label.text = field.displayText
        default:
            fatalError("No suitable cell found!")
        }

        return cell
    }
}

class DynamicFormViewModel: DynamicFormViewModelProtocol {
    var fields: [FormFieldProtocol] = []
    
    var fieldCount: Int {
        return fields.count
    }
    
    func field(at indexPath: IndexPath) -> FormFieldProtocol {
        return fields[indexPath.row] //TODO: make safe
    }
    
    func add(fields: [FormFieldProtocol]) {
        self.fields += fields
    }
}
