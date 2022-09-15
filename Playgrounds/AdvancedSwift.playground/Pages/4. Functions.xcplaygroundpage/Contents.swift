import UIKit
import Foundation

/*:
# 3. Functions
### Overview
 - Functions can be assigned to variables and passed in & out of other functions as arguments, just as a String or Int
   - Functions in Swift and other languages are referred as "first-class objects".
   - *Note* When attributing a function to a variable, we can't include the arguments in (1), arguments are reserved to function declarations
   - **The benefits of being able to write functions like this is to easily write higher-order functions**

 > (1) This might change on later swift versions
 */

func printInt(i: Int) {
    print("You passed \(i)")
}

let funcVar = printInt

printInt(i:2) // You passed 2

// (1) Labels are removed as mentioned
funcVar(2) // You passed 2

// Writing functions that receive functions as arguments
func useFunction(function: (Int) -> ()) {
    function(3)
}

useFunction(function: printInt) // You passed 3
useFunction(function: funcVar) // You passed 3

// Functions can also return other functions
func returnFunc() -> (Int) -> String {
    func innerFunc(i: Int) -> String {
        return "You passed \(i)"
    }

    return innerFunc
}

let encapsulatedMyFunc = returnFunc
encapsulatedMyFunc()(3)

let myFunc = returnFunc()
myFunc(3)

/*:
 - Functions can *capture* variables that exist outside of their local scope
   - We can think of these functions below with their variables as similar to instances of classes with a single method (the function) and some member variables (the captured variables)
   - In programming terminology, a combination of a function and an environment of captured variables is called a closure. So in the example below f and g are examples of closures, because they captyre and use a non-local variable (counter) which was declared outside of them
 */

func counterFunc() -> (Int) -> String {
    var counter = 0 // Outside of the scope of the inner func

    func innerFunc(i: Int) -> String {
        counter += i // counter captured
        return "Running total \(counter)"
    }

    return innerFunc
}

let f = counterFunc()
f(3) // Running total 3
f(4) // Running total 7

let g = counterFunc()
g(2) // Running total 2
g(2) // Running total 4

// The creation of another function does not alter our other f.
f(2) // Running total 9

/*:
- There are two ways of creating functions, with the func keyword or enclosing code with { *code* }, the latter is called closure expressions.
   - Functions decalred as closure expressions can be thought as function literals, the same way as 1 and "hello" are integer and string literals.
   - The closures also are not named as is a function keyed by func. The only way they can be used is by assigning them to a variable or pass them to another function
   - Both notations are below are equivalent, apart from differences using labels.
   - Why is the { } syntax useful? Why not use func everytime?
     - It can be more compact, especially when using it to pass into other functions. (Look into (1))
   - Sometimes swift has a bit of troubling in inferring the type in a closure. Also something might be occoruing and the expected type is not what it is supposed to be
     - When this happen it is better to fully write the from such as (2)
     - Swift also insist you to be explicit some times. For example, we can not simply ignore input parameters. (3)
   - Functions declared with the func keyword can be closures, just like the ones with { } can.
   - Closure is a function combined with any captured variables, while functions created with { } are called closure expressions.
     - Normally people call closure expressions as closures
     - Resuming they are both functions and they both **can** be closures

 > There is a third way a anonymous functions can be used. Call them directly in line as part of the same expression that defines it. This can be useful for defining properties whose initialization requires more than one line. (Example: lazy properties)
 */

// Function notation
func doubler(i: Int) -> Int {
    i * 2
}

[1, 2, 3, 4].map(doubler) // [2, 4, 6, 8]

// Closure notation
let doublerAlt = { (i: Int) -> Int in return i * 2 } // Why did this run 5 times?

[1, 2, 3, 4].map(doublerAlt) // [2, 4, 6, 8]

// (1) Shorter version of doubler
[1, 2, 3, 4].map { $0 * 2 } // [2, 4, 6, 8]

