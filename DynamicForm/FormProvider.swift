//
//  FormProvider.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public struct FormProvider<FormFieldType: Codable> {
    public var formJsonString: String?
    private var formJsonData: Data? { return formJsonString?.data(using: .utf8) }
    
    public func loadForm() -> [FormFieldType]? {
        guard let formJsonData = formJsonData else { return nil }
        
        return try? JSONDecoder().decode([FormFieldType].self, from: formJsonData)
    }
    
    public init() {}
}
