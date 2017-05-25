
Pod::Spec.new do |s|
  s.name             = 'Waffle'
  s.version          = '1.0.3'
  s.summary          = 'Waffle is a deadsimple dependency container.'

  s.description      = <<-DESC
Waffle is a deadsimple dependency container. Waffle does not try to do too much, it will meet between 80 to 100 percent of your needs and allows you to extend Waffle so you can match all of your needs.
                       DESC

  s.homepage         = 'https://github.com/CodeReaper/Waffle'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jakob Jensen' => 'jakobj@jakobj.dk' }
  s.source           = { :git => 'https://github.com/CodeReaper/Waffle.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Waffle/Classes/*.swift'

end
