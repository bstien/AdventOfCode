import Foundation

struct Day11: Day {
    static func run(input: String) {
        let octopi = splitInput(input).map { $0.map { Int(String($0))! } }
        let part1 = run(steps: 100, octopi: octopi)
        let part2 = run(steps: nil, octopi: octopi)

        printResult(dayPart: 1, message: "# flashes after 100 steps: \(part1.flashes)")

        if let allFlashStep = part2.allFlashStep {
            printResult(dayPart: 2, message: "Step where all octopi flash: \(allFlashStep)")
        } else {
            printResult(result: .fail, dayPart: 2, message: "Didn't find a step where all flash 😖")
        }
    }

    private static func run(steps: Int?, octopi: [[Int]]) -> (flashes: Int, allFlashStep: Int?) {
        var octopi = octopi
        var numberOfFlashes = 0
        let numberOfOctopi = octopi.map({ $0.count }).reduce(0, +)

        for step in 1...(steps ?? Int.max) {
            var flashedPositions = Set<FlashPosition>()
            for y in (0..<octopi.count) {
                for x in (0..<octopi[y].count) {
                    flash(x: x, y: y, octopi: &octopi, flashedPositions: &flashedPositions)
                }
            }

            numberOfFlashes += flashedPositions.count
            flashedPositions.forEach { octopi[$0.y][$0.x] = 0 }

            if flashedPositions.count == numberOfOctopi {
                return (flashes: numberOfFlashes, allFlashStep: step)
            }
        }

        return (flashes: numberOfFlashes, allFlashStep: nil)
    }

    private static func flash(x: Int, y: Int, octopi: inout [[Int]], flashedPositions: inout Set<FlashPosition>) {
        guard y >= 0, y < octopi.count, x >= 0, x < octopi[y].count else { return }

        let position = FlashPosition(x: x, y: y)

        if octopi[y][x] >= 9, !flashedPositions.contains(position) {
            flashedPositions.insert(position)
            flash(x: x, y: y - 1, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x + 1, y: y - 1, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x + 1, y: y, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x + 1, y: y + 1, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x, y: y + 1, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x - 1, y: y + 1, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x - 1, y: y, octopi: &octopi, flashedPositions: &flashedPositions)
            flash(x: x - 1, y: y - 1, octopi: &octopi, flashedPositions: &flashedPositions)
        } else {
            octopi[y][x] += 1
        }
    }
}

// MARK: - Private types

private struct FlashPosition: Hashable {
    let x: Int
    let y: Int
}
