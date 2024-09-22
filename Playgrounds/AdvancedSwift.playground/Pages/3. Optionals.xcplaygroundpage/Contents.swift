import UIKit

/*:
# 3. Optionals
## Sentinel Values
 - Default values which represent an operation that may or may not have a return value
 - Already seen on other languages (such as C -1 return)
 */

/*:
## Replacing Sentinel Values with Enums
 > Retrieval of enum's associated value is through pattern matching (switch, if let, ...)

 Definition of optional below
 ```
 enum Optional<Wrapped> {
      case none
     case some(Wrapped)
  }
 ```
 */

func switchPatternMatch(optionalInt: Int?) {
    switch optionalInt {
    case let .some(int):
        int

    case .none:
        "This is a nil value"
    }
}

switchPatternMatch(optionalInt: 3)
switchPatternMatch(optionalInt: nil)

/*:
## A Tour of Optional Techniques
### if let
 - Possible to use boolean operations reight after an *if let* statement throught the use of a comma
 - Possible to use the unwrapped value of the previous boolean value right after. (Useful for multiple function calls)
 */

let defaultArray = ["one", "two", "three", "four"]
var arrayA = defaultArray

if let index = arrayA.firstIndex(of: "four") {
    // index is alive at this scope only
    arrayA.remove(at: index)
}

arrayA

// Also possible to perform other ifs inside a if let statement

arrayA = defaultArray

if let index = arrayA.firstIndex(of: "four"), index != arrayA.startIndex {
    arrayA.remove(at: index)
}

arrayA

/*:
 ### while let
 - Similar to if let, but unwraps optional on a loop until a condition is met
 - Also possible to add boolean operations after first one
 */

var arrayB = [1, 4, 7, 10]
var arrayC = [Int]()
var iterator = arrayB.makeIterator()

while let i = iterator.next() {
    arrayC.append(i)
}

arrayC == arrayB

/*:
### Doubly Nested Optionals
 - Optional wraps can itself be optionals (such as Optional<Optional<Int>>
 */

let arrayD = ["1", "2", "three"]
let maybeInts = arrayD.map(Int.init) // Optional(1), Optional(2), nil

for maybeInt in maybeInts {
    maybeInt // Optional(1), Optional(2), nil
}

var iteratorC = maybeInts.makeIterator()
while let maybeInt = iteratorC.next() { // iteratorC.next() returns a double optional Int??
    maybeInt // Optional(1), Optional(2), nil
}

// Unwrapping on a for-loop, using i? instead of i
for case let i? in maybeInts {
    i // 1 2
}

// The code above can be written the same as
for case let .some(i) in maybeInts {
    i // 1 2
}

/*:
### if var & while var
 - Using var instead of let, allows you to create a copy inside your scope. Since it is a copied value, the original value will not change.

 > Optionals are value types
 */

/*:
### Scoping of Unwrapped Optionals
 - The pattern matching only guarantees that the unwrapped value is alive is inside its scope. Outside of it no guarantees are made.
 - Guard Statements allow the unwrapped value to be used outside of the scope. Inside the else scope, it is necessary to return a type Never (return, throw, fatalError, another never function)
 - **Never** is what is called an uninhabited type, a type with no valid values and it cannot be constructed.
   - On swift never is constructed as a enum with no values
   - No need to overwrite a own never function unless wrapping fatalError or a preconditionFailure
 - Swift knows tha difference of "absence of a thing" (nil), the "presence of nothing" (Void)
 */

/*:
### Optional Chaining
 - Force acknowledgement that the receiver can be nil
 ```
 delegate?.callback()
 ```
 */

let string: String? = "Test"
let upper: String

// No Optional Chaining
if string != nil {
    upper = string!.uppercased()
} else {
    fatalError("What to do")
}

// Optional Chaining
let upper2 = string?.uppercased() // Optional("TEST")

// Optional chaining is a flattening operation, so we do not need to keep adding ? if the function is already unwrapped and returns the Unwrapped Element as the uppercased function. However if uppercased() returned an optional, we would need to unwrap it.
let lower = string?.uppercased().lowercased() // Optional("test")

// Example 2:
var a: Int? = 5
a? = 10
a // Optional 10

