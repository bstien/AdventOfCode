import Foundation

extension Year2022.Day6: Runnable {
    func run(input: String) {
        let input = input.trimmingCharacters(in: .newlines)
        let packetStart = findPosition(input: input, windowSize: 4)
        let messageStart = findPosition(input: input, windowSize: 14)

        printResult(dayPart: 1, message: "Position of packet start: \(packetStart)")
        printResult(dayPart: 2, message: "Position of message start: \(messageStart)")
    }

    private func findPosition(input: String, windowSize: Int) -> Int {
        input
            .windows(ofCount: windowSize)
            .enumerated()
            .first { Set($0.element).count == windowSize }
            .map { $0.offset + windowSize }!
    }
}
