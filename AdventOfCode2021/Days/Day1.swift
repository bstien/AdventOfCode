import Foundation

struct Day1: Day {
    static func run(input: String) {
        let numbers = splitInput(input).compactMap(Int.init)
        part1(numbers: numbers)
        part2(numbers: numbers)
    }

    private static func part1(numbers: [Int]) {
        let answer = numberOfIncreases(from: numbers)
        printResult(dayPart: 1, message: "Number of increases: \(answer)")
    }

    private static func part2(numbers: [Int]) {
        let summedGroups = numbers.windowed(by: 3).map { $0.reduce(0, +) }
        let answer = numberOfIncreases(from: summedGroups)

        printResult(dayPart: 2, message: "Number of increases from windows: \(answer)")
    }

    private static func numberOfIncreases(from numbers: [Int]) -> Int {
        (0..<numbers.count - 1).reduce(into: 0) { result, index in
            result += numbers[index] < numbers[index + 1] ? 1 : 0
        }
    }
}

// MARK: - Private extensions

private extension Array {
    func windowed(by windowSize: Int) -> [[Element]] {
        (0..<count-windowSize + 1).reduce(into: [[Element]]()) { result, index in
            let elements = [self[index], self[index+1], self[index+2]]
            result.append(elements)
        }
    }
}