// Short history in closure clearer writing that mean the same
[1, 2, 3, 4].map({ (i: Int) -> Int in return i * 2 }) // (2)
[1, 2, 3, 4].map({ i in return i * 2})
[1, 2, 3, 4].map({ i in i * 2 })
[1, 2, 3, 4].map({ $0 * 2 })
[1, 2, 3, 4].map() { $0 * 2 }
[1, 2, 3, 4].map { $0 * 2 }

// (3) Swift will not allow you to ignore parameters
(0 ..< 3).map { _ in Int.random(in: 1 ..< 100) }
// Using (0 ..< 3).map { Int.random(in: 1 ..< 100) } will throw an error

// Sometimes type infer might not give you what you want
let isEven = { $0 % 2 == 0 } // Gives (Int) -> Bool, but what if you want Int8, then you need to explicitly type it

let isEvenAlt = { (i: Int8) -> Bool in i % 2 == 0 }
let isEvenAlt2: (Int8) -> Bool = { $0 % 2 == 0 } // You can rewrite the code above in this form by typing outside the context
let isEvenAlt3 = { $0 % 2 == 0 } as (Int8) -> Bool // There is also this formm though not very common

// But the best solution is to write an isEven version that works for all types
extension BinaryInteger {
    var isEven: Bool { return self % 2 == 0 }
}

// We could also define isEven variant as a free function
func isEven<T: BinaryInteger>(_ i: T) -> Bool {
    return i % 2 == 0
}

/*:
### Flexibility through Functions
 - Example: Sort
   - There are 4 sorting methods: non-mutating variant sorted(by:), and the mutating sort(by:), times two for the versions that default to sorting comparable things in ascending order and take no arguments. For the most common case, sorted (is all you need)
 - NSDescriptors
   - Describes how to order objects, and we can use them to express individual sorting criteria
   - When using multiple descriptors, what will happen is it will sort using the first descriptors and if two values match it will use the following descriptor and so on
 */

let myArray = [3, 2, 1]
myArray.sorted()

myArray.sorted(by: >) // [3, 2, 1]

// Also possible to sort through elements which do not conform to Comparable but do have a < operator. Such as tuples
var numberStrings = [(2, "two"), (1, "one"), (3, "three")]
numberStrings.sorted(by: <) // [(1, "one"), (2, "two"), (3, "three")]

let pokemons = [
    Pokemon(name: "Pikachu", type: "Electric", yearOfBirth: 3),
    Pokemon(name: "Charmander", type: "Fire", yearOfBirth: 5),
    Pokemon(name: "Squirtle", type: "Water", yearOfBirth: 2),
    Pokemon(name: "Bulbasaur", type: "Grass", yearOfBirth: 10),
    Pokemon(name: "Mew", type: "Psychic", yearOfBirth: 5),
    Pokemon(name: "Gengar", type: "Ghost", yearOfBirth: 3),
    Pokemon(name: "Moltres", type: "Fire", yearOfBirth: 10),
    Pokemon(name: "Moltres", type: "Fire", yearOfBirth: 3)
]

// Descriptors
let typeDescriptor = NSSortDescriptor(
    key: #keyPath(Pokemon.type),
    ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:))
)

let nameDescriptor = NSSortDescriptor(
    key: #keyPath(Pokemon.name),
    ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:))
)

let ageDescriptor = NSSortDescriptor(
    key: #keyPath(Pokemon.age),
    ascending: true
)

// To sort an array we need to use sortedArray(using:)
let descriptors = [typeDescriptor, nameDescriptor, ageDescriptor]
(pokemons as NSArray).sortedArray(using: descriptors)

/*:
**Functions as Data** (Sub-topic in Flexibility through Functions)
 */

// Creating our own SortDescriptor
typealias OwnSortDescriptor<Root> = (Root, Root) -> Bool


/// Sorting
/// - Parameters:
///   - key: Describes how to get a value from an element of type Root
///   - areInIncreasingOrder: Describes  how we should order two elements
/// - Returns: A sorting descriptor
func sortDescriptor<Root, Value>(
    key: @escaping (Root) -> Value,
    by areInIncreasingOrder: @escaping (Value, Value) -> Bool
) -> OwnSortDescriptor<Root> {
    return { areInIncreasingOrder(key($0), key($1)) }
}

