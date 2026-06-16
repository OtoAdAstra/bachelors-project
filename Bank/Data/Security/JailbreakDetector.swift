import Foundation
import MachO

final class JailbreakDetector: DeviceIntegrityChecking {

    var isDeviceCompromised: Bool {
        if isForcedForTesting { return true }

        #if targetEnvironment(simulator)
        return false
        #else
        return hasSuspiciousFiles()
            || canWriteOutsideSandbox()
            || hasSuspiciousSymlinks()
            || hasInjectedLibraries()
            || hasInjectedEnvironment()
        #endif
    }

    private var isForcedForTesting: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-simulateJailbreak")
        #else
        return false
        #endif
    }

    // MARK: - Signals

    private func hasSuspiciousFiles() -> Bool {
        let paths = [
            "/Applications/Cydia.app",
            "/Applications/Sileo.app",
            "/Applications/Zebra.app",
            "/private/var/lib/apt",
            "/private/var/lib/cydia",
            "/private/var/stash",
            "/usr/sbin/sshd",
            "/usr/bin/ssh",
            "/bin/bash",
            "/bin/sh",
            "/etc/apt",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/Library/MobileSubstrate/DynamicLibraries",
            "/usr/lib/libsubstitute.dylib",
            "/usr/lib/libhooker.dylib",
            "/var/jb"
        ]
        let fileManager = FileManager.default
        return paths.contains { fileManager.fileExists(atPath: $0) }
    }

    private func canWriteOutsideSandbox() -> Bool {
        let path = "/private/" + UUID().uuidString
        do {
            try "integrity-probe".write(toFile: path, atomically: true, encoding: .utf8)
            try? FileManager.default.removeItem(atPath: path)
            return true // a sandboxed app must NOT be able to write here
        } catch {
            return false
        }
    }

    private func hasSuspiciousSymlinks() -> Bool {
        let paths = ["/Applications", "/var/stash", "/Library/Ringtones"]
        let fileManager = FileManager.default
        return paths.contains { path in
            guard
                let attributes = try? fileManager.attributesOfItem(atPath: path),
                let type = attributes[.type] as? FileAttributeType
            else { return false }
            return type == .typeSymbolicLink
        }
    }

    private func hasInjectedLibraries() -> Bool {
        let suspicious = [
            "substrate", "substitute", "libhooker", "tweakinject",
            "sslkillswitch", "fridagadget", "cycript"
        ]
        for index in 0..<_dyld_image_count() {
            guard let namePointer = _dyld_get_image_name(index) else { continue }
            let name = String(cString: namePointer).lowercased()
            if suspicious.contains(where: name.contains) { return true }
        }
        return false
    }

    private func hasInjectedEnvironment() -> Bool {
        getenv("DYLD_INSERT_LIBRARIES") != nil
    }
}
