source 'https://cdn.cocoapods.org/'

use_frameworks!
platform :ios, '13.0'

def common
  pod 'RxSwift'
  pod 'HandyJSON', '~> 5.0.4-beta'
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
