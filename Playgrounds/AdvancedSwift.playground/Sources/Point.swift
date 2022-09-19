import Foundation

public struct Point {
    public var x: Int
    public var y: Int
    public lazy var distanceFromOrigin: Double = {
        let x2 = Double(x)
        let y2 = Double(y)

        return (x2 * x2 + y2 * y2).squareRoot()
    }()

    public init(
        x: Int,
        y: Int
    ) {
        self.x = x
        self.y = y
    }
}
