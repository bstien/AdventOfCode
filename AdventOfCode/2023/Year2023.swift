import Foundation

enum Year2023: Year {
    static var year = 2023
    static var days: [Day.Type] = [
        Day1.self,
    ]
}

extension Year2023 {
    class Day1: Day {}
}
