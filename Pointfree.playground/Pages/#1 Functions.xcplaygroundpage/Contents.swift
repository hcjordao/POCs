import Foundation

/*:
 # 1.Functions

 ### Major take aways:
 - Free functions are ok to use depending on the value gained
 - It might add some harder readability points to the code given the current way things are on Swift development
 - Swift has some great access control features. We can make it fileprivate, static functions inside our types, or use modules which define the same functions in different ways
 */

func incr(_ x: Int) -> Int {
    return x + 1
}

incr(1)

func square(_ x: Int) -> Int {
    return x * x
}

// Swift developers are not really used to call free functions not tied to a type
square(incr(2))

extension Int {
    func incr() -> Int {
        return self + 1
    }

    func square() -> Int {
        return self * self
    }
}

// Easier to read
2.incr().square()

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

2 |> incr
(2 |> incr) |> square
2 |> incr |> square // Applied Forward Application

/*:
 #### Custom operators:
 On past languages we like C++. Where we can't create new operators, but we can overload existing operators. Example: using + for sum of vectors

 We need to justify the existance of new operators.
 1. Does this operator exist in Swift
 2. Are we using operators which are already existant and have prior knowledge in other languages
 3. Is the operator solving an universal problem?

 > Tooling has still not catched up to being able to identify custom operators it seems
 */

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return  { a in
        g(f(a))
    }
}

incr >>> square
square >>> incr

(incr >>> square)(2)

2 |> incr >>> square // Using Forward Composition

extension Int {
    func incrAndSquare() -> Int {
        return self.incr().square()
    }
}

2.incrAndSquare() // We would probably never do this and just use 2.incr().square, to avoid boilerplating

/*:
 All inits are free functions at our disposal, they are not binded to a type.
 */

2 |> incr >>> square >>> String.init

[1, 2, 3]
    .map { ($0 + 1) * ($0 + 1) }

[1, 2, 3]
    .map(incr)
    .map(square)

[1, 2, 3]
    .map(incr >>> square)

//: [Previous](@previous)
//: [Next](@next)
