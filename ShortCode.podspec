Pod::Spec.new do |s|
  s.name         = "ShortCode"
  s.version      = "0.0.4"
  s.summary      = "Short human-readable codes."
  s.description  = <<-DESC
  A tool for creating human-readable shortcodes for identification.
                   DESC
  s.homepage     = "https://github.com/rchatham/ShortCode"
  s.license      = "MIT"
  s.author             = { "Reid Chatham" => "reid.chatham@gmail.com" }
  s.source       = { :git => "https://github.com/rchatham/ShortCode.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*"
end
