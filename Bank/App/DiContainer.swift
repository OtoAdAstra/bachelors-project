import Foundation

@Observable
final class DiContainer {
    let authRepository: AuthRepository

    init() {
        self.authRepository = AuthRepositoryImpl()
    }
}
