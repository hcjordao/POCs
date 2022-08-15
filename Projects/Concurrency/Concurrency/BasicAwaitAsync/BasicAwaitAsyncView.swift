import SwiftUI

struct BasicAwaitAsyncView: View {
    @ObservedObject var viewModel: BasicAwaitAsyncViewModel
    @State var text: String

    init(viewModel: BasicAwaitAsyncViewModel) {
        self.viewModel = viewModel
        text = "Loading!"
    }

    var body: some View {
        Text(text)
            .onAppear {
                Task {
                    text = try await viewModel.someBridgedAsyncFunction(shouldFail: true)
                }
            }
    }
}

struct BasicAwaitAsyncView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BasicAwaitAsyncViewModel()

        return BasicAwaitAsyncView(viewModel: viewModel)
    }
}
