Pod::Spec.new do |s|
  
  s.name     = 'JohnnyEnglish'
  s.version  = '0.0.4'
  s.summary  = 'A light-weight AOP-based analytics binder'
  s.homepage = "https://github.com/ef-ctx/JohnnyEnglish"
  
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.authors      = {
    "Dmitry Makarenko"   => "dmitry.makarenko@ef.com",
    "Alberto De Bortoli" => "'alberto.debortoli@ef.com",
    "Mário Barbosa" => "mario.araujo@ef.com"
  }

  s.dependency 'Aspects', '~>1.4.2ctx'
  s.dependency 'GoogleAnalytics'

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  
  s.source   = { :git => 'git@github.com:ef-ctx/JohnnyEnglish.git', :tag => "#{s.version}" }
  s.source_files = 'Sources/**/*.{h,m}'
  
end
