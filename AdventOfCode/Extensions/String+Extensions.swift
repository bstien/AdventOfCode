import Foundation

extension String {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }

    func matches(regex: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return false }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
