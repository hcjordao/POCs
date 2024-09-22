

import Foundation

/*:
 # 1. Side Effects

 ### Major take aways:
 - It is important to be able to handle side effects inside functions. Not handling them might lead to bugs or tests not being effective
 - Mutations due to reference types might lead to headaches so we can work with value types and inouts to reduce this

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

/*:
 ### Mutations
 */

let formatter = NumberFormatter()

func decimalStyle(_ format: NumberFormatter) {
    format.numberStyle = .decimal
    format.maximumFractionDigits = 2
}

func currencyStyle(_ format: NumberFormatter) {
    format.numberStyle = .currency
    format.roundingMode = .down
}

func wholeStyle(_ format: NumberFormatter) {
    format.maximumFractionDigits = 0
}

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(for: 1234.6)

// We performed a mutation here on our reference type
currencyStyle(formatter)
formatter.string(for: 1234.6)

// Leading to bug here which rounds down the number given the .roundingMode was set to down on currencyStyle
decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(for: 1234.6)

// Refactor this code so we can work with value types which create copy only for "you", and mutations don't apply to it

struct NumberFormatterConfig {
    var numberStyle: NumberFormatter.Style = .none
    var roundingMode: NumberFormatter.RoundingMode = .up
    var maximumFractionDigits: Int = 0

    var formatter: NumberFormatter {
        let result = NumberFormatter()
        result.numberStyle = numberStyle
        result.roundingMode = roundingMode
        result.maximumFractionDigits = maximumFractionDigits
        return result
    }
}

func decimalStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.numberStyle = .decimal
    format.maximumFractionDigits = 2
    return format
}

func currencyStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.numberStyle = .currency
    format.roundingMode = .down
    return format
}

decimalStyle >>> currencyStyle

func wholeStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.maximumFractionDigits = 0
    return format
}

// Now we are creating a copy of the config and not creating it for everyone
wholeStyle(decimalStyle(NumberFormatterConfig()))
    .formatter
    .string(for: "1234.6")

wholeStyle(currencyStyle(NumberFormatterConfig()))
    .formatter
    .string(for: "1234.6")

wholeStyle(decimalStyle(NumberFormatterConfig()))
    .formatter
    .string(for: "1234.6")

// Usage of inout to mutate value types
func inoutDecimalStyle(_ format: inout NumberFormatterConfig) {
    format.numberStyle = .decimal
    format.maximumFractionDigits = 2
}

func inoutCurrencyStyleInout(_ format: inout NumberFormatterConfig) {
    format.numberStyle = .currency
    format.roundingMode = .down
}

func inoutWholeStyleInout(_ format: inout NumberFormatterConfig)  {
    format.maximumFractionDigits = 0
}

var config = NumberFormatterConfig()
inoutDecimalStyle(&config)
inoutWholeStyleInout(&config)
config.formatter.string(for: 1234.6)

inoutCurrencyStyleInout(&config)
config.formatter.string(for: 1234.6)

inoutDecimalStyle(&config)
inoutWholeStyleInout(&config)
config.formatter.string(for: 1234.6)

// Going between the worlds of inout and values through composition
func toInout<A>(_ f: @escaping (A) -> A) -> (inout A) -> Void {
    return { a in
        a = f(a)
    }
}

func fromInout<A>(_ f: @escaping (inout A) -> Void) -> (A) -> A {
    return { a in
        var a = a
        f(&a)
        return a
    }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

// Diamond Operator
infix operator <>: SingleTypeComposition

func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return f >>> g
}

func <> <A>(
    f: @escaping (inout A) -> Void,
    g: @escaping (inout A) -> Void
) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

func |> <A>(a: inout A, f: (inout A) -> Void) -> Void {
    f(&a)
}


let formattingConfig = config |> decimalStyle <> wholeStyle
formattingConfig.formatter.string(for: 1234.6)

var testConfig = NumberFormatterConfig()
testConfig |> inoutDecimalStyle <> inoutCurrencyStyleInout

testConfig.formatter.string(for: 1234.6)

/*:
Little Test.
 PS: We are still working with the reference type
 */

let testFormatter = NumberFormatter()

extension NumberFormatter {
    func decimalStyle() -> NumberFormatter {
        numberStyle = .decimal
        maximumFractionDigits = 2
        return self
    }

    func currencyStyle() -> NumberFormatter {
        numberStyle = .currency
        roundingMode = .down
        return self
    }

    func wholeStyle() -> NumberFormatter {
        maximumFractionDigits = 0
        return self
    }
}

let testNumberFormatter = NumberFormatter()

testFormatter
    .decimalStyle()
    .wholeStyle()
    .string(for: 1234.6)

// We performed a mutation here on our reference type
testFormatter
    .currencyStyle()
    .string(for: 1234.6)

// Leading to bug here which rounds down the number given the .roundingMode was set to down on currencyStyle
testFormatter
    .decimalStyle()
    .wholeStyle()
    .string(for: 1234.6)

//: [Next](@next)
//: [Previous](@previous)
