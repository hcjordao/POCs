import Foundation

class AsyncSequenceViewModel: ObservableObject {
    @Published var listOfTemperatures: [Temperature] = []

    init() {}

    func monitorTemperatureChanges() async {
        let temperatureMonitor = TempertureMonitor(delay: 5)

        for await temperature in temperatureMonitor {
            listOfTemperatures.append(temperature)
        }
    }
}

// MARK: Utils
typealias Temperature = Double

// Created a monitor, but we should really only use for decoding. For observing we should use a AsyncStream
struct TempertureMonitor: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = Temperature

    let delay: Int
    var currentTemperature = Temperature.random(in: -30...55)
    var isMonitoring = true

    public init(delay: Int) {
        self.delay = delay
    }

    mutating func next() async -> Temperature? {
        guard !Task.isCancelled else {
            return nil
        }

        guard isMonitoring else {
            return nil
        }

        await AsyncSim.sleep(for: delay)

        let temperatureDiff = Temperature.random(in: -2...2)
        return currentTemperature + temperatureDiff
    }

    func makeAsyncIterator() -> TempertureMonitor {
        self
    }
}
