# Unswash
#### LightWeight library for [Unsplash](https://unsplash.com) api

We provide a simple UI allowing to search and browse the free content of unsplash.

install: via cocoapods ->  pod 'Unswash'

## Usage: 

To use Unswash you need a developer account on [Unsplash](https://unsplash.com/developers).
To get your App Name and App ID you need to create an app on [Unsplash](https://unsplash.com/oauth/applications)

Once you have those informations you can start using Unswash.

#### Initialisation
``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Unswash.client.configure(clientId: "YOUR_APP_ID", clientName: "YOUR_APP_NAME")
        return true
}
```

After this step you can use the UI we created for you 


#### Show Picker
```swift
UnswashPhotoViewController.picker().present(in: self, quality: .regular) { image, url in
  DispatchQueue.main.async {
                
  }
}
```

