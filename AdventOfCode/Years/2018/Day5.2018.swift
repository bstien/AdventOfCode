import Foundation

extension Year2018.Day5: Runnable {
    func run(input: String) {
        let polymer = splitInput(input).flatMap(Array.init)
        part1(polymer: polymer)
    }

    private func part1(polymer: [Character]) {
        var polymer = polymer
        var madeChange = false

        repeat {
            madeChange = false
            for index in (0..<polymer.count - 1) {
                guard let nextChar = polymer.getNext(index) else { break }
                if polymer[index].willReact(nextChar) {
                    polymer.remove(at: index + 1)
                    polymer.remove(at: index)
                    madeChange = true
                }
            }
        } while madeChange == true

        printResult(dayPart: 1, message: "Polymer lenght: \(polymer.count)")
    }
}

private extension Character {
    func willReact(_ other: Character) -> Bool {
        self.lowercased() == other.lowercased() &&
        self.isLowercase != other.isLowercase
    }
}

private extension [Character] {
    func getNext(_ index: Int) -> Character? {
        indices.contains(index + 1) ? self[index + 1] : nil
    }
}
