import Foundation

extension Year2023.Day6: Runnable {
    func run(input: String) {
        let results = parseResults(input: input)
        part1(results: results)
    }

    private func part1(results: [RaceResult]) {
        let totalWins = results.map { result in
            var wins = 0
            for ms in (1...result.time) {
                if ms * (result.time - ms) > result.distance {
                    wins += 1
                }
            }
            return wins
        }

        printResult(dayPart: 1, message: "Total: \(totalWins.reduce(1, *))")
    }

    private func parseResults(input: String) -> [RaceResult] {
        let lines = splitInput(input)
        let components = lines.map { splitInput($0, separatedBy: " ") }

        return (1...(components[0].count - 1)).map {
            RaceResult(
                time: components[0][$0].toInt!,
                distance: components[1][$0].toInt!
            )
        }
    }
}

private struct RaceResult {
    let time: Int
    let distance: Int
}
