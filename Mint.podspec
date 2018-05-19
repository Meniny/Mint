Pod::Spec.new do |s|
  s.name        = 'Mint'
  s.module_name = 'Mint'
  s.version     = '2.0.0'
  s.summary     = 'A human readable HTTP request library in Swift.'
  s.description  = <<-EOS
Mint is a hunan readable HTTP request library in Swift.
EOS

  s.homepage    = 'https://github.com/Meniny/Mint'
  s.license     = { type: 'MIT', file: 'LICENSE.md' }
  s.authors     = { 'Elias Abel' => 'admin@meniny.cn' }
  s.social_media_url = 'https://meniny.cn/'
  # s.screenshot = ''

  s.ios.deployment_target     = '9.0'
  s.osx.deployment_target     = '10.11'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.requires_arc        = true
  s.source              = { git: 'https://github.com/Meniny/Mint.git', tag: s.version.to_s }

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
  s.swift_version       = '4.1'

  # s.dependency "Jsonify"

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files  = 'Mint/Core/**/*.swift'
  end

end