var b: Int? = nil
b? = 10 // Only assigns 10 if the value is not nil
b // nil

/*:
### The nil-Coalescing Operator
 - Most of the time you want to unwrap the optional and replace nil with a default value
 ```
 let a = "1"
 let unwrappedA = Int(a) ?? 0
 ```
 - The code performed with the operator lhs ?? rhs is the same as lhs != nil ? lhs! : rhs (ternary operator)
 - It is possible to chain multiple nil-coalescing
 - The ?? operator is the same as an or expression, it uses short circuiting so it does not need to evaluate the whole expression if the first part is true. This works due to the @autoclosure for its second parameter
 */

// Unlike first and last, fetching an element from a array does not return an optional
extension Array {
    subscript(guarded index: Int) -> Element? {
        guard (startIndex ..< endIndex).contains(index) else {
            return nil
        }

        return self[index]
    }
}

let arrayE = [1, 2, 3, 4]

arrayE[guarded: 2]
arrayE[guarded: 5] ?? 0 // 0

// Chaining nil-coalescing operator
let i: Int? = nil
let j: Int? = nil
let k: Int? = 50
i ?? j ?? k ?? 0 // 50

// Possible ot perform operations with Element??

let stringA: String?? = nil
(stringA ?? "inner") ?? "outer" // inner

let stringB: String?? = .some(nil)
(stringB ?? "inner") ?? "outer" // outer

/*:
### Using Optionals with String Interpolation
 - Compiler emits a warning when print an optional value
   - Message 1: "Expression implicitly coerced from 'Double?' to 'Any'"
   - Message 2: "String interpolation produces a debug description for an optional value; did you mean to make this explicit?"
   - Helpful due how easily optional messages appear to a text displayed to the user
     - We should never use optionals on on user interface messages
 */

// Message Examples
let compilerMessageOne: Double? = 32.0
print(compilerMessageOne)

let compilerMessageTwo: Double? = nil
print("Evaluate: \(compilerMessageTwo)")

// Helper Operator
infix operator ???: NilCoalescingPrecedence

func ???<T>(optional: Optional<T>, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let .some(value):
        return String(describing: value)
    case .none:
        return defaultValue()
    }
}

print(compilerMessageOne ??? "n/a")
print("Evaluate: \(compilerMessageTwo ??? "n/a")")

/*:
### Optional Map
 - Similar to map, transforms something if it is not nil. But does not transform an array, only the optional
 */

let characters: [Character] = ["a", "b", "c"]
let firstChar = characters.first.map { String($0) } // Optional("a")

/*:
### Optional flapMap
 - Map returns an optional instead of an array, so flatMap will flatten the result into a single optional
 - Flat map is similar to if-ket
 */

let stringNumbers = ["1", "2", "3", "foo"]
let x = stringNumbers.first.map { Int($0) } // Optional(Optional(1))
let y = stringNumbers.first.flatMap { Int($0) } // Optional(1)

// Rewritting if-lets with flatMaps
let urlString = "https://someUrl.com"
let view = URL(string: urlString)
    .flatMap { try? Data(contentsOf: $0) }
    .flatMap { UIImage(data: $0) }
    .map { UIImageView(image: $0) }

/*:
Optional chaining is also similar to flatMap
 ```
    i?.advance(by: 1)

    i.flatMap { $0.advance(by: 1) }
 ```
 */

/*:
### Filtering out nils with compactMap
 - Version of map that filters out nils and unwraps values
 */

let numbers = ["1", "2", "3", "foo"]
numbers.compactMap(Int.init).reduce(0, +)

// Definition of compactMap
extension Sequence {
    func compactMap<B>(transform: (Element) -> B?) -> [B] {
        // lazy is used to defer the creation of the array until the last moment
        // It is a micro optimization, but might be nice for larger sequemces
        return lazy.map(transform).filter { $0 != nil }.map { $0! }
    }
}

