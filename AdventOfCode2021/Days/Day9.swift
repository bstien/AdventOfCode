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
                    landscape.get(x: x + 1, y: y).map { positionValue < $0 } ?? false,
                    landscape.get(x: x - 1, y: y).map { positionValue < $0 } ?? false,
                    landscape.get(x: x, y: y + 1).map { positionValue < $0 } ?? false,
                    landscape.get(x: x, y: y - 1).map { positionValue < $0 } ?? false
                ].compactMap { $0 }.allSatisfy { $0 }

                if isSmaller { lowPoints.append(positionValue) }
            }
        }

        let sum = lowPoints.map { $0 + 1 }.reduce(0, +)
        printResult(dayPart: 1, message: "Sum of all low positions: \(sum)")
    }

    private static func part2(landscape: [[Int]]) {
        var basins = [Int?]()
        var checkedPositions = Set<CheckedPosition>()

        func findBasin(x: Int, y: Int) -> Int? {
            let checkedPosition = CheckedPosition(x: x, y: y)
            guard
                !checkedPositions.contains(checkedPosition),
                let positionValue = landscape.get(x: x, y: y),
                positionValue != 9
            else { return nil }

            checkedPositions.insert(checkedPosition)

            return 1 + [
                findBasin(x: x - 1, y: y),
                findBasin(x: x + 1, y: y),
                findBasin(x: x, y: y - 1),
                findBasin(x: x, y: y + 1)
            ].compactMap { $0 }.reduce(0, +)
        }

        for y in (0..<landscape.count) {
            for x in (0..<landscape[y].count) {
                basins.append(findBasin(x: x, y: y))
            }
        }

        let topThreeBasinsMultiplied = basins.compactMap { $0 }.sorted(by: { $0 >= $1 }).prefix(3).reduce(1, *)
        printResult(dayPart: 2, message: "Product of top 3 largest basins: \(topThreeBasinsMultiplied)")
    }
}

// MARK: - Private types / extensions

private struct CheckedPosition: Hashable {
    let x: Int
    let y: Int
}

private extension Array where Element == [Int] {
    func get(x: Int, y: Int) -> Int? {
        guard y >= 0, y < count, x >= 0, x < self[y].count else { return nil }
        return self[y][x]
    }
}
