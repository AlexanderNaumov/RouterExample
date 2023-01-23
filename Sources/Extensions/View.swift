import SwiftUI
import Combine

extension View {
    @_disfavoredOverload
    @ViewBuilder func onChange<V>(of value: V, perform action: @escaping (V) -> Void) -> some View where V: Equatable {
        if #available(iOS 14.0, *) {
            onChange(of: value, perform: action)
        } else {
            onReceive(Just(value)) { (value) in
                action(value)
            }
        }
    }
}
