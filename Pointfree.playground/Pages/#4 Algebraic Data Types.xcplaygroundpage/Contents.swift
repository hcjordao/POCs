import Foundation

/*:
 # 1.Functions

 ### Major take aways:
 - Types can be seem as algebraic values in order to deal with complex return results. Look at the URLSession.shared.dataTask
 */

struct Pair<A, B> {
    let first: A
    let second: B
}

enum Three {
    case one, two, three
}

// Pair<Bool, Bool> = Can hold 4 values = 2 * 2(f/f, f/t, t/f, t/t)
// Pair<Bool, Three> = Can hold 6 values = 2 * 3
// Pair<Bool, Void> = Can hold 2 values = 2 * 1
// Pair<Void, Void> = Can hold 1 values = 1 * 1
// Pair<Bool, Never> = Can hold 0 values = 2 * 0

enum Theme {
    case light
    case dark
}

enum State {
    case highlighted
    case normal
    case selected
}

struct Component {
    let enabled: Bool
    let state: State
    let theme: Theme
}

// 2 * 3 * 2 = 12 possible values

// Notation: Pair<A, B> = A * B
// Notation: Pair<Bool, Bool> = Bool * Bool
// Notation: Pair<Bool, Three> = Bool * Three
// Notation: Pair<Bool, Void> = Bool * Void
// Notation: Pair<Bool, Never> = Bool * Never

// Pair<Bool, String> = Bool * String
// String * [Int]
// [String] * [[Int]]
// Never = 0
// Void = 1
// Bool = 0
// 2 * String

enum Either<A, B> {
    case left(A)
    case right(B)
}

Either<Bool, Bool>.left(true)
Either<Bool, Bool>.left(false)
Either<Bool, Bool>.right(true)
Either<Bool, Bool>.right(false)
// Either<Bool, Bool> = 4 = 2 + 2
// 2 + 2

Either<Bool, Three>.left(true)
Either<Bool, Three>.left(false)
Either<Bool, Three>.right(.one)
Either<Bool, Three>.right(.two)
Either<Bool, Three>.right(.three)
// Either<Bool, Three> = 5 = 2 + 3
// Bool + Three
// 2 + Three

Either<Bool, Void>.left(true)
Either<Bool, Void>.left(false)
Either<Bool, Void>.right(())
// Either<Bool, Void> = 3 = 2 + 1
// Bool + Void
// 2 + 1

Either<Bool, Never>.left(true)
Either<Bool, Never>.left(false)
// Either<Bool, Never>.right(())
// Either<Bool, Never> = 2 = 2 + 0
// Bool + Never
// 2 + 0

struct Unit {}
let unit = Unit()

extension Unit: Equatable {
    static func ==(lhs: Unit, rhs: Unit) -> Bool {
        return true
    }
}

func sum(_ xs: [Int]) -> Int {
    var result: Int = 0
    for x in xs {
        result += x
    }
    return result
}

func product(_ xs: [Int]) -> Int {
    var result: Int = 1
    for x in xs {
        result *= x
    }
    return result
}

let xs = [Int]()
sum(xs)
product(xs)

sum([1, 2]) + sum([3]) == sum([1, 2, 3])
sum([1, 2]) + sum([]) == sum([1, 2])
product([1, 2]) * product([3]) == product([1, 2, 3])
product([1, 2]) * product([]) == product([1, 2])

// URLSession.shared
//    .dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, (any Error)?) -> Void#>)

// (Data + 1) * (URLResponse + 1) * (Error + 1)
// = Data * URLResponse * Error
// + Data * URLResponse
// + URLResponse * Error
// + Data * Error
// + Data
// + URLResponse
// + Error
// + 1

// Data * URL Response + Error

// Either<Pair<Data, URLResponse>, Error>
// Result<(Data, URLResponse), Error>
// Result<Date, Never>
// Result<A, Error>?


//: [Next](@next)
//: [Previous](@previous)
