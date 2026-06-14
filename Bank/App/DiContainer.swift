import Foundation

@Observable
final class DiContainer {

    private let authRepository: AuthRepository
    private let sessionStorage: SessionStorage
    private let biometricAuthenticator: BiometricAuthenticator
    private let profileRepository: ProfileRepository
    private let accountRepository: AccountRepository
    private let deviceIntegrityChecker: DeviceIntegrityChecking

    private let signInUseCase: SignInUseCase
    private let signUpUseCase: SignUpUseCase
    private let signOutUseCase: SignOutUseCase
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    private let biometricAuthUseCase: AuthenticateWithBiometricsUseCase
    let restoreSessionUseCase: RestoreSessionUseCase
    let checkDeviceIntegrityUseCase: CheckDeviceIntegrityUseCase

    private let loadProfileUseCase: LoadProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let observeBalanceUseCase: ObserveBalanceUseCase
    private let observeTransactionsUseCase: ObserveTransactionsUseCase
    private let transferMoneyUseCase: TransferMoneyUseCase

    init() {
        self.authRepository = FirebaseAuthRepository()
        self.sessionStorage = KeychainSessionStorage()
        self.biometricAuthenticator = BiometricService()
        self.profileRepository = FirestoreProfileRepository()
        self.accountRepository = FirestoreAccountRepository()
        self.deviceIntegrityChecker = JailbreakDetector()

        self.biometricAuthUseCase = DefaultAuthenticateWithBiometricsUseCase(
            authenticator: biometricAuthenticator
        )
        self.signInUseCase = DefaultSignInUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage
        )
        self.signUpUseCase = DefaultSignUpUseCase(
            authRepository: authRepository,
            profileRepository: profileRepository,
            sessionStorage: sessionStorage
        )
        self.signOutUseCase = DefaultSignOutUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage
        )
        self.observeAuthStateUseCase = DefaultObserveAuthStateUseCase(
            authRepository: authRepository
        )
        self.restoreSessionUseCase = DefaultRestoreSessionUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage,
            biometricAuth: biometricAuthUseCase
        )
        self.checkDeviceIntegrityUseCase = DefaultCheckDeviceIntegrityUseCase(
            detector: deviceIntegrityChecker
        )

        self.loadProfileUseCase = DefaultLoadProfileUseCase(profileRepository: profileRepository)
        self.updateProfileUseCase = DefaultUpdateProfileUseCase(profileRepository: profileRepository)
        self.observeBalanceUseCase = DefaultObserveBalanceUseCase(accountRepository: accountRepository)
        self.observeTransactionsUseCase = DefaultObserveTransactionsUseCase(accountRepository: accountRepository)
        self.transferMoneyUseCase = DefaultTransferMoneyUseCase(accountRepository: accountRepository)
    }

    @MainActor
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            observeAuthState: observeAuthStateUseCase,
            signOutUseCase: signOutUseCase,
            biometricAuth: biometricAuthUseCase
        )
    }

    @MainActor
    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(signInUseCase: signInUseCase)
    }

    @MainActor
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(signUpUseCase: signUpUseCase)
    }

    @MainActor
    func makeBalanceViewModel() -> BalanceViewModel {
        BalanceViewModel(
            loadProfileUseCase: loadProfileUseCase,
            observeBalanceUseCase: observeBalanceUseCase,
            observeTransactionsUseCase: observeTransactionsUseCase
        )
    }

    @MainActor
    func makeTransferViewModel() -> TransferViewModel {
        TransferViewModel(transferUseCase: transferMoneyUseCase)
    }

    @MainActor
    func makeAccountViewModel() -> AccountViewModel {
        AccountViewModel(
            loadProfileUseCase: loadProfileUseCase,
            updateProfileUseCase: updateProfileUseCase
        )
    }
}
