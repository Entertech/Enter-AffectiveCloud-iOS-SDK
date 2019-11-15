Pod::Spec.new do |s|
  s.name             = 'EnterAffectiveCloudUI'
  s.version          = '1.2.4'
  s.summary          = 'Entertech 情感云UI SDK'
  s.description      = <<-DESC
情感云 SDK关联的UI，可以实时显示注意力、专注度、放松度、愉悦度和压力值等情绪相关的一些数据，也可以显示最终报表。
                       DESC

  s.homepage         = 'https://github.com/EnterTech'
  s.author           = { 'Like' => 'ke.liful@gmail.com' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'
  s.source_files = 'EnterAffectiveCloudUI/**/*.swift'
  s.resources = "EnterAffectiveCloudUI/**/*.{xcassets,gif}"
  s.dependency 'RxSwift', '5.0'
  s.dependency 'SnapKit'
  s.dependency 'Charts'
  s.dependency 'EnterAffectiveCloud', '1.2.4'
end
