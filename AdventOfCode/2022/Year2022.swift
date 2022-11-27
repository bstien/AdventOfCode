import Foundation

enum Year2022: Year {
    static var year = 2022
    static var days: [Day.Type] = [
        Day1.self,
    ]
}

extension Year2022 {
    class Day1: Day {}
}
