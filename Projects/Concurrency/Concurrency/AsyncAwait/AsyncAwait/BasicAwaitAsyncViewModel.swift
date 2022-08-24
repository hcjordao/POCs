import Foundation

class BasicAwaitAsyncViewModel: ObservableObject {
    init() {}

    func someAsyncFunction() async -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return Constants.loaded
    }

    func someThrowableAsyncFunction(shouldFail: Bool = false) async throws -> String {
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        do {
            return try await simulateError(shouldFail: shouldFail)
        } catch ScreenError.dummy {
            return ScreenError.dummy.description
        }
    }

    func someBridgedAsyncFunction(shouldFail: Bool = false) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            someCompletionHandlerFunction(shouldFail: shouldFail) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)

                case .failure:
                    continuation.resume(returning: ScreenError.dummy.description)
                }
            }
        }
    }
}

private extension BasicAwaitAsyncViewModel {
    func simulateError(shouldFail: Bool = false) async throws -> String {
        if shouldFail {
            throw ScreenError.dummy
        } else {
            return Constants.loaded
        }
    }

    func someCompletionHandlerFunction(shouldFail: Bool = false, _ completion: @escaping (Result<String, ScreenError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if shouldFail {
                completion(.failure(ScreenError.dummy))
            } else {
                completion(.success(Constants.loaded))
            }
        }
    }
}

enum ScreenError: Error, CustomStringConvertible {
    case dummy

    var description: String {
        switch self {
        case .dummy: return "Dummy Error!"
        }
    }
}

enum Constants {
    static let loading = "Loading!"
    static let loaded = "Loaded!"
}
