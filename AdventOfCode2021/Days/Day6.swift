import Foundation

struct Day6: Day {
    static func run(input: String) {
        let lanternFish = splitInput(input).first!.split(separator: ",").map(String.init).compactMap(Int.init)
        part1(lanternFish: lanternFish)
    }

    private static func part1(lanternFish: [Int]) {
        var lanternFish = lanternFish

        var day = 1
        repeat {
            var newFish = [Int]()
            lanternFish = lanternFish.map {
                if $0 == 0 {
                    newFish.append(8)
                    return 6
                }
                return $0 - 1
            }

            lanternFish.append(contentsOf: newFish)
            day += 1
        } while day <= 80

        printResult(dayPart: 1, message: "Count after 80 days: \(lanternFish.count)")
    }
}
