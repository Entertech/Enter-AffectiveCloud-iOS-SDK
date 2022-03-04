source 'https://cdn.cocoapods.org/'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

use_frameworks!
platform :ios, '11.0'

def common
  pod 'RxSwift'
  pod 'HandyJSON', '~> 5.0.4-beta'
  pod 'Starscream', '3.1.1'
  pod 'GzipSwift'
end

def ui
  pod 'SnapKit'
  pod 'Charts'
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
