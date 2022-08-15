import Foundation

public struct Person {
    public let name: String
    public let surname: String
    public let birth: Int

    public init(
        name: String,
        surname: String,
        birth: Int
    ) {
        self.name = name
        self.surname = surname
        self.birth = birth
    }
}
