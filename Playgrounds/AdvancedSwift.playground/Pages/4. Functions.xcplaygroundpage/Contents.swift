import UIKit

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
 */
