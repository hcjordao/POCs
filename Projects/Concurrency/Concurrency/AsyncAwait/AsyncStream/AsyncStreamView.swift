import SwiftUI

struct AsyncStreamView: View {
    let downloader = FileDownloader()
    @State var text: String = "Loading..."

    init() {
    }

    var body: some View {
        Text(text)
            .onAppear {
                Task {
                    await downloadData()
                }
            }
    }

    func downloadData() async {
        text = "Preparing your download"
        await AsyncSim.sleep(for: 2)

        do {
            for try await status in downloader.download("dummyurl.com") {
                switch status {
                case let .downloading(progress):
                    text = "Download progress: \(progress)%"

                case .finished:
                    text = "Download finished!"
                }
            }
        } catch {
            text = "An error ocurred!"
        }
    }
}

struct AsyncStreamView_Previews: PreviewProvider {
    static var previews: some View {
        return AsyncStreamView()
    }
}

// MARK: File Downloader Simulator
struct FileDownloader {
    enum Status {
        case downloading(Float)
        case finished
    }

    func download(_ url: String, progressHandler: @escaping (Float) -> Void, completion: @escaping (Result<String, Error>) -> Void) throws {
        AsyncSim.sleepThenExecute(for: 1) {
            progressHandler(Float(10))
        }

        AsyncSim.sleepThenExecute(for: 2) {
            progressHandler(Float(60))
        }

        AsyncSim.sleepThenExecute(for: 4) {
            completion(.success("Dummy Completion Success"))
        }
    }

    func download(_ url: String) -> AsyncThrowingStream<Status, Error> {
        AsyncThrowingStream { continuation in
            do {
                try download(
                    url,
                    progressHandler: { progress in
                        continuation.yield(.downloading(progress))
                    },
                    completion: { result in
                        continuation.yield(with: result.map { _ in .finished })
                        continuation.finish()
                    }
                )
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
}
