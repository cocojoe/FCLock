# FCLock

Lightweight Auth0 login widget

## Getting Started

I would recommend using [CocoaPods](https://cocoapods.org/) for installation.
YOU WILL NEED CocoaPods 1.1.0+

Your `podfile` should look similar to this:

```
platform :ios, '10.0'

target '<YOUR PROJECT>' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'FCLock', :path => '<PATH TO>/FCLock/'
end
```

## How to use it

It's really easy to use first

```
import FCLock
```

A simple example of displaying the login widget:

```
override func viewDidAppear(_ animated: Bool) {
  FCLockManager.sharedInstance.presentLogin(fromController: self)
}
```

## Built For

* Xcode 8, Swift 3.0, iOS 10

## Contributing

Please feel free to look at the issues for and create a pull request or contribute anything awesome :]

## Authors

* **Martin Walsh** - [cocojoe](https://github.com/cocojoe/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [Auth0](https://auth0.com/)
