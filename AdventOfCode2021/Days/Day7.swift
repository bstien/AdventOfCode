import Foundation

struct Day7: Day {
    static func run(input: String) {
        let positions = splitInput(input).first!.split(separator: ",").map(String.init).compactMap(Int.init)
        part1(positions: positions)
    }

    private static func part1(positions: [Int]) {
        let minValue = positions.min()!
        let maxValue = positions.max()!

        let optimalPosition = (minValue..<maxValue).map { value -> (Int, Int) in
            let cycles = positions.map { abs($0 - value) }.reduce(0, +)
            return (value, cycles)
        }.min(by: { $0.1 <= $1.1 })!

        printResult(dayPart: 1, message: "Position \(optimalPosition.0), fuel \(optimalPosition.1)")
    }
}