/*:
### Equating Optionals
 - Most of the time we only care if the value is unwrapped
 - Optional conforms to Equatable only if the the Wrapped value is equatable
     ```
     extension Optional: Equatable where Wrapped: Equatable {
         static func ==(lhs: Wrapped?, rhs: Wrapped?) -> Bool {
             switch (lhs, rhs) {
             case (nil, nil): return true
             case let (x?, y?): return x == y
             case (_?, nil), (nil, _?): return false
             }
         }
     }
     ```
 - Swift automatically promotes a valuen to an optional value to make types match. Look how it would appear if Swift did not provide this type of automatic match
   ```
   if regex.first == Optional("^") { // Or: == .some("^")
       // Operation
   }
   ```
 */

// Dictionaries will remove values set to nil, but if you need to mantain the key you can perform the operation like this
var dictWithNils: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]

dictWithNils // Notice that the nil value still exists

dictWithNils["two"] = nil

dictWithNils // When we set it to nil like this, the "two" key will disappear

// But if we perform the operation as below that will not happen
dictWithNils["two"] = Optional(nil)
dictWithNils["two"] = .some(nil)
dictWithNils["two"]? = nil // Since the two key already exists, we can perform operations with it due to optional chaining
dictWithNils

// If we tried to perform optional chaining with a value that does not exist on the dictionary, it will not execute. Nothing will be updated/inserted
dictWithNils["three"]? = nil
dictWithNils.index(forKey: "three") // nil

/*:
### Comparing Optionals
 - Similar to ==, there used to exist comparing implementations such as <, >, <= and >= for optionals, but they were removed from 3.0 due to the fact that they can yield unexpected results
   - In the example below Double("warm") would return nil and nil is less than 0 which would lead to it being included in the belowFreezing temperatures. Which is unexpected
   ```
   let temps = ["-300.13, "98.6", "0", "warm"]
   let belowFreezing = temps.filter { Double($0) < 0 }
   ```
 - In the need of equality between optionals you now have to unwrap the values and explicitly state how nil values should be treated. An example is shown on the Functions page
 */

/*:
## When to Force-Unwrap
 - Scattered opinions on this topic such as: "never", "whenever it makes the code clearer", "when you can't avoid it".
 > Rule Advanced Swift recommends
 > Use ! when you're so certain that a value won't be nil that you want your program to crash if it ever is
 - An example to take into consideration is our version of the compactMap where on the last map stage we use a force-unwrap, it should be impossible for the value to be nil, so the ! might be justified.
 - Mastering the unwrapping techniques there is better solutions than brute forcing the unwrap, whenever a ! is approaching it is better to take an step back and pounder if there is no other option
 */

let ages = [
    "Tim": 53,
    "Angela": 54,
    "Craig": 44,
    "Jony": 47,
    "Chris": 37,
    "Michael": 34
]

var sortedAges = ages.keys
    // The ! is safe to use here, since all the keys came from the original dictionary.
    .filter { name in ages[name]! < 50 }
    .sorted()

sortedAges

// But we could also rewrite this to be a bit safer
let sortedDict = ages
    .filter { (_, age) in age < 50 }
    .map(\.key)
    .sorted()

sortedDict

/*:
### Improving Force-Unwrap Error Messages
 - When a force unwrap error occurs, it does not provide you with a lot of info
 */

infix operator !!

func !!<T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}

let s = Optional(3)
// let p = s !! "Expecting integer, got \"\(s)\""

/*:
### Asserting in Debug Builds
 - Instead of crashing, we might want to use an assert

 > There are 3 ways to halt an execution
 > 1. fatalError - takes a message and stops unconditionally
 > 2. assert - Checks a condition and a message and stops execution (On release builds assert is removed)
 > 3. precondition - The third is precondition, which is the same as assert but it is not removed on release
 */

infix operator !?

func !?<T: ExpressibleByIntegerLiteral>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

let s2 = "20"
let i2 = Int(s2) !? "Expecting integer, got \"\(s2)\""


func !?<T>(wrapped: T?, nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

let i3 = Int(s2) !? (5, "Expected interger")

/*:
## Implicitly Unwrapped Optionals
 - The reason for implicitly unwrapped optionals to exist is to make interoperability with Objective-C and C easier.
 */

/*:
# Important notes to take
 - Using optionals make code clearer
 - Tons of operations with optionals to write cleaner code
 - Use operators and aux functions to make unwrapping optionals with default values better
 */

