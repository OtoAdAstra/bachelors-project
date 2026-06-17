
<div>
  <img src="https://img.shields.io/badge/iOS-26.0%2B-blue" />
  <img src="https://img.shields.io/badge/Swift-6.1%2B-orange" />
  <img src="https://img.shields.io/badge/Xcode-26%2B-007ACC" />
  <img src="https://img.shields.io/badge/UIKit%20%2B%20SwiftUI-purple" />
  <img src="https://img.shields.io/badge/CLEAN%20Architecture-white" />
  <img src="https://img.shields.io/badge/MVVM%20+%20Di%20Container-success" />
  <img src="https://img.shields.io/badge/Async%2FAwait-red" />

</div>



# SecureBank

## პროექტის შესახებ 

SecureBank არის საბანკო აპლიკაცია, რომელიც იყენებს ყველა უსაფრთხოების ზომას, რაც შეიძლება FinTech აპლიკაციას დასჭირდეს. მოცემული პროექტი იქნება ჩონჩხი და გზამკვლები iOS დეველოპერებისთვის, რათა უკეთ გაიგონ და გამოიყენონ პროექტში მოცემული ტექნიკები. პროექტის მიზანია მაქსიმალურად გაუმარტივოს დეველოპერებს უსაფრთხოების ნორმების მიღება iOS აპლიკაციის მხრიდან.

## სამიზნე აუდიტორია

- FinTech კომპანიები, რომლებსაც სურთ მაქსიმალური უსაფრთხოების ზომის მიღება iOS-ის მხრიდან
- სტარტაპები, რომლებსაც სჭირდებათ ფრეიმვორკი, რომელზეც ააწყობენ თავიანთ აპლიკაციას
- iOS დეველოპერები, რომლებსაც სურთ უსაფრთხოების ზომების და ოპტიმალური პრაქტიკების მარტივად ათვისება

## უსაფრთხოების ტექნიკები

- **Jailbreak Detector** - არ აძლევს jailbroken დევაისებს აპლიკაციაზე წვდომას
- **Keychain Service** - სენსიტიური მონაცემების დაშიფრულად შენახვა
- **Local Authentication** - მომხმარებლის ხელახალი ავთენტიფიკაცია Face ID-ის გამოყენებით
- **Screen Privacy** - ეკრანზე ნაჩვენები სენსიტიური ინფორმაციის დაცვა
- **Auto Lock** - არააქტიურ რეჟიმში ყოფნის შემდეგ ბიომეტრიული ავტენთიფიკაციის მოთხოვნა
- **Sensitive Data Masking** - ბალანსის ან ანგარიშის ნომრის დაფარვის საშუალება


## Screenshots

<p>
  <img src="./Screenshots/1.png" width="150" />
  <img src="./Screenshots/2.png" width="150" />
  <img src="./Screenshots/3.png" width="150" />
  <img src="./Screenshots/4.png" width="150" />
  <img src="./Screenshots/5.png" width="150" />
</p>

<p>
  <img src="./Screenshots/6.png" width="150" />
  <img src="./Screenshots/7.png" width="150" />
  <img src="./Screenshots/8.png" width="150" />
  <img src="./Screenshots/9.png" width="150" />
  <img src="./Screenshots/10.png" width="150" />
</p>

<p>
  <img src="./Screenshots/11.png" width="150" />
  <img src="./Screenshots/14.png" width="150" />
  <img src="./Screenshots/13.png" width="150" />
  <img src="./Screenshots/12.png" width="150" />
</p>

## გამოყენებული ტექნოლოგიები

- **Swift** - პროგრამირების ენა
- **SwiftUI** - მთავარი UI ფრეიმვორკი
- **Foundation** - საბაზისო სისტემური ფინქციებისთვის
- **Keychain Services** - ინფორმაციის დაშიფრული საცავი
- **LocalAuthentication Framework** - ბიომეტრიული ავტენტიფიკაცია
- **UIScreen API** - ეკრანის მდგომარეობის დასადგენად
- **Firebase** - Backend სერვისი
- **Xcode** - ძირითადი IDE

## არქიტექტურა 

- **Clean Architecture** - პროექტის არქიტექტურა, რომელიც ყოფს აპლიკაციას Presentation, Domain და Data ლეიერებად
- **MVVM** - Presentation layer-ში გამოყენებული პატერნი, სადაც ViewModel აკავშირებს View-ს use case-ებთან.
- **Dependency Injection** - გამოიყენება service/use case/view model-ის ერთმანეთთან დამოკიდებულებისთვის და ტესტირებადობის გასაუმჯობესებლად

## მოთხოვნა

- **Deployment Target** - iOS 26+
- **Xcode Version** - 26+
- **Device** - iOS only
- **Internet Connection** - Required 

## ინსტალაცია

1. Clone the repository
2. Open the project in Xcode
3. Build and run (⌘ + R)


#### Jailbreak - ის გასატესტად:

Product > Scheme > Edit Scheme > Arguments > Arguments passed on launch > + > "-simulateJailbreak" > Build and run (⌘ + R)

## ავტორი

Oto Sharvashidze

