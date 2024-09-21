import Foundation

// MARK: - Generals
@discardableResult
public func assertEqual<A: Equatable>(_ lhs: A, _ rhs: A) -> String {
    lhs == rhs ? "✅" : "❌"
}

@discardableResult
public func assertEqual<A: Equatable, B: Equatable>(_ lhs: (A, B), _ rhs: (A, B)) -> String {
    lhs == rhs ? "✅" : "❌"
}

public var __: Void {
    print("--")
}

// MARK: - #1 Functions
precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

public func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return  { a in
        g(f(a))
    }
}

public func incr(_ x: Int) -> Int {
    return x + 1
}

public func square(_ x: Int) -> Int {
    return x * x
}
