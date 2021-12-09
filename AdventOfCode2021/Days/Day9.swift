import Foundation

struct Day9: Day {
    static func run(input: String) {
        let landscape = splitInput(input).map { $0.map { Int(String($0))! } }
        part1(landscape: landscape)
        part2(landscape: landscape)
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

    private static func part2(landscape: [[Int]]) {
        var checkedPositions = Set<CheckedPosition>()

        func getPosition(x: Int, y: Int) -> Int? {
            guard y >= 0, y < landscape.count, x >= 0, x < landscape[y].count else { return nil }
            return landscape[y][x]
        }

        func findBasin(x: Int, y: Int) -> Int? {
            guard
                !checkedPositions.contains(x: x, y: y),
                let positionValue = getPosition(x: x, y: y),
                positionValue != 9
            else { return nil }

            checkedPositions.insert(CheckedPosition(x: x, y: y))

            return 1 + [
                findBasin(x: x - 1, y: y),
                findBasin(x: x + 1, y: y),
                findBasin(x: x, y: y - 1),
                findBasin(x: x, y: y + 1)
            ].compactMap { $0 }.reduce(0, +)
        }

        var basins = [Int]()
        for y in (0..<landscape.count) {
            for x in (0..<landscape[y].count) {
                guard
                    !checkedPositions.contains(x: x, y: y),
                    landscape[y][x] != 9,
                    let basin = findBasin(x: x, y: y)
                else { continue }

                basins.append(basin)
            }
        }

        let topThreeBasinsMultiplied = basins.sorted(by: { $0 >= $1 }).prefix(3).reduce(1, *)
        printResult(dayPart: 2, message: "Product of top 3 largest basins: \(topThreeBasinsMultiplied)")
    }

    private static func checkIfHigherAndExists(positionValue: Int, x: Int, y: Int, landscape: [[Int]]) -> Bool? {
        guard x >= 0, y >= 0, y < landscape.count && x < landscape[y].count else { return nil }
        return positionValue < landscape[y][x]
    }
}

// MARK: - Private types / extensions

private struct CheckedPosition: Hashable {
    let x: Int
    let y: Int
}

private extension Set where Element == CheckedPosition {
    func contains(x: Int, y: Int) -> Bool {
        self.contains(CheckedPosition(x: x, y: y))
    }
}
