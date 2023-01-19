import SwiftUI

struct UserDetail: View {
    let id: String
    
    var body: some View {
        VStack {
            Text("User id: \(id)")
        }
    }
}
