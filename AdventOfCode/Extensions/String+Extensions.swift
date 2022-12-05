import Foundation

extension StringProtocol {
    func characterAt(_ offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension String {
    subscript(offset: Int) -> String {
        String(characterAt(offset))
    }

    func matches(regex: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return false }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
