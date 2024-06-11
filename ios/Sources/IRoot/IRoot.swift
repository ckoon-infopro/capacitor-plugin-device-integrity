import Foundation

@objc public class IRoot: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }

    @objc public func isRooted() -> Bool {
        print('isRooted')
        return true
    }
}
