
Pod::Spec.new do |s|
  s.name          = 'KeenCodeUnit'
  s.version       = '1.0.0'
  s.summary       = '高度自定义的验证码、支付密码输入文本框，支持明文、密文输入等'
  s.homepage      = 'https://github.com/chongzone/KeenCodeUnit'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { 'chongzone' => 'chongzone@163.com' }
  
  s.requires_arc  = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.source = { :git => 'https://github.com/chongzone/KeenCodeUnit.git', :tag => s.version }
  
  s.source_files = 'KeenCodeUnit/Classes/**/*'
#  s.resource_bundles = {
#    'KeenCodeUnit' => ['KeenCodeUnit/Assets/*.png']
#  }

end
