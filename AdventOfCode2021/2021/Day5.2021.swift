import Foundation

extension Year2021.Day5: Runnable {
    func run(input: String) {
        let pipes = splitInput(input).map(\.asPipe)
        part1(pipes: pipes)
        part2(pipes: pipes)
    }

    private func part1(pipes: [Pipe]) {
        let overlappingPipes = countOverlaps(pipes: pipes, includeDiagonals: false)
        printResult(dayPart: 1, message: "Overlapping pipes: \(overlappingPipes)")
    }

    private func part2(pipes: [Pipe]) {
        let overlappingPipes = countOverlaps(pipes: pipes, includeDiagonals: true)
        printResult(dayPart: 2, message: "Overlapping pipes w/ diagonals: \(overlappingPipes)")
    }

    private func countOverlaps(pipes: [Pipe], includeDiagonals: Bool) -> Int {
        var grid = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

        for pipe in pipes {
            if pipe.x1 == pipe.x2 {
                for y in stride(pipe.y1, pipe.y2) {
                    grid[y][pipe.x1] += 1
                }
            } else if pipe.y1 == pipe.y2 {
                for x in stride(pipe.x1, pipe.x2) {
                    grid[pipe.y1][x] += 1
                }
            } else if includeDiagonals {
                for (x, y) in zip(stride(pipe.x1, pipe.x2), stride(pipe.y1, pipe.y2)) {
                    grid[y][x] += 1
                }
            }
        }

        return grid.map { x in x.filter { $0 >= 2 } }.flatMap { $0 }.count
    }

    private func stride(_ from: Int, _ to: Int) -> StrideThrough<Int> {
        let increment = from <= to ? 1 : -1
        return Swift.stride(from: from, through: to, by: increment)
    }
}

// MARK: - Private types/extensions

private struct Pipe {
    let x1: Int
    let y1: Int
    let x2: Int
    let y2: Int
}

private extension String {
    var asPipe: Pipe {
        let numbers = components(separatedBy: " -> ")
            .map { $0.split(separator: ",") }
            .flatMap { $0 }
            .compactMap { Int($0) }
        return Pipe(x1: numbers[0], y1: numbers[1], x2: numbers[2], y2: numbers[3])
    }
}
