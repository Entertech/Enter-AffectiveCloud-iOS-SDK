Pod::Spec.new do |s|
  s.name             = 'EnterAffectiveCloud'
  s.version          = '2.2.1'
  s.summary          = 'Entertech 情感云 SDK'
  s.description      = <<-DESC
情感云 SDK，可以根据上传的脑波和心率分析你的注意力、专注度、放松度、愉悦度和压力值等情绪相关的一些数据。
                       DESC

  s.homepage         = 'https://github.com/EnterTech'
  s.author           = { 'Like' => 'ke.liful@gmail.com' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'EnterAffectiveCloud/**/*.swift'
  s.dependency 'HandyJSON'
  s.dependency 'Starscream', '~> 3.1.1'
  s.dependency 'GzipSwift'
  s.dependency 'SwiftyJSON'
  s.dependency 'Moya/RxSwift'
  s.dependency 'RxSwift'
end
