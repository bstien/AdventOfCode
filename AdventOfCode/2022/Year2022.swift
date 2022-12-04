import Foundation

enum Year2022: Year {
    static var year = 2022
    static var days: [Day.Type] = [
        Day1.self,
        Day2.self,
        Day3.self,
        Day4.self,
    ]
}

extension Year2022 {
    class Day1: Day {}
    class Day2: Day {}
    class Day3: Day {}
    class Day4: Day {}
}