/*:
> How does it work to use SortDescriptors on new Swift Versions.
> - Easier than what is presented before on the book, no need to create a custom function
> - sorted(using:) already accepts an array of descriptors, no need of creating a custom function
 */

let typeDescriptorSwift = SortDescriptor(\Pokemon.type, order: .forward)
let nameDescriptorSwift = SortDescriptor(\Pokemon.name, order: .forward)
let ageDescriptorSwift = SortDescriptor(\Pokemon.age, order: .forward)

pokemons.sorted(using: [typeDescriptorSwift, nameDescriptorSwift, ageDescriptorSwift])

/*:
## Functions as Delegates
 - Drummed into our heads. Define a protocol, your owner implements that protocol and registers itself as your delegate, so it gets callbacks
 */

/*:
### Delegates, Cocoa Style
 - Defined as a class-only protocol (AnyObject), because our view to hold a weak refence to avoid reference cycles
 */

// Example
protocol AlertViewDelegate: AnyObject {
    func buttonTapped(at index: Int)
}

class AlertView {
    var buttons: [String]
    weak var delegate: AlertViewDelegate?

    init(buttons: [String] = ["Ok", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        delegate?.buttonTapped(at: 1)
    }
}

class ViewController: AlertViewDelegate {
    let alert: AlertView

    init() {
        alert = AlertView()
        alert.delegate = self
    }

    func buttonTapped(at index: Int) {
        print("Button tapped: \(index)")
    }
}

/*:
### Delegates That Work with Structs
 - We can remove the class definition to AnyObject, and define the delegate as mutating.
 - We also change our AlertView so the delegate is not weak anymore, but this will create a strong reference
 - This section is just to point out not to use structs as delegates :kekw:
 */

/*:
### Functions instead of Delegates
 - If the delegate only has one method defined we can replace the delegate by a property that stores the callback
 */

// Example
class ClosureAlertView {
    var buttons: [String]
    var buttonTapped: ((_ buttonIndex: Int) -> ())?

    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        buttonTapped?(1)
    }
}

struct TapLogger {
    var taps: [Int] = []

    mutating func logTap(index: Int) {
        taps.append(index)
    }
}

let alert = ClosureAlertView()
var logger = TapLogger()

// we cannot do this alert.buttonTapped = logger.logTap. This will throw an error due to the ambiguous behaviour.

// With this definition, we are making sure that we are capturing the logger variable, and mutating it
alert.buttonTapped = { logger.logTap(index: $0) }

/*:
## inout Parameters and Mutating Methods
 - The & in front of inout functions are essentially pass-by-reference. **But they are not**. They are actually pass-by-value-and-copied-back.
   - Swift's definition: An inout parameter has a value that is passed in to the function, modified by the function, and is passed back out of the function to replace the original value.
 - Not every value can be passed as an inout. So we need to understand the difference between lvalues and rvalues
   - *lvalue*: Describes a memory location, lvalue is short for "left value", because lvalues are expressions that can appear on the left side of an assignment (such as var a, a is a lvalue)
   - *rvalue*: Describes a literal of sorts, such as 2 + 2. This expression cannot be placed on the left side of an assignment statement
 - For inout parameters we can only pass lvalues, due to the fact that it does not make sense to mutate an rvalue
 - If we define a variable as a let we cannot use it as an inout
 - If a property is read-only we can't use it as an inout parameter
 - Can be used with optional chaininig as well (1)
 */

func increment(value: inout Int) {
    value += 1
}

var i = 0
increment(value: &i)
i

// We can pass array subscripts
var arrayA = [0, 1, 2]
increment(value: &arrayA[0])
arrayA // :pog:

// Also works with custom subscripts
var pointA = Point(x: 0, y: 0)
increment(value: &pointA.x)
pointA.x

// Also applied to operators
postfix func ++(x: inout Int) {
    x += 1
}

pointA.x++
pointA.x // 2

// (1) Optional Chaining example
var dictionary = ["one": 1]
dictionary["one"]?++
dictionary["one"] // Optional(2)

/*:
### Nested Functions and inout
 - 
 */
