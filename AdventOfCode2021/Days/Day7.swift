import Foundation

struct Day7: Day {
    static func run(input: String) {
        let positions = splitInput(input).first!.split(separator: ",").map(String.init).compactMap(Int.init)
        findOptimalPosition(dayPart: 1, positions: positions, distanceMultiplier: { $0 })
        findOptimalPosition(dayPart: 2, positions: positions, distanceMultiplier: { ($0 * ($0 + 1)) / 2 })
    }

    private static func findOptimalPosition(dayPart: Int, positions: [Int], distanceMultiplier: (Int) -> Int) {
        let positionCount = Dictionary(grouping: positions, by: { $0 })

        let optimalPosition = (0...positions.max()!)
            .map { position -> (Int, Int) in
                (position, positionCount.map { distanceMultiplier(abs($0 - position)) * $1.count }.reduce(0, +))
            }
            .min(by: { $0.1 <= $1.1 })!

        printResult(dayPart: dayPart, message: "Position \(optimalPosition.0), fuel \(optimalPosition.1)")
    }

    private static func findMeanAndAveragePositions(positions: [Int]) {
        // Strangely enough, these results match the positions of part 1 and 2.
        // Not sure if it's a coincidence or that these are meant to be used.

        let positions = positions.map(Double.init)
        let meanPosition = Int(positions.sorted()[positions.count / 2])
        print("🔥 Mean position = \(meanPosition)")

        let averagePosition = Int(positions.reduce(0.0, +) / Double(positions.count))
        print("🔥 Average position = \(averagePosition)")
    }
}
