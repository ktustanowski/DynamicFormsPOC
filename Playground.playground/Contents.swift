//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import DynamicForm

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
        "displayText": "Input int]",
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

let dynamicForm = DynamicFormViewController.make()
dynamicForm.viewModel.add(fields: fields)
dynamicForm.tableView.reloadData()
PlaygroundPage.current.liveView = dynamicForm

