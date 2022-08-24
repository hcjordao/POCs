import Foundation

enum AsyncSim {
    static func simulateValue<T>(awaitTime: Int = 1, generateFunction: () -> T) async -> T {
        try? await Task.sleep(nanoseconds: UInt64(awaitTime) * 1_000_000_000)

        return generateFunction()
    }

    static func sleep(for delay: Int = 1) async {
        try? await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
    }

    static func sleepThenExecute(for delay: Int = 1, function: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            function()
        }
    }
}
