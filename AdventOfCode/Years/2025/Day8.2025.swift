import Foundation

extension Year2025.Day8: Runnable {
    func run(input: String, isTest: Bool) {
        let coordinates = splitInput(input).map(Coordinate.parse(_:))
        let distances = findDistances(coordinates).sorted(by: { $0.distance < $1.distance })

        let part1Sum = part1(distances: Array(distances.prefix(isTest ? 10 : 1000)))
        printResult(dayPart: 1, message: "Sum: \(part1Sum)")

        let part2Sum = part2(distances: distances, coordinates: coordinates)
        printResult(dayPart: 2, message: "Sum: \(part2Sum)")
    }

    private func part1(distances: [Distance]) -> Int {
        var circuits = [Set<Coordinate>]()

        for distance in distances {
            let aIndex = circuits.firstCircuitIndex(with: distance.a)
            let bIndex = circuits.firstCircuitIndex(with: distance.b)

            switch (aIndex, bIndex) {
            case (let aIndex?, let bIndex?):
                if aIndex == bIndex { continue }
                circuits[aIndex].formUnion(circuits[bIndex])
                circuits.remove(at: bIndex)
            case (let aIndex?, .none):
                circuits[aIndex].insert(distance.b)
            case (.none, let bIndex?):
                circuits[bIndex].insert(distance.a)
            case (.none, .none):
                circuits.append([distance.a, distance.b])
            }
        }

        return circuits.map(\.count).sorted().suffix(3).reduce(1, *)
    }

    private func part2(distances: [Distance], coordinates: [Coordinate]) -> Int {
        var circuits = [Set<Coordinate>]()

        for distance in distances {
            let aIndex = circuits.firstCircuitIndex(with: distance.a)
            let bIndex = circuits.firstCircuitIndex(with: distance.b)

            switch (aIndex, bIndex) {
            case (let aIndex?, let bIndex?):
                if aIndex == bIndex { continue }
                circuits[aIndex].formUnion(circuits[bIndex])
                circuits.remove(at: bIndex)
            case (let aIndex?, .none):
                circuits[aIndex].insert(distance.b)
            case (.none, let bIndex?):
                circuits[bIndex].insert(distance.a)
            case (.none, .none):
                circuits.append([distance.a, distance.b])
            }

            if circuits.count == 1, circuits[0].count == coordinates.count {
                return distance.a.x * distance.b.x
            }
        }

        fatalError("Could not find the magic circuit")
    }

    // MARK: - Helpers

    private func findDistances(_ coordinates: [Coordinate]) -> [Distance] {
        var distances = [Distance]()
        var calculatedCoordinates = Set<Coordinate>()

        for coordinate in coordinates {
            for otherCoordinate in coordinates {
                if coordinate == otherCoordinate || calculatedCoordinates.contains(otherCoordinate) { continue }
                let distance = Distance(a: coordinate, b: otherCoordinate, distance: coordinate.distance(to: otherCoordinate))
                distances.append(distance)
            }

            calculatedCoordinates.insert(coordinate)
        }

        return distances
    }
}

extension [Set<Year2025.Day8.Coordinate>] {
    func firstCircuitIndex(with coordinate: Year2025.Day8.Coordinate) -> Int? {
        firstIndex(where: { $0.contains(coordinate) })
    }
}

extension Year2025.Day8 {
    struct Distance: Hashable {
        let a: Coordinate
        let b: Coordinate
        let distance: Double
    }

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
        let z: Int

        static func parse(_ string: String) -> Coordinate {
            let parts = string.split(separatedBy: ",").compactMap(Int.init)
            guard parts.count == 3 else {
                fatalError()
            }
            return Coordinate(x: parts[0], y: parts[1], z: parts[2])
        }

        func distance(to other: Coordinate) -> Double {
            let dx = Double(other.x - x)
            let dy = Double(other.y - y)
            let dz = Double(other.z - z)
            return (dx*dx + dy*dy + dz*dz).squareRoot()
        }
    }
}
