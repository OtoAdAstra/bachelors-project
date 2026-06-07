import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct BankApp: App {
    
    //MARK: - Singletones
    
    //MARK: - Init
    init() {
        FirebaseApp.configure()

        Auth.auth().createUser(
            withEmail: "test@gmail.com",
            password: "123456"
        ) { result, error in

            guard let uid = result?.user.uid else { return }

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData([
                    "name": "Oto",
                    "last name": "Sharvashidze",
                    "email": "test@gmail.com",
                    "pronaunciation": "mr"
                ])
        }
    }
    
    //MARK: - View
    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(.dark)
        }
    }
}
