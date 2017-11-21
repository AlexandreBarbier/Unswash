# Unswash
#### LightWeight library for [Unsplash](https://unsplash.com) api

We provide a simple UI allowing to search and browse the free content of unsplash.

install: via cocoapods ->  pod 'Unswash'

## Usage: 
#### Initialisation
``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Unswash.client.configure(clientId: "YOUR_APP_ID")
        return true
}
```

#### Show Picker
```swift
UnswashPhotoViewController.picker().present(in: self, quality: .regular) { image, url in
  DispatchQueue.main.async {
                
  }
}
```
