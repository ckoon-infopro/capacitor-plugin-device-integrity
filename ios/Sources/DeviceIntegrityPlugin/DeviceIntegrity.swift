import Foundation

@objc public class IRoot: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
