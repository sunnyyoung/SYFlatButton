Pod::Spec.new do |s|

  s.name         = "SYFlatButton"
  s.version      = "1.3"
  s.summary      = "A customized NSButton with modern flat style like bootstrap."
  s.homepage     = "https://github.com/Sunnyyoung/SYFlatButton"
  s.license      = "MIT"
  s.authors      = { 'Sunnyyoung' => 'https://github.com/Sunnyyoung' }
  s.platform     = :osx, "10.9"
  s.source       = { :git => "https://github.com/Sunnyyoung/SYFlatButton.git", :tag => s.version }
  s.source_files = "SYFlatButton/SYFlatButton/*.{h,m}"
  s.requires_arc = true

end
