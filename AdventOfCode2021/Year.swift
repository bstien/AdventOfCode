import Foundation

protocol Year {
    static var year: Int { get }
    static var days: [Day.Type] { get }

    static func run(day: Int, includeTest: Bool)
    static func runAll()
    static func runLatest(includeTest: Bool)
}

extension Year {
    static func run(day: Int, includeTest: Bool = false) {
        daysInitialized[day - 1].solve(includeTest: includeTest)
    }

    static func runAll() {
        daysInitialized.forEach { $0.solve() }
    }

    static func runLatest(includeTest: Bool = false) {
        daysInitialized.last?.solve(includeTest: includeTest)
    }

    private static var daysInitialized: [Day] {
        days.enumerated().map {
            $0.element.init(year: year, day: $0.offset + 1)
        }
    }
}
