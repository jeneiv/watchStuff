workspace 'WatchApp.xcworkspace'
platform :ios, '10.0'

use_frameworks!

def common_pods_for_iPhone
    pod "PromiseKit", "~> 6.0"
end

target 'WatchAppSharedLogic' do
  project 'WatchAppSharedLogic/WatchAppSharedLogic.xcodeproj'

  common_pods_for_iPhone

  target 'WatchAppSharedLogicTests' do
    inherit! :search_paths
  end
end

target 'WatchApp' do
  project 'WatchApp.xcodeproj'

  common_pods_for_iPhone

  target 'WatchAppTests' do
    inherit! :search_paths
  end
end

#target 'WatchApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  #use_frameworks!

  # Pods for WatchApp

  #target 'WatchAppTests' do
    #inherit! :search_paths
    # Pods for testing
  #end

#end

#target 'WatchAppWatch' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  #use_frameworks!

  # Pods for WatchAppWatch

#end

#target 'WatchAppWatch Extension' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  #use_frameworks!

  # Pods for WatchAppWatch Extension

#end
