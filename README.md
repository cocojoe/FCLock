# FCLock

Lightweight Auth0 login widget.  Swift 3.0

## Getting Started

### Cocoapods
Using [CocoaPods](https://cocoapods.org/) for installation.
YOU WILL NEED CocoaPods 1.1.0+ , Xcode 8

Your `podfile` should look like this:

```
#important that this is 10.0 for alamofire
platform :ios, '10.0'

target '<YOUR PROJECT>' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Access directly
  pod 'FCLock', :path => 'https://github.com/cocojoe/FCLock.git'
end
```

### Carthage
Using [Carthage](https://github.com/Carthage/Carthage) for installation.

```
carthage update --platform iOS
```

## Setup

You will need an active [Auth0][https://auth0.com/] account, please add your credentials to your *Info.plist*:

```
<key>Auth0ClientId</key>
<string>YOUR CLIENT ID</string>
<key>Auth0Domain</key>
<string>YOUR DOMAIN</string>
```

## How to use it

Import the framework to get started.

```
import FCLock
```

### Presenting
A simple example of presenting the login widget.

```
override func viewDidAppear(_ animated: Bool) {
  FCLockManager.sharedInstance.presentLogin(fromController: self)
}
```

### Authentication callback
Most likely you want to do something upon successful authentication, you can add an authentication handler.

```
FCLockManager.sharedInstance.onAuthentication = { [weak self] in
  print("User authenticated!")
  self?.view.backgroundColor = UIColor.green
}
```

### Themes
If you don't like the awesome default red theme, you can change it, I've provided a couple of themes. 

```
FCLockManager.sharedInstance.applySkin(skin: FCLockConstants.ThemeLight)
```

You can also roll your own

```
let myAwesomeTheme = FCLockSkin(backgroundColor: UIColor(red:0.84, green:0.14, blue:0.14, alpha:1.0),
                                     boxColor: UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0),
                                     inputTextColor: UIColor(red:0.23, green:0.28, blue:0.31, alpha:1.0),
                                     buttonColor: UIColor(red:0.84, green:0.14, blue:0.14, alpha:1.0),
                                     buttonTextColor: UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0))
```

Have fun...

## Built For

* Xcode 8, Swift 3.0, iOS 10

## Contributing

Please feel free to look at any issues and create a pull request or just contribute something awesome :]

## Authors

* **Martin Walsh** - [cocojoe](https://github.com/cocojoe/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [Auth0](https://auth0.com/)
* [Alamofire](https://github.com/Alamofire/Alamofire)
