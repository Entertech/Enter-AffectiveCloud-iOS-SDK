source 'https://cdn.cocoapods.org/'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '12.0'

def common
  pod 'RxSwift'
  pod 'HandyJSON', '~> 5.0.4-beta'
  pod 'Starscream', '3.1.1'
  pod 'GzipSwift'
end

def ui
  pod 'SnapKit'
  pod 'DGCharts'
  pod 'FluentDarkModeKit'
end

target 'EnterAffectiveCloud' do

  common
  pod 'Moya/RxSwift'
  pod 'PromiseKit'
end

target 'EnterAffectiveCloudUI' do
  common
  ui
end

target 'EnterRealtimeUIDemo' do
  common
  ui
end

target 'EnterReportUIDemo' do
  common
  ui
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
