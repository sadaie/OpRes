Pod::Spec.new do |s|
  s.name         = "OpRes"
  s.version      = "0.5.4"
  s.summary      = "Rust-like Swift's Optional and Result type extensions."
  s.description  = <<-DESC
  OpRes.framework is tiny library to extend Swift's Optional and Result type to be Rust lang style.
                   DESC
  s.homepage     = "https://github.com/sadaie/OpRes"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Sadaie Matsudaira" => "sadaie@matsuri-hi.me" }
  s.social_media_url   = "https://twitter.com/sadaie_p"
  s.swift_version = "5.0"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => "https://github.com/sadaie/OpRes.git", :tag => "#{s.version}" }
  s.source_files  = "OpRes", "OpRes/**/*.{swift}"
end
