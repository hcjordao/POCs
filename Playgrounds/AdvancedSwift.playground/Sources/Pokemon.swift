import Foundation

@objcMembers
public final class Pokemon: NSObject {
    public let name: String
    public let type: String
    public let age: Int

    public init(
        name: String,
        type: String,
        yearOfBirth: Int
    ) {
        self.name = name
        self.type = type
        self.age = yearOfBirth
        super.init()
    }
}
