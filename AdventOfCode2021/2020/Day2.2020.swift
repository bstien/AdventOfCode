import Foundation

extension Year2020.Day2: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        part1(lines: lines)
        part2(lines: lines)
    }

    private func part1(lines: [String]) {
        let validPasswords = lines.filter {
            let components = $0.split(whereSeparator: { [" ", "-", ":"].contains($0) })

            guard
                let charCountFrom = Int(components[0]),
                    let charCountTo = Int(components[1])
                else {
                return false
            }

            let charToValidate = Character(String(components[2]))
            let password = components[3]

            let charCount = password.reduce(0, { result, string in
                result + (string == charToValidate ? 1 : 0)
            })

            return (charCountFrom...charCountTo).contains(charCount)
        }
        printResult(dayPart: 1, message: "Passwords matching criteria: \(validPasswords.count)")
    }

    private func part2(lines: [String]) {
        let validPasswords = lines.filter {
            let components = $0.split(whereSeparator: { [" ", "-", ":"].contains($0) })

            guard
                let firstCharPlacement = Int(components[0]),
                    let secondCharPlacement = Int(components[1]),
                    $0.count >= secondCharPlacement
                else {
                return false
            }

            let charToValidate = components[2]
            let password = String(components[3])

            let firstIndex = firstCharPlacement - 1
            let secondIndex = secondCharPlacement - 1
            if password[firstIndex] == charToValidate || password[secondIndex] == charToValidate {
                if password[firstIndex] != charToValidate || password[secondIndex] != charToValidate {
                    return true
                }
            }
            return false
        }

        printResult(dayPart: 2, message: "Passwords matching new criteria: \(validPasswords.count)")
    }
}
