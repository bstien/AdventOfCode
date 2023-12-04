import Foundation

extension Sequence where Element: Numeric {
    var sum: Element {
        reduce(0, +)
    }
}
