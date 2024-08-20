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
                .background(Color(UIColor(red: 1.0, green: 0.917, blue: 0.655, alpha: 1.0)))
                .edgesIgnoringSafeArea(.all)
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
