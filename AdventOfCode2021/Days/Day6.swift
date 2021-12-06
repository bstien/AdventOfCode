import Foundation

struct Day6: Day {
    static func run(input: String) {
        let lanternFish = splitInput(input).first!.split(separator: ",").map(String.init).compactMap(Int.init)
        part1(lanternFish: lanternFish)
        part2(lanternFish: lanternFish)
    }

    private static func part1(lanternFish: [Int]) {
        let count = calculateCount(days: 80, lanternFish: lanternFish)
        printResult(dayPart: 1, message: "Count after 80 days: \(count)")
    }

    private static func part2(lanternFish: [Int]) {
        let count = calculateCount(days: 256, lanternFish: lanternFish)
        printResult(dayPart: 2, message: "Count after 256 days: \(count)")
    }

    private static func calculateCount(days: Int, lanternFish: [Int]) -> Int {
        var day = 1
        var schools = Dictionary(grouping: lanternFish, by: { $0 }).reduce(into: [School]()) { result, tuple in
            result.append(School(count: tuple.value.count, daysLeft: tuple.key))
        }

        repeat {
            var newFish = 0
            for school in schools {
                if school.daysLeft == 0 {
                    school.daysLeft = 6
                    newFish += school.count
                } else {
                    school.daysLeft -= 1
                }
            }

            if newFish >= 1 {
                schools.append(School(count: newFish, daysLeft: 8))
            }
            day += 1
        } while day <= days

        return schools.map(\.count).reduce(0, +)
    }
}

// MARK: - Private types

private class School {
    let count: Int
    var daysLeft: Int

    init(count: Int, daysLeft: Int) {
        self.count = count
        self.daysLeft = daysLeft
    }
}
