Pod::Spec.new do |s|
  s.name             = 'EnterAffectiveCloudUI'
  s.version          = '2.2.1'
  s.summary          = 'Entertech 情感云UI SDK'
  s.description      = <<-DESC
情感云 SDK关联的UI，可以实时显示注意力、专注度、放松度、愉悦度和压力值等情绪相关的一些数据，也可以显示最终报表。
                       DESC

  s.homepage         = 'https://github.com/EnterTech'
  s.author           = { 'Like' => 'ke.liful@gmail.com' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5'
  s.source_files = 'UI/EnterAffectiveCloudUI/**/*.swift'
  s.resources = "UI/EnterAffectiveCloudUI/**/*.{xcassets,gif}"
  s.dependency 'RxSwift'
  s.dependency 'SnapKit'
  s.dependency 'Charts', '~> 3.4.0'
  s.dependency 'EnterAffectiveCloud', '~> 2.2.1'
  s.dependency 'FluentDarkModeKit'
end
