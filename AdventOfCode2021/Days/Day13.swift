import Foundation

struct Day13: Day {
    static func run(input: String) {
        let (points, folds) = parse(input: input)
        let part1 = fold(points: points, folds: [folds.first!])
        let part2 = fold(points: points, folds: folds)

        printResult(dayPart: 1, message: "Number of points after 1 fold: \(part1.count)")
        printPart2(points: part2)
    }

    private static func fold(points: [Point], folds: [Fold]) -> [Point] {
        var maxX = points.map(\.x).max()! + 1
        var maxY = points.map(\.y).max()! + 1

        var points = Set(points)
        folds.forEach { fold in
            switch fold {
            case .x(let x): maxX = x
            case .y(let y): maxY = y
            }

            let newPoints = points.map { point -> Point in
                if point.isOnOtherSideOfFold(x: maxX, y: maxY) {
                    switch fold {
                    case .x:
                        return Point(x: abs(point.x - (maxX * 2)), y: point.y)
                    case .y:
                        return Point(x: point.x, y: abs(point.y - (maxY * 2)))
                    }
                } else {
                    return point
                }
            }
            points = Set(newPoints)
        }

        return Array(points)
    }

    private static func printPart2(points: [Point]) {
        let maxX = points.map(\.x).max()! + 1
        let maxY = points.map(\.y).max()! + 1

        var grid = Array(repeating: Array(repeating: " ", count: maxX), count: maxY)
        points.forEach { grid[$0.y][$0.x] = "X" }

        let code = grid.map { $0.joined() }.joined(separator: "\n")
        printResult(dayPart: 2, message: "The code to enter:\n\n\(code)\n")
    }

        private static func parse(input: String) -> ([Point], [Fold]) {
        var points = [Point]()
        var folds = [Fold]()

        let lines = splitInput(input, omittingEmptySubsequences: false)
        var parseFolds = false

        lines.forEach { line in
            if line.isEmpty {
                parseFolds = true
                return
            }

            if parseFolds {
                let values = splitInput(splitInput(line, separator: " ").last!, separator: "=" )
                if values[0] == "x" {
                    folds.append(.x(Int(values[1])!))
                } else {
                    folds.append(.y(Int(values[1])!))
                }
            } else {
                let numbers = splitInput(line, separator: ",").compactMap { Int($0) }
                points.append(Point(x: numbers[0], y: numbers[1]))
            }
        }

        return (points, folds)
    }
}

private struct Point: Hashable {
    let x: Int
    let y: Int

    func isOnOtherSideOfFold(x: Int, y: Int) -> Bool {
        self.x > x || self.y > y
    }
}

private enum Fold {
    case x(Int)
    case y(Int)
}
