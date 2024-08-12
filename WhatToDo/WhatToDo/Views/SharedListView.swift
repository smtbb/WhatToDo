import SwiftUI

struct SharedListView: View {
    @ObservedObject var sharedListViewModel = SharedListViewModel()
    @State private var sharedLists: [SharedList] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(sharedListViewModel.sharedLists) { sharedList in
                    NavigationLink(
                        destination: SharedTaskListView(
                            viewModel: SharedTaskViewModel(sharedListID: sharedList.id),
                            sharedListViewModel: sharedListViewModel
                        )
                    ) {
                        SharedListRow(sharedList: sharedList)
                    }
                }
                .onDelete(perform: sharedListViewModel.deleteSharedList)
            }
            .onAppear {
                sharedListViewModel.fetchSharedLists()
            }
            .navigationBarTitle("Ortak Listeler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SharedListView_Previews: PreviewProvider {
    static var previews: some View {
        SharedListView()
    }
}
