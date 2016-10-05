Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.name = "FCLock"
  s.summary = "FCLock is a lightweight Auth0 login widget."
  s.requires_arc = true

  s.version = "0.3.0"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "Martin Walsh" => "martin.walsh@gmail.com" }

  s.homepage = "https://github.com/cocojoe/FCLock"

  s.source = { :git => "https://github.com/cocojoe/FCLock.git", :tag => "#{s.version}"}

  s.framework = "UIKit"
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'SwiftyJSON'

  s.source_files = "FCLock/**/*.{swift}"

  s.resources = "FCLock/**/*.{png,jpeg,jpg,storyboard,xib}"

end
