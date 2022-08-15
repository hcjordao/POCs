import UIKit

var persons = [
    Person(name: "Henrique", surname: "Jordan", birth: 1995),
    Person(name: "Marianna", surname: "Sipauba", birth: 1994),
    Person(name: "Mario", surname: "Jordan", birth: 1967),
    Person(name: "Erika", surname: "Jordan", birth: 1968),
    Person(name: "Thor", surname: "Sipauba", birth: 2012),
    Person(name: "Yanka", surname: "Capelatto", birth: 2003)
]

typealias SortDescriptor<Root> = (Root, Root) -> Bool // Returns a function which compares
func sortDescriptor<Root, Value>(
    key: @escaping (Root) -> Value,
    by areInIncreasingOrder: @escaping (Value, Value) -> Bool
) -> SortDescriptor<Root> {
    return { areInIncreasingOrder(key($0), key($1)) }
}

func sortDescriptor<Root, Value>(
    key: @escaping (Root) -> Value, // Captures a value from root.
    ascending: Bool = true,
    by comparator: @escaping (Value) -> ((Value) -> ComparisonResult) // Compares captured values
) -> SortDescriptor<Root> {
    return {
        let order: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
        return comparator(key($0))(key($1)) == order
    }
}

func combine<Root>(
    _ array: [SortDescriptor<Root>]
) -> SortDescriptor<Root> {
    return {
        for descriptor in array {
            if descriptor($0, $1) { return true }
            if descriptor($1, $0) { return false }
        }
        return false
    }
}

let stringComparator: SortDescriptor<Person> = sortDescriptor(
    key: { $0.surname },
    by: String.localizedStandardCompare
)

let nameComparator: SortDescriptor<Person> = sortDescriptor(
    key: { $0.name },
    by: String.localizedStandardCompare
)

let ageComparator: SortDescriptor<Person> = sortDescriptor(
    key: { $0.birth },
    by: <
)

let combined: SortDescriptor<Person> = combine([stringComparator, nameComparator, ageComparator])

let yanka = persons[5]
let aki = persons[0]
var test = [yanka, aki]
ageComparator(aki, yanka)
ageComparator(yanka, aki)
test.sort(by: ageComparator)
