# Dynamic forms proof of concept
If you need to: 
- handle dynamic forms designed in the API in your application
- support different styling of controls
- enable calculations and other actions available in-place without sending a form
Heare are some ideas you can use.

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
