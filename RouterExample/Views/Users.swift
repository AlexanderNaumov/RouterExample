import SwiftUI
import Router

struct Users: View {
    
    @EnvironmentObject private var navigator: Navigator
    
    private let users = [
        "Вася",
        "Коля",
        "Дима",
        "Света"
    ]
    
    var body: some View {
        List {
            ForEach(0..<users.count, id: \.self) { index in
                Button {
                    navigator.navigate("/users/\(index)")
                } label: {
                    Text(users[index])
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarTitle("Users")
    }
}
