[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5a17f7809bbf2800010a8074&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5a17f7809bbf2800010a8074/build/latest?branch=master)

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

#### Show Picker
After this step you can use the UI we created for you which look like this :
![](/assets/IMG_2498.PNG)

```swift
UnswashPhotoViewController.picker().present(in: self, quality: .regular) { image, url in
  DispatchQueue.main.async {
                
  }
}
```

#### Direct call to the API

```swift
Unswash.client.Photos.search(query: String, page: Int = 1, per_page: Int = 10, completion: @escaping ([Photo]) -> Void)

Unswash.client.Photos.get(page: Int = 1, per_page: Int = 10, order_by: Order = Order.latest, completion: @escaping ([Photo]) -> Void)
```


