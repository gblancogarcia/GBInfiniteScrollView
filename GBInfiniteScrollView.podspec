Pod::Spec.new do |s|
  s.name         = "GBInfiniteScrollView"
  s.version      = "1.6"
  s.summary      = "GBInfiniteScrollView class provides an endlessly scroll view organized in pages."
  s.homepage     = "https://github.com/gblancogarcia"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Gerardo Blanco" => "gblancogarcia@gmail.com" }
  s.source       = { :git => "https://github.com/gblancogarcia/GBInfiniteScrollView.git", :tag => "{s.version}" }
  s.platform     = :ios, '6.1'
  s.requires_arc = true
  s.default_subspec = 'Core'
  s.subspec 'Core' do |core|
    core.source_files = 'GBInfiniteScrollView/GBInfiniteScrollView/*.{h,m}'
  end
  s.subspec 'PageControl' do |pc|
    pc.dependency 'GBInfiniteScrollView/Core'
    pc.source_files = 'GBInfiniteScrollView/GBInfiniteScrollView/Optional/PageControlSubClass/*.{h,m}'
    pc.dependency 'FXPageControl', '~> 1.3.2'
  end
end
