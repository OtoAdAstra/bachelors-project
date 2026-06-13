import Foundation

/// Boundary for runtime device-integrity (jailbreak / tamper) checks.
protocol DeviceIntegrityChecking {
    /// `true` if the device shows signs of being jailbroken or tampered with.
    var isDeviceCompromised: Bool { get }
}
