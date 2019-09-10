require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-check-notification-enable"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-check-notification-enable
                   DESC
  s.homepage     = "https://github.com/jigaryadav/react-native-check-notification-enable"
  s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Maurus Cuelenaere" => "mcuelenaere@gmail.com" }
  s.platforms    = { :ios => "9.0", :tvos => "10.0" }
  s.source       = { :git => "https://github.com/jigaryadav/react-native-check-notification-enable.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end

