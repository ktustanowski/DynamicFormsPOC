//
//  FormFields.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol FormField {
    var id: String { get }
}

public protocol Describable {
    var descriptionText: String? { get }
}

public protocol Stylable {
    var fontName: String? { get }
    var fontStyle: String? { get }
    var fontSize: Int? { get }
    
    var foregroundColor: UIColor? { get }
    var backgroundColor: UIColor? { get }
}

public protocol Text: FormField, Describable {
    var value: String? { get }
}

public protocol InputText: FormField, Describable {
    
}

public protocol InputInt: FormField, Describable {
    
}

public protocol InputDouble: FormField, Describable {
    
}

public protocol CalculatedText: FormField, Describable {
    
}
