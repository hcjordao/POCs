import UIKit

/*:
# 2. Built-in Collections
## Arrays
### Arrays & Mutability

Arrays are values types. Which means that its values are copied instead of passing by reference
*/

var x = [1, 2, 3]
var y = x

y.append(4)

// It will be noticeable that the value from x will not change
x
y

/*:
However changing values on a class inside type on an array, will mutate it.
*/
let historicPersons = [
    Person(name: "Alexander, the Great", age: 25),
    Person(name: "Napolleon", age: 40),
    Person(name: "Zeus", age: 300)
]

let duplicateOfHistoricPersons = historicPersons

// Mutating single value from the duplicate array
duplicateOfHistoricPersons[0].age = 26

// Both constant arrays were mutated
historicPersons
duplicateOfHistoricPersons

/*:
It is possible to mutate constant array through the use of the mutable types.

Not only that, but we can create an unmutable property out of the mutable array using copy.
*/

// An array in which I want to mutate
let arrayA = NSMutableArray(array: [1, 2, 3])

// An array in which I do not want to mutate
let arrayB: NSArray = arrayA

// However array B can still be mutated through A
arrayA.insert(4, at: 3)

// As you can see below, arrayB was mutated undirectly.
arrayB

// To correctly perform this, we need to copy the value from the first array to the second.
let arrayC = NSMutableArray(array: [1, 2, 3])

// Only a copy of C which will not be able to be mutated afterwards. A cast is needed because the copy operation
// returns an any type
let arrayD = arrayC.copy() as! NSArray

// Performing same mutation
arrayC.insert(4, at: 3)

// The arrayD is not mutated
arrayD

/*:
### Array Indexing

Swift discourages index math to avoid the problems such as the C language and loops.

### Transforming Arrays

The transformation of arrays can be perfomed through a series of already created functions on Swift. Such as map, flatMap, filter, ... (Will not focus on this)

Parameterizing Behavior with functions:
 * Creating functions such as map to avoid having to write boiler plate code and focus on what really matters.
 * Using this to your advantage will increase the code readibility
 * Just careful to not over engineer something very simple

For Example, lets create a function which splits an array into groups of adjacent equal elements.
*/

// We could write this
let groupedArray = [1, 2, 2, 2, 3, 4, 4]

// Example 1:
// Generate first case
var result: [[Int]] = groupedArray.isEmpty ? [] : [[groupedArray[0]]]

// Iterate through elements
for (previous, current) in zip(groupedArray, groupedArray.dropFirst()) {
    if previous == current {
        result[result.endIndex - 1].append(current)
    } else {
        result.append([current])
    }
}

result
// End of Example 1

// Example 2:
// Extract split functionality to extension
extension Array where Element: Equatable {
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = isEmpty ? [] : [[self[0]]]

        for (previous, current) in zip(self, dropFirst()) {
            if condition(previous, current) {
                result[result.endIndex - 1].append(current)
            } else {
                result.append([current])
            }
        }

        return result
    }
}

// This code above is extracted to a file of extensions, so now our code looks like this. Which uses 1 line of code.
let splitArray = groupedArray.split(where: ==)
let splitDifferentArray = groupedArray.split(where: !=)

/*:
### Array Slices

Array slices are extremely cheap to use, better than creating another array. This is because an array slice is only a "View" of the current array.
 */

let arrayE = [1, 2, 3, 4, 5]

// Same as arrayE without the first item.
var sliceOfE = arrayE[1...]

// Attempting to access an undefined index of an array slice will generate a crash.
// If the array slice did not map the index from the original array, it will not be able to access it.
//
// let crashSliceOfE = sliceOfE[0]

// The array slice has the same properties and can realize the same operations as a normal array could.
// This is because the ArraySlice type conforms to the same protocols, especially the Collection protocol.
sliceOfE.append(6)

// To create a new array
let arrayF = Array(sliceOfE)

/*:
## Dictionaries

* Retrieving values from dictionaries take a constant time while retrieving a value from an array grows linearly with the size of the array
* Dictionaries have no order
* The return of a dictionary lookup is always optional
*/

/*:
### Mutating Dictionaries

* Dictionaries defined with lets are immutable.
* Dictionaries are value types like arrays

*/

// Values are not changed, due to it being value types
var userSettings = defaultSettings
userSettings["Name"] = .text("Napoleon's iPhone")
userSettings["Airplane Mode"] = .bool(true)

userSettings["Name"]
defaultSettings["Name"]

// Value can be updated and return old through updateValue function
let oldName = userSettings.updateValue(.text("Alexander iPhone"), forKey: "Name")
userSettings["Name"]

/*:
### Some Useful Dictionary Methods

Dictionary merge(_:uniquingKeysWith:) method
*/

// Base mutable settings
var settings: [String: Setting] = defaultSettings

// Override settings to be merged
let overriddenSettings: [String: Setting] = ["Name": .text("Napoleon's iPhone")]

