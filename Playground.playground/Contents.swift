//: Playground - noun: a place where people can play

import Foundation
import UIKit
import PlaygroundSupport
import DynamicForm

let formJsonString =
"""
[
    {
        "id": "1",
        "displayText": "Lorem ipsum dolor sit amet",
        "inputType": "none",
        "fontSize": 40.0
    },
    {
        "id": "2",
        "displayText": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
        "inputType": "none"
    },
    {
        "id": "3",
        "displayText": "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",
        "inputType": "string",
        "placeholder": "Sed ut perspiciatis unde",
        "foregroundColorString": "#dc143c"
    },
    {
        "id": "4",
        "displayText": "Input #1",
        "inputType": "numeric",
        "foregroundColorString": "#ffffff",
        "backgroundColorString": "#008080"
    },
    {
        "id": "5",
        "displayText": "Input #2",
        "inputType": "numeric",
        "foregroundColorString": "#ffffff",
        "backgroundColorString": "#008080"
    },
    {
        "id": "6",
        "displayText": "Calculations for outcome #1 & #2 is:",
        "inputType": "none",
        "foregroundColorString": "#ffffff",
        "backgroundColorString": "#008080"
    },
    {
        "id": "7",
        "displayText": "insufficient data to calculate",
        "inputType": "none",
        "foregroundColorString": "#ffffff",
        "backgroundColorString": "#008080",
        "dependsOn": ["4", "5"],
        "actionUrl": "http://calculate.url",
        "calculations": "4 + 5"
    }
]
"""

class FormField: FormFieldProtocol, Codable {
    let id: String
    var displayText: String?
    let inputType: InputType
    let placeholder: String?
    
    let fontStyle: String?
    let fontSize: Float?
    let foregroundColorString: String?
    let backgroundColorString: String?
    
    let dependsOn: [String]?
    let actionUrl: String?
    
    var value: String? {
        didSet {
            valueDidChange?()
        }
    }
    var valueDidChange: (() -> Void)?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case displayText
        case inputType
        case placeholder
        case fontStyle
        case fontSize
        case foregroundColorString
        case backgroundColorString
        case dependsOn
        case actionUrl
        case value        
    }
}

struct ApiCalculator: CalculatorProtocol {
    func calculate(_ fields: [FormFieldProtocol], at url: String?, completion: @escaping (String) -> Void) {
        //let's just pretend here we make API call to get result for given fields
        let calculationsOutcomeReturnedByApi = fields.reduce(0, { current, next in current + Int(next.value ?? "0")!})
        completion(String(describing: calculationsOutcomeReturnedByApi))
    }
}

var formProvider = FormProvider<FormField>()
formProvider.formJsonString = formJsonString
let fields = formProvider.loadForm() ?? []
var apiCalculator = ApiCalculator()

let dynamicForm = DynamicFormViewController.make()
dynamicForm.viewModel.calculator = apiCalculator
dynamicForm.viewModel.fields = fields
dynamicForm.tableView.reloadData()
PlaygroundPage.current.liveView = dynamicForm
