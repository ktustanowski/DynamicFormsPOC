//
//  DynamicFormViewController.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol DynamicFormViewModelProtocol {
    var calculator: CalculatorProtocol? { get set }
    var fields: [FormFieldProtocol] { get set }
    var fieldCount: Int { get }
    func field(at indexPath: IndexPath) -> FormFieldProtocol?
}

public class DynamicFormViewController: UITableViewController, StoryboardMakeable {
    public static var storyboardName: String = "Main"
    public typealias StoryboardMakeableType = DynamicFormViewController
    
    public lazy var viewModel: DynamicFormViewModelProtocol! = {
        let viewModel = DynamicFormViewModel()
        viewModel.refreshAt = { [weak self] indexPath in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return viewModel
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func registerCells() {
        LabelTableViewCell.register(in: tableView)
        InputTableViewCell.register(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fieldCount
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let field = viewModel.field(at: indexPath) else { fatalError("No field found at index \(indexPath)") }
        
        switch field.inputType {
        case .numeric, .string:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? InputTableViewCell else { fatalError("No suitable cell found!") }
            cell.topLabel.text = field.displayText
            cell.bottomTextField.placeholder = field.placeholder
            
            switch field.inputType {
            case .numeric:
                cell.bottomTextField.keyboardType = .numberPad
            default:
                cell.bottomTextField.keyboardType = .default
            }
            
            if let fontSize = field.fontSize { cell.bottomTextField.font = cell.bottomTextField.font?.withSize(CGFloat(fontSize)) }
            if let fontSize = field.fontSize { cell.topLabel.font = cell.topLabel.font?.withSize(CGFloat(fontSize)) }
            if let foregroundColorString = field.foregroundColorString { cell.topLabel.textColor = UIColor(rgba: foregroundColorString) }
            if let backgroundColorString = field.backgroundColorString { cell.contentView.backgroundColor = UIColor(rgba: backgroundColorString) }
            
            cell.inputDidChange = { field.value = $0 }
            
            return cell
        case .none, .unsupported:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? LabelTableViewCell else { fatalError("No suitable cell found!") }
            cell.label.text = field.displayText
            if let fontSize = field.fontSize { cell.label.font = cell.label.font?.withSize(CGFloat(fontSize)) }
            if let foregroundColorString = field.foregroundColorString { cell.label.textColor = UIColor(rgba: foregroundColorString) }
            if let backgroundColorString = field.backgroundColorString { cell.contentView.backgroundColor = UIColor(rgba: backgroundColorString) }

            return cell
        default:
            fatalError("No suitable cell found!")
        }
    }
}
