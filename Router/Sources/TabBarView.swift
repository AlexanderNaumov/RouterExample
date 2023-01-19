import SwiftUI

private struct TabRoute: View {
    let path: String,
        content: ([String: String]) -> AnyView,
        label: (() -> AnyView)?
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        let params = params(path, path: navigator.path.value)
        return ZStack {
            content(params)
        }.tabItem {
            label?()
        }
    }
}

public struct TabBarView: View {
    @EnvironmentObject private var navigator: Navigator
    
    private var routes: [TabRoute] = []
    
    @State private var selected = -1
    
    public init() {}
    
    public var body: some View {
        return TabView(selection: $selected) {
            ForEach(0..<routes.count, id: \.self) { index in
                routes[index].tag(index)
            }
        }
        .onChange(of: selected) { newValue in
            var path = routes[newValue].path
            if path.suffix(1) == "*" {
                path = String(path.dropLast(2))
            }
            navigator.navigate("/\(path)")
        }
        .onReceive(navigator.path) { newValue in
            guard let index = routes.firstIndex(where: { match($0.path, path: newValue) }) else { return }
            selected = index
        }
        .onAppear {
            if !routes.isEmpty {
                selected = 0
            }
        }
    }
}

public extension TabBarView {
    func tab<Content: View, Label: View>(
        _ path: String,
        @ViewBuilder content: @escaping ([String: String]) -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) -> Self {
        var tabBar = self
        tabBar.routes.append(TabRoute(path: path, content: { AnyView(content($0)) }, label: { AnyView(label()) }))
        return tabBar
    }
    
    func tab<Content: View, Label: View>(
        _ path: String,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) -> Self {
        var tabBar = self
        tabBar.routes.append(TabRoute(path: path, content: { _ in AnyView(content()) }, label: { AnyView(label()) }))
        return tabBar
    }
    
    func tab<Content: View>(_ path: String, @ViewBuilder content: @escaping ([String: String]) -> Content ) -> Self {
        var tabBar = self
        tabBar.routes.append(TabRoute(path: path, content: { AnyView(content($0)) }, label: nil))
        return tabBar
    }
    
    func tab<Content: View>(_ path: String, @ViewBuilder content: @escaping () -> Content) -> Self {
        var tabBar = self
        tabBar.routes.append(TabRoute(path: path, content: { _ in AnyView(content()) }, label: nil))
        return tabBar
    }
}
