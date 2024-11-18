import Foundation

extension Year2023.Day6: Runnable {
    func run(input: String) {
        let results = parseResults(input: input)
        part1(results: results)
        part2(results: results)
    }

    private func part1(results: [RaceResult]) {
        let totalWins = results
            .map { checkWins(time: $0.time, distance: $0.distance) }
            .reduce(1, *)

        printResult(dayPart: 1, message: "Total wins: \(totalWins)")
    }

    private func part2(results: [RaceResult]) {
        guard
            let time = results.map(\.time).map(String.init).joined().toInt,
            let distance = results.map(\.distance).map(String.init).joined().toInt
        else {
            fatalError()
        }

        let totalWins = checkWins(time: time, distance: distance)
        printResult(dayPart: 2, message: "Total wins: \(totalWins)")
    }

    private func checkWins(time: Int, distance: Int) -> Int {
        (1...time).filter { $0 * (time - $0) > distance }.count
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
