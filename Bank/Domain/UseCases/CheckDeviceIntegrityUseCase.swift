import Foundation

protocol CheckDeviceIntegrityUseCase {
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
