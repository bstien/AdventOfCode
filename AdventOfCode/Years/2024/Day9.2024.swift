import Foundation

extension Year2024.Day9: Runnable {
    func run(input: String) {
        let disk = parseDisk(input)
        part1(disk: disk)
        part2(disk: disk)
    }

    private func part1(disk: [Block]) {
        var disk = disk
        var leftCounter = disk.firstIndex(where: \.isFreeSpace)!
        var rightCounter = disk.lastIndex(where: \.isFile)!

        repeat {
            guard
                case .freeSpace(let spaceSize) = disk[leftCounter],
                case .file(let fileId, let fileSize) = disk[rightCounter]
            else { fatalError() }

            let mergedSpace = spaceSize - fileSize

            if mergedSpace == 0 {
                disk.swapAt(leftCounter, rightCounter)

                leftCounter += 2
                rightCounter -= 2
            } else if mergedSpace < 0 {
                disk[rightCounter] = .file(id: fileId, size: fileSize - spaceSize)
                disk.append(.freeSpace(size: spaceSize))
                disk[leftCounter] = .file(id: fileId, size: spaceSize)

                leftCounter += 2
            } else {
                disk[rightCounter] = .freeSpace(size: fileSize)
                disk.insert(.freeSpace(size: mergedSpace), at: leftCounter + 1)
                disk[leftCounter] = .file(id: fileId, size: fileSize)

                leftCounter += 1
                rightCounter -= 1
            }
        } while leftCounter < rightCounter

        printResult(dayPart: 1, message: "Checksum: \(disk.checksum)")
    }

    private func part2(disk: [Block]) {
        var disk = disk
        let files = disk.filter { $0.isFile }

        for file in files.reversed() {
            guard
                let freeSpace = disk.firstIndex(where: { $0.isFreeSpace && $0.size >= file.size }),
                let fileIndex = disk.firstIndex(where: { $0.fileId == file.fileId }),
                freeSpace < fileIndex
            else {
                continue
            }
            let freeSpaceBlock = disk[freeSpace]
            let extraSpace = freeSpaceBlock.size - file.size

            if extraSpace > 0 {
                disk[fileIndex] = .freeSpace(size: file.size)
                disk[freeSpace] = file
                disk.insert(.freeSpace(size: extraSpace), at: freeSpace + 1)
            } else {
                disk.swapAt(freeSpace, fileIndex)
            }
        }

        printResult(dayPart: 2, message: "Checksum: \(disk.checksum)")
    }

    private func parseDisk(_ input: String) -> [Block] {
        let values = input.compactMap { Int(String($0)) }

        return values.enumerated().map { index, size in
            if index.isMultiple(of: 2) {
                return .file(id: index / 2, size: size)
            }
            return .freeSpace(size: size)
        }
    }
}

private enum Block {
    case file(id: Int, size: Int)
    case freeSpace(size: Int)

    var size: Int {
        switch self {
        case .file(_, let size): return size
        case .freeSpace(let size): return size
        }
    }

    var fileId: Int? {
        switch self {
        case .file(let fileId, _): return fileId
        case .freeSpace: return nil
        }
    }

    var isFreeSpace: Bool {
        switch self {
        case .file: return false
        case .freeSpace: return true
        }
    }

    var isFile: Bool {
        switch self {
        case .file: return true
        case .freeSpace: return false
        }
    }
}

extension [Block] {
    var checksum: Int {
        var checksum = 0
        var fileId = 0

        for block in enumerated() {
            switch block.element {
            case .file(let id, let size):
                checksum += (fileId ..< (fileId + size)).map { $0 * id }.reduce(0, +)
            case .freeSpace:
                break
            }
            fileId += block.element.size
        }

        return checksum
    }

    var debugString: String {
        reduce("") { result, block in
            switch block {
            case .file(let id, let size):
                result + (0..<size).map { _ in "\(id)" }.joined()
            case .freeSpace(let size) where size > 0:
                result + (0..<size).map { _ in "." }.joined()
            default:
                result
            }
        }
    }
}
