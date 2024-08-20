import SwiftUI
import RevenueCat

struct NotificationView: View {
    @StateObject var requestViewModel = RequestViewModel()
    @ObservedObject var sharedListViewModel = SharedListViewModel()
    @State private var email = ""

    var body: some View {
        VStack {
            List(requestViewModel.requests) { request in
                HStack {
                    VStack {
                        Text(filterText(request.fromUserEmail))
                            .lineLimit(1)
                            .bold()
                        Text("kullanıcısından gelen davet.")
                            .lineLimit(1...2)
                    }
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    Button(action: {
                        requestViewModel.updateRequestStatus(requestID: request.id, status: "accepted") { success in
                            if success {
                                // Özel liste oluşturma işlemini başlat
                                sharedListViewModel.createSharedList(with: [request.fromUserID, request.toUserID], title: "Yeni Liste")
                                requestViewModel.fetchReceivedRequests()
                            }
                        }
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 30))
                    }
                    .buttonStyle(.bordered)
                    Button(action: {
                        requestViewModel.updateRequestStatus(requestID: request.id, status: "rejected") { success in
                            if success {
                                requestViewModel.fetchReceivedRequests()
                            }
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                    }
                    .buttonStyle(.bordered)
                }
            }
            .onAppear {
                requestViewModel.fetchReceivedRequests()
            }
            Spacer()
            Text("Ortak Liste Oluştur")
                .font(.subheadline)
                .bold()
            HStack {
                TextField("Enter email to send request", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                Button(action: {
                    requestViewModel.sendRequest(to: email)
                }) {
                    Image(systemName: "plus.app")
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            Text(requestViewModel.requestStatus)
                .foregroundColor(requestViewModel.requestStatus == "Kullanıcı Bulunamadı!" ? .red : .green)
                .padding(.bottom)
        }
        .onAppear(perform: {
            Purchases.shared.getOfferings { offerings, error in
                if let error {
                    print(error)
                }
                if let offerings {
                    print(offerings)
                }
            }
        })
    }
}

struct InfiniteHorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

func filterText(_ text: String) -> String {
    guard let atIndex = text.firstIndex(of: "@") else {
        return text
    }
    return String(text[..<atIndex])
}
