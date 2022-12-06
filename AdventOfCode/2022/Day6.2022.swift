import Foundation

extension Year2022.Day6: Runnable {
    func run(input: String) {
        let input = input.trimmingCharacters(in: .newlines)

        let packetStart = input.windows(ofCount: 4).enumerated().first { tuple in
            let dict = tuple.element.reduce(into: [Character: Int]()) { dictionary, character in
                dictionary[character, default: 0] += 1
            }

            return dict.values.allSatisfy { $0 == 1 }
        }.map { $0.offset + 4 }!

        printResult(dayPart: 1, message: "Position of packet start: \(packetStart)")
    }
}
