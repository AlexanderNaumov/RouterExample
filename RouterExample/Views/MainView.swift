import SwiftUI
import Router

struct MainView: View {
    var body: some View {
        Router {
            TabBarView()
                .tab("/users/*") {
                    NavigationView {
                        Users()
                            .stack("/users/:id") { params in
                                UserDetail(id: params["id"] ?? "")
                            }
                    }
                } label: {
                    Image(systemName: "globe")
                    Text("users")
                }
                .tab("/sheet/*") {
                    SheetView()
                        .sheet("/sheet/:name") { params in
                            SheetContent(name: params["name"] ?? "")
                        }
                } label: {
                    Image(systemName: "globe")
                    Text("sheet")
                }
                .tab("/fullscreen/*") {
                    FullScreenView()
                        .fullScreen("/fullscreen/:name") { params in
                            FullScreenContent(name: params["name"] ?? "")
                                .edgesIgnoringSafeArea(.all)
                        }
                } label: {
                    Image(systemName: "globe")
                    Text("FullScreen")
                }
                .tab("/alert/*") {
                    AlertView()
                        .alert("/alert/:name") { params in
                            Alert(title: Text("Hello \(params["name"] ?? "")"))
                        }
                } label: {
                    Image(systemName: "globe")
                    Text("alert")
                }
        }
    }
}


