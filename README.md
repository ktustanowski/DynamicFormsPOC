# Dynamic forms proof of concept
If you need to: 
- handle dynamic forms designed in the API in your application
- support different styling of controls
- enable calculations and other actions available in-place without sending a form
Heare are some ideas you can use.

## General
This repository contains framework which handles showing and processing dynamic form. Thanks to this it's easy to do a  playground-driven-programming. If you open the playground file in the project and configure other half of the screen to live view you will see how form changes in real time when you change fields json or APICalculator.

## Dynamic form cells
This is pretty simple. Just load form fields from response from the API and based on them build concrete cells. 
I used protocols to group related vars like the ones responsibile for styling.
```
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
```
InputType enum tells whether this cell should allow user to make input or not
```
public enum InputType: String, Codable {
    case string
    case longString
    case numeric
    case bool
    case none
    case unsupported
    [...]
}
```
This is absent in PoC but based on this types different cells should be presented to the user. Cell with text field for numeric 
but with text view for long string, or switch for bool input etc.

## Calculations
Calculations can be performed locally or on the API. When done on the API calculation logic can be easily shared between i.e. iOS & Android. When done locally it either needs to be implemented on the app side or algorithms are loaded from the API. This requires to write calculation engine on every platform separately and also potentially exposes calculation algorithms since they needs to be passed along with other form data.
The implementation of calculations in this PoC is based on few assumptions:
```
public protocol Actionable {
    var dependsOn: [String]? { get }
    var actionUrl: String? { get }
}
```
Fields contain field identifiers that they depend on (and need their values for calculations). This data is used to prepare
dependency graph and to configure callback closures so the value change propagate properly and trigger calculations and UI updates. This implementation is just for PoC - in real world scenario Reactive Programming would be much more elegant solution for this.
Another piece of the puzzle is Calculator passed to the DynamicFormViewModel. This is where calculations are done. Based on the implementation this can either rely on the API or local calculations engine.
```
public protocol CalculatorProtocol {
    func calculate(_ fields: [FormFieldProtocol], at url: String?, completion: @escaping (String) -> Void)
}

class DynamicFormViewModel: DynamicFormViewModelProtocol {
    var calculator: CalculatorProtocol?

    [...]
}
```

```
struct ApiCalculator: CalculatorProtocol {
    func calculate(_ fields: [FormFieldProtocol], at url: String?, completion: @escaping (String) -> Void) {
        //let's just pretend here we make API call to get result for given fields
        let calculationsOutcomeReturnedByApi = fields
            .reduce(0, { current, next in
            current - Int(next.value ?? "0")!
        })
        completion(String(describing: calculationsOutcomeReturnedByApi))
    }
}
```

In the PoC I implemetnted only calculations but there can be a much more actions handled in the form i.e. showing or hiding fields based on input.

This is just simple PoC. This code could be refactored but done this way it's also easier to comprehend all the ideas.
