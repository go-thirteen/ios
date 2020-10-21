platform :ios, '13.0'
inhibit_all_warnings!

target 'Thirteen' do
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      if target.name == "Pods-Thirteen"
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig.sub!('-framework "FirebaseAnalytics"', '')
        xcconfig.sub!('-framework "FIRAnalyticsConnector"', '')
        xcconfig.sub!('-framework "FirebasePerformance"', '')
        xcconfig.sub!('-framework "GoogleAppMeasurement"', '')
        xcconfig += 'OTHER_LDFLAGS[sdk=iphone*] = $(OTHER_LDFLAGS) -framework "FirebaseAnalytics" -framework "FIRAnalyticsConnector" -framework "FirebasePerformance" -framework "GoogleAppMeasurement"'
        xcconfig += "\n"
        xcconfig += 'OTHER_LDFLAGS[sdk=*simulator] = $(OTHER_LDFLAGS) -framework "FirebaseAnalytics" -framework "FIRAnalyticsConnector" -framework "FirebasePerformance" -framework "GoogleAppMeasurement"'
        File.open(xcconfig_path, "w") { |file| file << xcconfig }
      end
    end
  end
end
