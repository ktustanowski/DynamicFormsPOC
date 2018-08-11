//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import DynamicForm

struct TextInfo: Text {
    var id: String
    var value: String?
    var descriptionText: String?
}

struct InputTextInfo: InputText {
    var id: String
    var descriptionText: String?
}

let dynamicForm = DynamicFormViewController.make()

let text = TextInfo(id: "t1", value: "Just some random text...", descriptionText: nil)
let inputText = InputTextInfo(id: "it1", descriptionText: "Please input something 🙏")


dynamicForm.viewModel.add(fields: [text, inputText])
dynamicForm.tableView.reloadData()
PlaygroundPage.current.liveView = dynamicForm

