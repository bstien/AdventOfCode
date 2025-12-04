import Foundation

extension Year2025.Day4: Runnable {
    func run(input: String) {
        let map = splitInput(input).map { Array($0).map(Position.parse(char:)) }

        let part1Sum = part1(map: map)
        printResult(dayPart: 1, message: "Accessible rolls of paper: \(part1Sum)")
    }

    private func part1(map: [[Position]]) -> Int {
        var accessibleRolls = 0

        for y in map.indices {
            for x in map[y].indices where map[y][x] == .paper {
                if canReach(x: x, y: y, map: map, maxPaper: 3) {
                    accessibleRolls += 1
                }
            }
        }

        return accessibleRolls
    }

    private func canReach(x: Int, y: Int, map: [[Position]], maxPaper: Int) -> Bool {
        var paperCount = 0

        for dy in -1...1 {
            for dx in -1...1 {
                if dy == 0, dx == 0 { continue }

                let nx = x + dx
                let ny = y + dy

                guard map.indices.contains(ny), map[ny].indices.contains(nx) else { continue }

                if map[ny][nx] == .paper {
                    paperCount += 1
                }

                if paperCount > maxPaper {
                    return false
                }
            }
        }

        return true
    }
}

extension Year2025.Day4 {
    enum Position {
        case paper
        case empty

        var symbol: String {
            switch self {
            case .paper: "@"
            case .empty: "."
            }
        }

        static func parse(char: Character) -> Self {
            switch char {
            case "@": return .paper
            case ".": return .empty
            default: fatalError("Unexpected character: \(char)")
            }
        }
    }
}
