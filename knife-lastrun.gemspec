# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-lastrun/version"

Gem::Specification.new do |s|
  s.name          = 'knife-lastrun'
  s.version       = Knife::NodeLastrun::VERSION
  s.date          = '2017-07-05'
  s.summary       = "A plugin for Chef::Knife which displays node metadata about the last chef run."
  s.description   = s.summary
  s.authors       = ["John Goulah"]
  s.email         = ["jgoulah@gmail.com"]
  s.homepage      = "https://github.com/jgoulah/knife-lastrun"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