settings.merge(overriddenSettings, uniquingKeysWith: { $1 })
settings["Name"]

/*:
Map values: Sometimes we want to perform operations on the Dictionary without changing its structure
*/

let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case let .text(text): return text
    case let .int(number): return String(number)
    case let .bool(value): return String(value)
    }
}

/*:
### Hashable Requirement
 - Dictionaries are hash tables
 - Reason to why dictionaries keys must be conformed to the hashable protocol
 - Most default properties are already hashable
 - Structures can become already hashable if all properties are hashable
 - If not able to use the automatic hashble
 */

/*:
## Sets
 - Unordered collection of elements, with each element, appearing only once
 - Basically a dictionary that stores keys and no value
 - The implementation of a set is with a hash table and has the same performance characteristics and requirements
 - A set can be initialized by an array
 - Set can use common operations like arrays: map, filter,...
*/

let naturals: Set = [1, 2, 3, 2]
naturals
naturals.contains(3) // true
naturals.contains(0) // false

/*:
### Set & Algebra
 - Supports all mathematical sets operations
 */

// Subtratacting
let iPods: Set = ["iPod Touch", "iPod Nano", "iPod Mini", "iPod Shuffle", "iPod Classic"]
let discountinuedIpods: Set = ["iPod Mini", "iPod Clasic", "iPod Nano", "iPod Shuffle"]
let currentIpods = iPods.subtracting(discountinuedIpods) // Only Touch

// It is also possible to intersect
let touchscreen: Set = ["iPhone", "iPad", "iPod Nano"]
let iPodsWithTouch = iPods.intersection(touchscreen) // Nano / Touch

// It is also to creaate a union of two sets and combine them. Without duplicates
var discontinued: Set = ["iBook", "PowerBook", "Power Mac"]
discontinued.formUnion(discountinuedIpods)
discontinued

/*:
### Index Sets & Character Sets
 - Set and OptionSet are the only types that conform to SetAlgebra
 - But there are other types in Foundation: IndexSet & CharacterSet. Both dated before swift was a thing. They are bridged from Objective-C
 - IndexSet represents a set of positive interger values
   - More efficient than a normal set due to the usage of ranges to store.
   - Say we have a list of 1000 rows in a tableview, we can easily store them in an IndexSet with the lower and top bound
   - Stores a set of ranges
 - CharacterSet is also an efficient way to store a set of Unicode code points
   - Normally used to verify if a string contains characters from a specific character subset
 */

var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 0..<7)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter { $0 % 2 == 0 }
evenIndices

/*:
### Using Sets inside closures
 - Both dictionaries & sets can be very useful data strctures to be used inside our functions
 */

extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []

        return filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        }
    }
}

// Order in the array is preserved
[1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique()

/*:
## Ranges
 - Interval of values with defined lower and upper bounds
*/

let singleDigitNumbers = 0..<10
Array(singleDigitNumbers)

let lowercaseLetters = Character("a")...Character("z")

/*:
### Countable Ranges
 - Range that seems like a natural fit for sequences and collections
 - But there are other ranges that are not countable, such as our example of the lowercaseLetters above, the compiler wil not let us iterate over a range of Characters
   - This happens because its elements do not conform to the protocol Stridable, go from element to another by adding an offsert
 */

/*:
### Partial Ranges
 - Initialized by using ... or ..< as prefix or postfix operator
 - In the same way CountableRange is a typealias for range with strideable element types. CountablePartialRangeFrom is a type alias for PartialRangeFrom bu with tighter constraints
 - When iterating with PartialRangeFrom it needs to have a break, otherwise the code will run forever
   - This happens due to the fact that the iteration starts with a lower bound and increments itself using advanced(by: 1) with no upper limit
 */

let fromA: PartialRangeFrom<Character> = Character("a")...
let throughZ: PartialRangeThrough<Character> = ...Character("z")
let upto10: PartialRangeUpTo<Int> = ..<10

let partialCountableRange: PartialRangeFrom<Int> = 15...
var arrayH = [Int]()

for i in partialCountableRange {
    guard i < 20 else {
        break
    }

    arrayH.append(i)
}

arrayH

/*:
### Range Expressions
 - All five rage types confiorm to the RangeExpression protocol
 - The purpose of the protocol is to allow a verification if an element is inside a range
 */

let arrayI = [1, 2, 3, 4]
arrayI[2...]
arrayI[..<1]
arrayI[1...2]

/*
# Important notes to take
 - Parameterizing Behavior with functions to reduce boilerplate in code and extract it into simpler functions and extensions
   - Be careful to not over engineer
 - Using ArraySlices are an optimal form of working with array due to it being a view through the array
 - Retrieving values from a dictionaries require a constant time while arrays will increase depending on the size of the array
 - Dictionaries, Sets and Arrays are value types
 - Dictionaries and Sets are optimized due to the fact of them being hash tables
 - Dictionaries and Sets are good intermediate structures on functions inside closures
 */
