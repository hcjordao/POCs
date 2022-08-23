import UIKit

/*:
# Built-in Collections
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
            if previous == current {
                result[result.endIndex - 1].append(current)
            } else {
                result.append([current])
            }
        }

        return result
    }
}

// This code above is extracted to a file of extensions, so now our code looks like this. Which uses 1 line of code.
let splitArray = groupedArray.split(where: !=)

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
## Sets
*  
*/

/*:
## Ranges
*/
