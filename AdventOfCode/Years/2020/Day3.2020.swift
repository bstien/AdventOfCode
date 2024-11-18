import Foundation

extension Year2020.Day3: Runnable {
    func run(input: String) {
        let lines = splitInput(input).map(Array.init)
        let part1 = calculateSlopes(lines: lines, slopes: [(x: 3, y: 1)])
        printResult(dayPart: 1, message: "Number of trees hit: \(part1.first!)")

        let part2 = calculateSlopes(lines: lines, slopes: [
            (x: 1, y: 1),
            (x: 3, y: 1),
            (x: 5, y: 1),
            (x: 7, y: 1),
            (x: 1, y: 2)
        ])
        printResult(dayPart: 2, message: "Trees multiplied: \(part2.reduce(1, *))")
    }

    func calculateSlopes(lines: [[Character]], slopes: [(x: Int, y: Int)]) -> [Int] {
        let lineLength = lines[0].count
        var treesInSlopes = [Int]()

        for slope in slopes {
            var xPos = 0
            var treesCounted = 0
            for yPos in stride(from: 0, through: lines.count - 1, by: slope.y) {
                if lines[yPos][xPos % (lineLength)] == "#" {
                    treesCounted += 1
                }
                xPos += slope.x
            }
            treesInSlopes.append(treesCounted)
        }

        return treesInSlopes
    }
}
