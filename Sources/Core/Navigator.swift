import Foundation
import Combine

public final class Navigator: ObservableObject {
    private var historyStack: [String] = []
    
    let path = CurrentValueSubject<String, Never>("")
    
    public init() {}
    
    public func navigate(_ path: String) {
        let path = resolvePaths(self.path.value, path)
        
        if let index = historyStack.firstIndex(of: path) {
            historyStack.remove(at: index)
        }
        historyStack.append(path)
        self.path.send(path)
    }
    
    public func back(with path: String? = nil) {
        if let path {
            if let index = historyStack.firstIndex(where: { match(path, path: $0) }) {
                let path = historyStack.remove(at: index)
                self.path.send(path)
            }
        } else {
            let path = historyStack.removeLast()
            self.path.send(path)
        }
    }
    
    func contains(_ path: String) -> Bool {
        historyStack.contains { match(path, path: $0) }
    }
}

// MARK: - Utils

private func resolvePaths(_ lhs: String, _ rhs: String) -> String {
    NSString(string: (rhs.first == "/" ? rhs : lhs + "/" + rhs)).standardizingPath
}

func params(_ mask: String, path: String) -> [String: String] {
    let maskComponents = mask.components(separatedBy: "/").filter { !$0.isEmpty }
    let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
    
    var params: [String: String] = [:]
    
    for i in 0..<maskComponents.count where i < pathComponents.count {
        var mask = maskComponents[i]
        guard mask.prefix(1) == ":" else { continue }
        mask.removeFirst()
        params[mask] = pathComponents[i]
    }
    
    return params
}

func match(_ mask: String, path: String) -> Bool {
    let maskComponents = mask.components(separatedBy: "/").filter { !$0.isEmpty }
    let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty }
    
    var matchs = false
    
    for i in 0..<maskComponents.count {
        let mask = maskComponents[i]
        if mask == "*" {
            matchs = true
            break
        }
        guard i < pathComponents.count else {
            matchs = false
            break
        }
        if mask.prefix(1) == ":" {
            matchs = true
            continue
        }
        let path = pathComponents[i]
        matchs = mask == path
        if !matchs { break }
    }
    
    return matchs
}
