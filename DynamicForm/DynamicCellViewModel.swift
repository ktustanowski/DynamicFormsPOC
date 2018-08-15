//
//  DynamicCellViewModel.swift
//  DynamicForm
//
//  Created by Kamil Tustanowski on 11.08.2018.
//  Copyright © 2018 Cornerbit Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol CalculatorProtocol {
    func calculate(_ fields: [FormFieldProtocol], at url: String?, completion: @escaping (String) -> Void)
}

class DynamicFormViewModel: DynamicFormViewModelProtocol {
    var calculator: CalculatorProtocol?
    
    var fields: [FormFieldProtocol] = [] {
        didSet {
            bindFields()
        }
    }
    
    lazy var dependencies: [String: [FormFieldProtocol]] = {
        return [:]
    }()
    
    var fieldCount: Int {
        return fields.count
    }
    
    func field(at indexPath: IndexPath) -> FormFieldProtocol? {
        guard indexPath.row >= 0 && fields.count > indexPath.row else { return nil }
        
        return fields[indexPath.row]
    }
    
    var refreshAt: ((IndexPath) -> ())?
}

private extension DynamicFormViewModel {
    func bindFields() {
        bindDependentFields()
    }
    
    func bindDependentFields() {
        guard let dependentFields = dependentFields else { return }
        dependentFields.forEach { [weak self] field in
            let fieldDependencies = fields.filter { field.dependsOn?.contains($0.id) == true }
            self?.dependencies[field.id] = fieldDependencies
            fieldDependencies.forEach { $0.valueDidChange = { self?.performCalculations(for: field) } }
        }
    }

    func performCalculations(for field: FormFieldProtocol) {
        guard let calculationDependencies = dependencies[field.id],
            calculationDependencies.filter({ $0.value != nil }).count == dependencies[field.id]?.count
        else {
            return }

        updateDisplayText(for: field, text: "Calculating...") //TODO: spinner would be nicer 
        calculator?.calculate(calculationDependencies, at:
        field.actionUrl) { [weak self] outcome in
            self?.updateDisplayText(for: field, text: outcome)
        }
    }
 
    func updateDisplayText(for field: FormFieldProtocol, text: String?) {
        field.displayText = text
        guard let index = fields.index(where: { $0 === field }) else { return }
        refreshAt?(IndexPath(row: index, section: 0))
    }
    
    var dependentFields: [FormFieldProtocol]? {
        return fields.filter {
            guard let dependsOn = $0.dependsOn, dependsOn.count > 0 else { return false }
            
            return true
        }
    }
}
