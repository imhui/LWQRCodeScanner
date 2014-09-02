Pod::Spec.new do |s|

  s.name         = "LWQRCodeScanner"
  s.version      = "0.1"
  s.summary      = "Objective-C QR Code Scanner for iOS7"
  s.homepage     = "https://github.com/imhui/LWQRCodeScanner"
  s.license      = "MIT"
  s.author       = { "imhui" => "seasonlyh@gmail" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/imhui/LWQRCodeScanner.git", :tag => "0.1" }
  s.source_files  = "LWQRCodeScanner/Scanner/*.{h,m}"
  s.resource  = "LWQRCodeScanner/Scanner/LWQRCodeScanner.bundle"
  s.requires_arc = true

end
