import SwiftUI

public struct Router<Content: View>: View {
    private let navigator: Navigator,
                content: () -> Content
    
    public init(
        navigator: Navigator,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigator = navigator
        self.content = content
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.navigator = Navigator()
        self.content = content
    }
    
    public var body: some View {
        content().environmentObject(navigator)
    }
}
