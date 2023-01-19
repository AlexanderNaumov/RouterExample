import SwiftUI
import Introspect

private final class Continer {
    weak var vc: UIViewController?
}

private final class HostingControllerContent<Content: View>: UIHostingController<Content> {
    var didDisappear: (() -> Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear?()
    }
}

struct FullScreenModifier<ViewContent: View>: ViewModifier {
    let path: String
    @ViewBuilder let viewContent: ([String: String]) -> ViewContent
    @EnvironmentObject private var navigator: Navigator
    @State private var isPresented = false
    
    private let container = Continer()
    
    func body(content: Content) -> some View {
        content.introspectViewController { vc in
            if isPresented && container.vc == nil {
                let params = params(path, path: navigator.path.value)
                let view = viewContent(params).environmentObject(navigator)
                let newVC = HostingControllerContent(rootView: view)
                newVC.modalPresentationStyle = .fullScreen
                newVC.didDisappear = {
                    isPresented = false
                }
                vc.present(newVC, animated: true)
                container.vc = newVC
            }
        }
        .onChange(of: isPresented) {
            guard !$0 else { return }
            navigator.back(with: path)
        }
        .onReceive(navigator.path) { _ in
            isPresented = navigator.contains(path)
            if !isPresented {
                container.vc?.dismiss(animated: true)
            }
        }
    }
}

public extension View {
    @ViewBuilder func fullScreen<Content: View>(_ path: String, @ViewBuilder content: @escaping ([String: String]) -> Content) -> some View {
        modifier(FullScreenModifier(path: path, viewContent: content))
    }
    @ViewBuilder func fullScreen<Content: View>(_ path: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(
            FullScreenModifier(path: path) { _ in
                content()
            }
        )
    }
}
