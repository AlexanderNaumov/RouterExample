import SwiftUI

private struct StackModifier<ViewContent: View>: ViewModifier {
    let path: String
    @ViewBuilder let viewContent: ([String: String]) -> ViewContent
    @EnvironmentObject private var navigator: Navigator
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        let params = params(path, path: navigator.path.value)
        return content
            .background(
                NavigationLink(isActive: $isPresented) {
                    Container {
                        viewContent(params)
                    }
                } label: {
                    EmptyView()
                }
            )
            .onChange(of: isPresented) {
                guard !$0 else { return }
                navigator.back(with: path)
            }
            .onReceive(navigator.path) { _ in
                isPresented = navigator.contains(path)
            }
    }
}

public extension View {
    @ViewBuilder func stack<Content: View>(_ path: String, @ViewBuilder content: @escaping ([String: String]) -> Content) -> some View {
        modifier(StackModifier(path: path, viewContent: content))
    }
    @ViewBuilder func stack<Content: View>(_ path: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(
            StackModifier(path: path) { _ in
                content()
            }
        )
    }
}
