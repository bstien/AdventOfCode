import Foundation

protocol Year {
    static var year: Int { get }
    static var days: [Day.Type] { get }

    static func run(day: Int, runTest: Bool)
    static func runAll()
    static func runLatest(runTask: Bool, runTest: Bool)
}

extension Year {
    static func run(day: Int, runTest: Bool = false) {
        daysInitialized[day - 1].solve(runTest: runTest)
    }

    static func runAll() {
        daysInitialized.forEach { $0.solve() }
    }

    static func runLatest(runTask: Bool = true, runTest: Bool = false) {
        daysInitialized.last?.solve(runTask: runTask, runTest: runTest)
    }

    private static var daysInitialized: [Day] {
        days.enumerated().map {
            $0.element.init(year: year, day: $0.offset + 1)
        }
    }
}
