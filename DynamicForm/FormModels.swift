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
    case numeric // => text field
    case bool // => switch
    case none // => label
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

public protocol FormFieldProtocol: class, Stylable, Actionable {
    var id: String { get }
    var displayText: String? { get set }
    var inputType: InputType { get }
    var placeholder: String? { get }
    
    var value: String? { get set }
    var valueDidChange: (() -> Void)? { get set }
}

public protocol Stylable {
    var fontStyle: String? { get }
    var fontSize: Float? { get }
    
    var foregroundColorString: String? { get }
    var backgroundColorString: String? { get }
}

public protocol Actionable {
    var dependsOn: [String]? { get }
    var actionUrl: String? { get }
}
