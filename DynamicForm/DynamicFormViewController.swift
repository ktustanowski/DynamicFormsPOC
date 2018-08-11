//
//  DynamicFormViewController.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

struct TextInfo: Text {
    var id: String
    var value: String?
    var descriptionText: String?
}

struct InputTextInfo: InputText {
    var id: String
    var descriptionText: String?
}

public protocol DynamicFormViewModelProtocol {
    var fieldCount: Int { get }
    func field(at indexPath: IndexPath) -> FormField
    func add(fields: [FormField])
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
//        injectFakeData()//TODO: REMOVE
    }
    
    /// TODO: REMOVE
    private func injectFakeData() {
        let text = TextInfo(id: "t1", value: "Just some random text...", descriptionText: nil)
        let inputText = InputTextInfo(id: "it1", descriptionText: "Please input something 🙏")
        
        
        viewModel.add(fields: [text, inputText])
        tableView.reloadData()
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
        if let field = viewModel.field(at: indexPath) as? Text {
            cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier,
                                                 for: indexPath)
            (cell as? LabelTableViewCell)?.label.text = field.value
        } else if let field = viewModel.field(at: indexPath) as? InputText {
            cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.reuseIdentifier,
                                                 for: indexPath)
            (cell as? InputTableViewCell)?.topLabel.text = field.descriptionText
        } else {
            fatalError("No cell found!")
        }

        return cell
    }
}

class DynamicFormViewModel: DynamicFormViewModelProtocol {
    var fields: [FormField] = []
    
    var fieldCount: Int {
        return fields.count
    }
    
    func field(at indexPath: IndexPath) -> FormField {
        return fields[indexPath.row] //TODO: make safe
    }
    
    func add(fields: [FormField]) {
        self.fields += fields
    }
}
