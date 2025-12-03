import Foundation

extension Year2025.Day3: Runnable {
    func run(input: String) {
        let banks = splitInput(input).map { Array($0).map(String.init).compactMap(Int.init) }

        let part1Sum = part1(banks: banks)
        printResult(dayPart: 1, message: "Sum of batteries: \(part1Sum)")
    }

    private func part1(banks: [[Int]]) -> Int {
        banks.reduce(0) { $0 + findHighestCombination(in: $1) }
    }

    private func findHighestCombination(in batteries: [Int]) -> Int {
        var high = 0
        var low = 0

        for (index, battery) in batteries.enumerated() {
            if battery > high && index != batteries.count - 1 {
                high = battery
                low = 0
            } else if battery > low {
                low = battery
            }
        }

        return high * 10 + low
    }
}
