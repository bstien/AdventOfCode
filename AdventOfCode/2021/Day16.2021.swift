import Foundation

extension Year2021.Day16: Runnable {
    func run(input: String) {
        let binary = splitInput(input).first!.hexToBinary
        part1(binary: binary)
    }

    private func part1(binary: String) {
        var binary = binary.map { $0 }
        var initialPacket: Packet?

        repeat {
            let packet = Packet()
            if initialPacket == nil { initialPacket = packet }

            let version = String(binary[0...2]).binaryToInt
            binary.removeSubrange(0...2)

            let kind = PacketKind.from(String(binary[0...2]).binaryToInt)
            binary.removeSubrange(0...2)

            packet.version = version
            packet.kind = kind

            if case .literalValue = kind {

            }
        } while !binary.isEmpty
    }
}

// MARK: - Private types / extensions

private enum PacketKind {
    case literalValue
    case `operator`(value: Int)

    static func from(_ value: Int) -> PacketKind {
        if value == 4 {
            return .literalValue
        }
        return .operator(value: value)
    }
}

private class Packet {
    var version: Int? = nil
    var kind: PacketKind? = nil
    var subPackets: [Packet] = []
}

private extension String {
    var hexToBytes: [UInt8] {
        var start = startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let end = index(after: start)
            defer { start = index(after: end) }
            return UInt8(self[start...end], radix: 16)
        }
    }

    var hexToBinary: String {
        hexToBytes.map {
            let binary = String($0, radix: 2)
            return repeatElement("0", count: 8-binary.count) + binary
        }.joined()
    }

    var binaryToInt: Int {
        Int(self, radix: 2)!
    }
}
