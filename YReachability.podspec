Pod::Spec.new do |s|
  s.name             = “YReachability”
  s.version          = "1.0.0"
  s.summary          = "A Reachability used on iOS."
  s.description      = <<-DESC
                       It is a Reachability used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/iosscholar123/YReachability.git"
  # s.screenshots      = ""
  s.license          = 'MIT'
  s.author           = { “颜青山” => "iosscholar@sina.cn” }
  s.source           = { :git => "https://github.com/iosscholar123/YReachability.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://github.com/iosscholar123/YReachability.git'

  s.platform     = :ios, ‘6.0’
  # s.ios.deployment_target = ‘6.0’
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = ‘YReachability/*’
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', ‘CFFoundation’

end