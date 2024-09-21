

import Foundation

/*:
 # 1. Side Effects

 ### Major take aways:

 ### Introduction:
 - On the last episode, we understood the use functions and the usage of inputs and outputs and how functions composed
 - There are a lot of things a function can do which can't be captured on the function signature. And this is precisely side effects, and they are the major source of complexity in a code base, because they are diffult to test and they do not compose well.
 - On this episode we want to take a look at a couple of side effects and try to grasp why they are so difficult to understand.
 */

// Function without side effects
func compute(_ x: Int) -> Int {
    return x * x + 1
}

// The nice thing about functions without side effects is that we can run them with the same input a bunch of times and it will always return in the same output. Which means they are easy to test
compute(2)
compute(2)

assertEqual(5, compute(2))
assertEqual(5, compute(2))
assertEqual(6, compute(2))

func computeWithEffect(_ x: Int) -> Int {
    let computation =  x * x + 1
    /*
    1. Print is reaching out in to the world and printing something to the debug console. And looking at the signature there is no way to know that this is happening
     2. Right now we are only printing, but we can switch this up with writing to disk or calling an api
     */
    print("Computed \(computation)")
    return computation
}

computeWithEffect(2)

assertEqual(5, computeWithEffect(2))

[2, 10].map(compute).map(compute)
[2, 10].map(compute >>> compute)
__

// Different results given how the computation and mapping the function
[2, 10].map(computeWithEffect).map(computeWithEffect)
__
[2, 10].map(computeWithEffect >>> computeWithEffect)

func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let computation =  x * x + 1
    return (computation, ["Computed \(computation)"])
}

__
computeAndPrint(2)

assertEqual(
    (5, ["Computed 5"]),
    computeAndPrint(2)
)
assertEqual(
    (6, ["Computed 5"]),
    computeAndPrint(2)
)
assertEqual(
    (5, ["Computed 6"]),
    computeAndPrint(2)
)

let (computation, logs) = computeAndPrint(2)
logs.forEach { print($0) }

// These functions compose with itself
2 |> compute >>> compute
2 |> computeWithEffect >>> computeWithEffect

// While with the modifications made, this new function does not.
// This happens because our output is a tuple and our input is an integer.
// computeAndPrint >>> computeAndPrint

func compose<A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> ((A) -> (C, [String])) {
    return { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

// We got back our composition functionality, but...
2 |> compose(computeAndPrint, computeAndPrint)

// But what if we want to compose more than twice? The parenthesis problem, if we want to add more compositions inside we would need to add them in one of the parameters, which makes it really hard to read and it can go either in the first or second parameter
2 |> compose(compose(computeAndPrint, computeAndPrint), computeAndPrint)
2 |> compose(computeAndPrint, compose(computeAndPrint, computeAndPrint))

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
    lowerThan: ForwardComposition
}

infix operator >=>: EffectfulComposition

func >=> <A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> ((A) -> (C, [String])) {
    return { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

let value = 2

value 
    |> computeAndPrint
    >=> incr
    >>> computeAndPrint
    >=> square
    >>> computeAndPrint

func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
) -> ((A) -> C?) {
    return { a in
        fatalError()
    }
}

func >=> <A, B, C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
) -> ((A) -> [C]) {
    return { a in
        fatalError()
    }
}

// More complicated side effects
func greetWithEffect(_ name: String) -> String {
    let seconds = Int(Date().timeIntervalSince1970) % 60
    return "Hello \(name). It's \(seconds) seconds past the minute"
}

// It generates a value every single time
greetWithEffect("Blob")

assertEqual(
    "Hello Blob. It's 32 seconds past the minute",
    greetWithEffect("Blob")
)

func greet(at date: Date = Date(), name: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name). It's \(seconds) seconds past the minute"
}

greet(name: "Blob")

assertEqual(
    "Hello Blob. It's 39 seconds past the minute",
    greet(at: Date(timeIntervalSince1970: 39), name: "Blob")
)

assertEqual(
    "Hello Blob. It's 38 seconds past the minute",
    greet(at: Date(timeIntervalSince1970: 39), name: "Blob")
)

assertEqual(
    "Hello Blob. It's 39 seconds past the minute",
    greet(at: Date(timeIntervalSince1970: 38), name: "Blob")
)

greetWithEffect

func uppercased(_ string: String) -> String {
    return string.uppercased()
}

"Blob" |> uppercased >>> greetWithEffect
"Blob" |> greetWithEffect >>> uppercased

// This no longer composes
// "Blob" |> uppercased >>> greet
// "Blob" |> greet >>> uppercased

greet

func greet(at date: Date = Date()) -> (String) -> String {
    return { name in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name). It's \(seconds) seconds past the minute"
    }
}

"Blob" |> greet(at: Date()) >>> uppercased
"Blob" |> uppercased >>> greet(at: Date())
greet(at: Date()) // Got back the String -> String signature for compose
greet(at: Date())("Blob")

//: [Next](@next)
//: [Previous](@previous)
