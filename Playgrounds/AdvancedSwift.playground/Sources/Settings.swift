import Foundation

public enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

public let defaultSettings: [String: Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone")
]
