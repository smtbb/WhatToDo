import SwiftUI
import FirebaseFirestore

struct SharedListRow: View {
    let sharedList: SharedList

    var body: some View {
        HStack {
            Text(sharedList.title)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SharedListRow_Previews: PreviewProvider {
    static var previews: some View {
        let exampleList = SharedList(id: "exampleID", title: "Example List", members: ["member1", "member2"], timestamp: Timestamp(date: Date()))
        return SharedListRow(sharedList: exampleList)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
