Pod::Spec.new do |s|
  s.name         = "ConnectSDK"
  s.version      = "2.0.0"
  s.summary      = "Connect SDK is an open source framework that connects your mobile apps with multiple TV platforms."
  
  s.description  = <<-DESC
                    Connect SDK is an open source framework that connects your mobile apps with multiple TV platforms. Because most TV platforms support a variety of protocols, Connect SDK integrates and abstracts the discovery and connectivity between all supported protocols.

                    To discover supported platforms and protocols, Connect SDK uses SSDP to discover services such as DIAL, DLNA, UDAP, and Roku's External Control Guide (ECG). Connect SDK also supports ZeroConf to discover devices such as Chromecast and Apple TV. Even while supporting multiple discovery protocols, Connect SDK is able to generate one unified list of discovered devices from the same network.

                    To communicate with discovered devices, Connect SDK integrates support for protocols such as DLNA, DIAL, SSAP, ECG, AirPlay, Chromecast, UDAP, and webOS second screen protocol. Connect SDK intelligently picks which protocol to use depending on the feature being used.

                    For example, when connecting to a 2013 LG Smart TV, Connect SDK uses DLNA for media playback, DIAL for YouTube launching, and UDAP for system controls. On Roku, media playback and system controls are made available through ECG, and YouTube launching through DIAL. On Chromecast, media playback occurs through the Cast protocol and YouTube is launched via DIAL.

                    To support the aforementioned use case without Connect SDK, a developer would need to implement DIAL, ECG, Chromecast, and DLNA in their app. With Connect SDK, discovering the three devices is handled for you. Furthermore, the method calls between each protocol is abstracted. That means you can use one method call to beam a video to Roku, 3 generations of LG Smart TVs, Apple TV, and Chromecast.
                   DESC

  s.homepage     = "http://www.connectsdk.com/"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Connect SDK" => "support@connectsdk.com" }
  s.platform     = :ios, "11.0"
  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/arslanilyas/Connect-SDK-iOS.git",
                     :tag => s.version,
                     :submodules => true }

  s.xcconfig = {
      "OTHER_LDFLAGS" => "$(inherited) -ObjC"
  }

  s.requires_arc = true
  s.libraries = "z", "icucore"

  non_arc_files =
    "core/Frameworks/asi-http-request/External/Reachability/*.{h,m}",
    "core/Frameworks/asi-http-request/Classes/*.{h,m}"

  s.subspec 'Core' do |sp|
    sp.source_files  = "ConnectSDKDefaultPlatforms.h", "core/**/*.{h,m}"
    sp.exclude_files = (non_arc_files.dup << "core/ConnectSDK*Tests/**/*" << "core/Frameworks/LGCast/**/*.h")
    sp.private_header_files = "core/**/*_Private.h"
    sp.requires_arc = true

    sp.dependency 'ConnectSDK/no-arc'
    sp.ios.vendored_frameworks = 'core/Frameworks/LGCast/LGCast.xcframework', 'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
    sp.preserve_paths =  'core/Frameworks/LGCast/LGCast.xcframework', 'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
  end

  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
    sp.compiler_flags = '-w'
  end

  s.subspec 'GoogleCast' do |sp|
    cast_dir = "modules/google-cast"

    sp.dependency 'ConnectSDK/Core'
    sp.source_files = "#{cast_dir}/**/*.{h,m}"
    sp.exclude_files = "#{cast_dir}/*Tests/**/*"
    sp.private_header_files = "#{cast_dir}/**/*_Private.h"

    sp.vendored_frameworks = "#{cast_dir}/GoogleCast.xcframework"

    sp.xcconfig = {
        "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/#{cast_dir}"
    }
  end
end
