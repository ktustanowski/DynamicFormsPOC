//
//  FormFields.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public enum InputType: String, Codable {
    case string // => text field
    case longString // => text view
    case int // => text field
    case double // => text field
    case bool // => switch
    case none
    case unsupported
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        self = try InputType(rawValue: values.decode(String.self)) ?? .unsupported
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

public protocol FormFieldProtocol {
    var id: String { get }
    var displayText: String? { get }
    var inputType: InputType { get }
    var placeholder: String? { get }
}

public protocol Stylable {
    var fontName: String? { get }
    var fontStyle: String? { get }
    var fontSize: Int? { get }
    
    var foregroundColor: UIColor? { get }
    var backgroundColor: UIColor? { get }
}
