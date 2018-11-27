
Pod::Spec.new do |s|

  s.name         = "ZHVolumeView"
  s.version      = "1.0.2"
  s.summary      = "ZHVolumeView ."

  s.description  = <<-DESC
			ZHVolumeView is a simple demo for volume adjustment
                   DESC
  s.homepage     = "https://github.com/ZuhanLin/ZHVolumeView"

  s.license      = "MIT"
  s.author       = { "linzuhan" => "767678362@qq.com" }
  s.platform     = :ios, "7.0"


  s.source        = { :git => "https://github.com/ZuhanLin/ZHVolumeView.git", :tag => "#{s.version}" }
  s.source_files  = "ZHVolumeViewDemo/ZHVolumeView/*.{h,m}"


  s.frameworks = "MediaPlayer", "Foundation", "UIKit", "AVFoundation"
  s.requires_arc = true

end
