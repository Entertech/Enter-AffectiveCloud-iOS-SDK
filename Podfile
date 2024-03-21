source 'https://cdn.cocoapods.org/'

use_frameworks!
platform :ios, '13.0'

def common
  pod 'RxSwift'
  pod 'SmartCodable'
  pod 'Starscream', '~> 3.0'
  pod 'GzipSwift'
end

def ui
  pod 'SnapKit'
  pod 'DGCharts', :git => "git@github.com:ET-LINK/Charts.git", :branch => 'enter/round_corner_bar'
  pod 'FluentDarkModeKit'
end

target 'EnterAffectiveCloud' do

  common
  pod 'Moya/RxSwift'
  pod 'PromiseKit', '~> 8.0'
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
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
