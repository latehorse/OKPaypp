Pod::Spec.new do |s|
  s.name             = 'OKPaypp'
  s.version          = '0.1.0'
  s.summary          = 'OKPaypp iOS SDK.'

  s.description      = <<-DESC
  移动应用支付接口。
  开发者不再需要编写冗长的代码，简单几步就可以使你的应用获得支付功能。
  让你的移动应用接入支付像大厦接入电力一样简单，方便，和温暖。
  支持微信支付，公众账号支付，支付宝钱包。
                       DESC

  s.homepage         = 'https://github.com/latehorse/OKPaypp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'deadvia' => 'deadvia@gmail.com' }
  s.source           = { :git => 'https://github.com/latehorse/OKPaypp.git', :tag => s.version.to_s }
  s.requires_arc     = true
  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Core', 'Alipay', 'Wx'
  
  s.subspec 'Core' do |core|
      core.public_header_files = 'OKPaypp/*.h', 'OKPaypp/Core/OKPayDefaultConfigurator.h'
      core.source_files = 'OKPaypp/*.{h,m}', 'OKPaypp/Core/*.{h,m}'
      core.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security', 'CoreTelephony'
      core.ios.library = 'c++', 'stdc++', 'z'
  end
  
  s.subspec 'Alipay' do |ss|
      ss.ios.vendored_frameworks = 'OKPaypp/Channels/Alipay/*.framework'
      ss.vendored_libraries = 'OKPaypp/Channels/Alipay/*.a'
      ss.resource = 'OKPaypp/Channels/Alipay/*.bundle'
      ss.frameworks = 'CoreMotion', 'CoreTelephony'
      ss.dependency 'OKPaypp/Core'
  end
  
  s.subspec 'Wx' do |ss|
      ss.vendored_libraries = 'OKPaypp/Channels/Wx/*.a'
      ss.source_files = 'OKPaypp/Channels/Wx/*.{h,m}'
      ss.ios.library = 'z', 'sqlite3.0', 'c++'
      ss.dependency 'OKPaypp/Core'
  end

end
