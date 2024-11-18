import Foundation

extension Year2023.Day11: Runnable {
    func run(input: String) {
        let universe = parse(input: input)
        part1(universe: universe)
        part2(universe: universe)
    }

    private func part1(universe: Universe) {
        let totalDistance = calculateDistances(universe: universe, emptyValue: 2)
        printResult(dayPart: 1, message: "Total distance: \(totalDistance)")
    }

    private func part2(universe: Universe) {
        let totalDistance = calculateDistances(universe: universe, emptyValue: 1000000)
        printResult(dayPart: 2, message: "Total distance: \(totalDistance)")
    }

    private func calculateDistances(universe: Universe, emptyValue: Int) -> Int {
        var totalDistance = 0
        var galaxiesSeen = Set<Galaxy>()

        for this in universe.galaxies {
            galaxiesSeen.insert(this)

            for other in universe.galaxies {
                if this == other || galaxiesSeen.contains(other) == true { continue }

                let colRange = min(this.x, other.x)...max(this.x, other.x)
                let rowRange = min(this.y, other.y)...max(this.y, other.y)

                let extraCols = universe.emptyCols.reduce(0, { $0 + (colRange.contains($1) ? (emptyValue - 1) : 0) })
                let extraRows = universe.emptyRows.reduce(0, { $0 + (rowRange.contains($1) ? (emptyValue - 1) : 0) })

                let distanceX = max(this.x, other.x) - min(this.x, other.x)
                let distanceY = max(this.y, other.y) - min(this.y, other.y)

                totalDistance += distanceX + distanceY + extraRows + extraCols
            }
        }

        return totalDistance
    }

    private func parse(input: String) -> Universe {
        let universe = Universe()

        let lines = splitInput(input)

        lines.enumerated().forEach { y, line in
            let galaxies = line.enumerated().compactMap { x, char -> Galaxy? in
                guard char == "#" else { return nil }
                return Galaxy(y: y, x: x)
            }
            universe.galaxies.append(contentsOf: galaxies)
        }

        for y in 0..<lines.count {
            if universe.galaxies.contains(where: { $0.y == y }) { continue }
            universe.emptyRows.insert(y)
        }

        for x in 0..<lines[0].count {
            if universe.galaxies.contains(where: { $0.x == x }) { continue }
            universe.emptyCols.insert(x)
        }
        
        return universe
    }
}

private class Universe {
    var galaxies: [Galaxy]
    var emptyRows: Set<Int>
    var emptyCols: Set<Int>

    init() {
        galaxies = [Galaxy]()
        emptyRows = Set<Int>()
        emptyCols = Set<Int>()
    }
}

private struct Galaxy: Hashable {
    let y: Int
    let x: Int
}
