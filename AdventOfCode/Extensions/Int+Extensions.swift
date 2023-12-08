import Foundation

extension Int {
    /// https://en.wikipedia.org/wiki/Least_common_multiple
    static func lcd(_ a: Int, _ b: Int) -> Int {
        (a * b) / Int.gcd(a, b)
    }

    /// https://victorqi.gitbooks.io/swift-algorithm/content/greatest_common_divisor.html
    static func gcd(_ a: Int, _ b: Int) -> Int {
        let remainder = a % b
        
        if remainder != 0 {
            return gcd(b, remainder)
        } else {
            return b
        }
    }
}
