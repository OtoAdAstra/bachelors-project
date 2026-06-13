import Foundation

protocol CheckDeviceIntegrityUseCase {
    /// `true` if the app should refuse to run (device looks compromised).
    func execute() -> Bool
}

final class DefaultCheckDeviceIntegrityUseCase: CheckDeviceIntegrityUseCase {
    private let detector: DeviceIntegrityChecking

    init(detector: DeviceIntegrityChecking) {
        self.detector = detector
    }

    func execute() -> Bool {
        detector.isDeviceCompromised
    }
}
