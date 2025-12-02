#
# Be sure to run `pod lib lint CreekSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'CreekSDK'
    s.version          = '12.0.6-yy'
    s.summary          = 'A short description of CreekSDK.'
    # This description is used to generate tags and improve search results.7777
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/creekwearable/CreekSDK'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'bean' => 'huy_1714@126.com' }
    s.source           = { :git => 'https://github.com/creekwearable/CreekSDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '13.0'
    s.platform              = :ios, "13.0"
    s.swift_versions = ['5.0']
    s.source_files = 'CreekSDK/Classes/**/*'
    
    s.vendored_frameworks = [
    'Creek/sbc.framework',
    'Creek/App.framework',
    'Creek/creek_blue_manage.framework',
    'Creek/flutter_blue_plus.framework',
    'Creek/Flutter.framework',
    'Creek/sqflite.framework',
    'Creek/permission_handler_apple.framework',
    'Creek/Protobuf.framework',
    'Creek/shared_preferences_foundation.framework',
    'Creek/FlutterPluginRegistrant.framework',
    'Creek/lz4.framework',
    'Creek/path_provider_foundation.framework',
    'Creek/creek_sleep_stage_algorithm.framework']
    s.pod_target_xcconfig = {'VALID_ARCHS' => 'x86_64 armv7 arm64'}
#    s.resource_bundles = {'permission_handler_apple_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
    
    # s.resource_bundles = {
    #   'CreekSDK' => ['CreekSDK/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    s.dependency 'SwiftProtobuf', '~> 1.25.2'
#    s.dependency 'onnxruntime-objc', '1.15.0'
#    s.dependency 'MicrosoftCognitiveServicesSpeech-iOS'
    s.static_framework = true
    s.resource_bundles = {
      'CreekSDKPrivacy' => ['Creek/PrivacyInfo.xcprivacy']
    }
   
end
