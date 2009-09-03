# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './tasks/yard.rb'

Hoe.spec('rprogram') do
  self.rubyforge_name = 'rprogram'
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = ''

  self.extra_deps = [
    ['yard', '>=0.2.3.5']
  ]

  self.spec_extras = {:has_rdoc => 'yard'}
end

# vim: syntax=Ruby
