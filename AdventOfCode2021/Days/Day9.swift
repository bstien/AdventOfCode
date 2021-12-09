import Foundation

struct Day9: Day {
    static func run(input: String) {
        let landscape = splitInput(input).map { $0.map { Int(String($0))! } }
        part1(landscape: landscape)
    }

    private static func part1(landscape: [[Int]]) {
        var lowPoints = [Int]()
        for y in (0..<landscape.count) {
            for x in (0..<landscape[y].count) {
                let positionValue = landscape[y][x]
                let isSmaller = [
                    checkIfHigherAndExists(positionValue: positionValue, x: x + 1, y: y, landscape: landscape),
                    checkIfHigherAndExists(positionValue: positionValue, x: x - 1, y: y, landscape: landscape),
                    checkIfHigherAndExists(positionValue: positionValue, x: x, y: y + 1, landscape: landscape),
                    checkIfHigherAndExists(positionValue: positionValue, x: x, y: y - 1, landscape: landscape)
                ].compactMap { $0 }.allSatisfy { $0 }

                if isSmaller { lowPoints.append(positionValue) }
            }
        }

        let sum = lowPoints.map { $0 + 1 }.reduce(0, +)
        printResult(dayPart: 1, message: "Sum of all low positions: \(sum)")
    }

    private static func checkIfHigherAndExists(positionValue: Int, x: Int, y: Int, landscape: [[Int]]) -> Bool? {
        guard x >= 0, y >= 0, y < landscape.count && x < landscape[y].count else { return nil }
        return positionValue < landscape[y][x]
    }
}
