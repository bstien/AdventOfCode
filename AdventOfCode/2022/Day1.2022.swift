import Foundation

extension Year2022.Day1: Runnable {
    func run(input: String) {
        let elves = input.components(separatedBy: "\n\n").map { splitInput($0).compactMap(Int.init) }
        let calorieCount = elves.map { $0.reduce(0, +) }.sorted(by: { $0 > $1 })

        printResult(dayPart: 1, message: "Elf with highest calorie count: \(calorieCount.max()!)")

        let topThreeElves = calorieCount.prefix(3).reduce(0, +)
        printResult(dayPart: 2, message: "Calorie count of top 3 elves: \(topThreeElves)")
    }
}
