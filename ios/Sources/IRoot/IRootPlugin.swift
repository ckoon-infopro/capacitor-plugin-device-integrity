import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(IRootPlugin)
public class IRootPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "IRootPlugin"
    public let jsName = "IRoot"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = IRoot()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func isRooted(_ call: CAPPluginCall) {
        call.resolve([
            "value": implementation.isRooted()
        ])
    }
}
