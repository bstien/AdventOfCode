import Foundation

struct Day7: Day {
    static func run(input: String) {
        let positions = splitInput(input).first!.split(separator: ",").map(String.init).compactMap(Int.init)
        findOptimalPosition(dayPart: 1, positions: positions, distanceMultiplier: { $0 })
        findOptimalPosition(dayPart: 2, positions: positions, distanceMultiplier: { ($0 * ($0 + 1)) / 2 })
    }

    private static func findOptimalPosition(dayPart: Int, positions: [Int], distanceMultiplier: (Int) -> Int) {
        var positionsWithCount = Array(repeating: 0, count: positions.max()! + 1)
        positions.forEach { positionsWithCount[$0] += 1 }
        let positionsWithCrabs = Array(Set(positions))

        let optimalPosition = (0..<positionsWithCount.count).map { index -> (Int, Int) in
            let fuel = positionsWithCrabs.map { distanceMultiplier(abs($0 - index)) * positionsWithCount[$0] }.reduce(0, +)
            return (index, fuel)
        }.min(by: { $0.1 <= $1.1 })!

        printResult(dayPart: dayPart, message: "Position \(optimalPosition.0), fuel \(optimalPosition.1)")
    }
}
