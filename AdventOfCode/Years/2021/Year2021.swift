import Foundation

enum Year2021: Year {
    static var year = 2021
    static var days: [Day.Type] = [
        Day1.self,
        Day2.self,
        Day3.self,
        Day4.self,
        Day5.self,
        Day6.self,
        Day7.self,
        Day8.self,
        Day9.self,
        Day10.self,
        Day11.self,
        Day12.self,
        Day13.self,
        Day14.self,
        Day15.self,
        Day16.self,
    ]
}

extension Year2021 {
    class Day1: Day {}
    class Day2: Day {}
    class Day3: Day {}
    class Day4: Day {}
    class Day5: Day {}
    class Day6: Day {}
    class Day7: Day {}
    class Day8: Day {}
    class Day9: Day {}
    class Day10: Day {}
    class Day11: Day {}
    class Day12: Day {}
    class Day13: Day {}
    class Day14: Day {}
    class Day15: Day {}
    class Day16: Day {}
}
