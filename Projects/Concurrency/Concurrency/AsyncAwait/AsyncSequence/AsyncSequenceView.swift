import SwiftUI

struct AsyncSequenceView: View {
    @ObservedObject var viewModel: AsyncSequenceViewModel

    init(viewModel: AsyncSequenceViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.listOfTemperatures, id: \.self) { temperature in
                Text("Sample: \(temperature)")
            }
        }
        .onAppear {
            Task {
                await viewModel.monitorTemperatureChanges()
            }
        }
    }
}

struct AsyncSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AsyncSequenceViewModel()

        return AsyncSequenceView(viewModel: viewModel)
    }
}
