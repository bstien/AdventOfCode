import Foundation

private typealias Passport = [String: String]

extension Year2020.Day4: Runnable {
    private var requiredFields: [String] {
        [
            "byr",
            "iyr",
            "eyr",
            "hgt",
            "hcl",
            "ecl",
            "pid"
        ]
    }

    func run(input: String) {
        let lines = splitInput(input, omittingEmptySubsequences: false)
        let passports = readPassports(from: lines)

        part1(passports: passports)
        part2(passports: passports)
    }

    private func part1(passports: [Passport]) {

        let validPassports = passports.filter { passport in
            requiredFields.allSatisfy { requiredField in
                passport.keys.contains(requiredField)
            }
        }

        printResult(dayPart: 1, message: "Number of valid passports: \(validPassports.count)")
    }

    private func part2(passports: [Passport]) {
        let validPassports = passports.filter { passport in
            if !requiredFields.allSatisfy({ passport.keys.contains($0) }) {
                return false
            }

            return passport.allSatisfy { isValid(key: $0, value: $1) }
        }

        printResult(dayPart: 2, message: "Number of validated passports: \(validPassports.count)")
    }
}

// MARK: - Validation

extension Year2020.Day4 {
    private func isValid(key: String, value: String) -> Bool {
        switch key {
        case "byr":
            guard let birthYear = Int(value) else { return false }
            return (1920...2002).contains(birthYear)
        case "iyr":
            guard let issueYear = Int(value) else { return false }
            return (2010...2020).contains(issueYear)
        case "eyr":
            guard let expirationYear = Int(value) else { return false }
            return (2020...2030).contains(expirationYear)
        case "pid":
            return value.matches(regex: "\\d{9}")
        case "ecl":
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value)
        case "hgt":
            let measurement = value.suffix(2)
            guard
                ["cm", "in"].contains(measurement),
                    let height = Int(value.dropLast(2))
                else { return false }

            switch measurement {
            case "cm":
                return (150...193).contains(height)
            case "in":
                return (59...76).contains(height)
            default:
                return false
            }
        case "hcl":
            return value.matches(regex: "#[a-zA-Z0-9]{6}")
        default:
            return true
        }
    }
}

// MARK: - Parsing input

extension Year2020.Day4 {
    private func readPassports(from lines: [String]) -> [Passport] {
        var credentials = [Int: [String]]()
        var emptyLinesFound = 0

        for line in lines {
            if line.isEmpty {
                emptyLinesFound += 1
                continue
            }

            credentials[emptyLinesFound, default: []].append(line)
        }

        return credentials.compactMap { _, lines -> Passport in
            lines
                .joined(separator: " ")
                .split(separator: " ")
                .reduce(into: [String: String]()) {
                    let field = $1.split(separator: ":")

                    if let key = field.first, let value = field.last {
                        $0[String(key)] = String(value)
                    }
                }
        }
    }
}
