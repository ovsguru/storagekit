Pod::Spec.new do |s|
  s.name             = 'StorageKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of StorageKit.'
  s.homepage         = 'https://github.com/ovsguru/storagekit'
  s.license          = { :type => 'MIT' }
  s.author           = { 'ovsguru' => 'ovsguru@gmail.com' }
  s.source           = { :path => '*' }
  s.ios.deployment_target = '13.0'
  s.source_files = '**/*.{swift}'
  s.dependency 'EasyDI'
end
