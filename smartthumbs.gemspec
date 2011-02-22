# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "smartthumbs/version"

Gem::Specification.new do |s|
  s.name        = "smartthumbs"
  s.version     = Smartthumbs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexander Pauly"]
  s.email       = ["railsninja@gmx.net"]
  s.homepage    = "https://github.com/railsninja/Smartthumbs"
  s.summary     = %q{Smart on-the-fly thumbnail creation for blob or filesystem based images}
  s.description = %q{Smartthumbs let's you define several different formats. By default, every image is available in any format. Once a thumb is requested, it will be generated on the fly and then be saved to the public directory. The next user who accesses the image will get the static image from disk.'}

  s.rubyforge_project = "smartthumbs"

  s.add_dependency 'rmagick'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
