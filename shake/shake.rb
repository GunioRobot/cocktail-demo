#!/usr/bin/ruby

require 'pathname'
require 'rubygems'
require 'active_support/inflector'

# computes basic paths to start the magic
BASE = Pathname.new( $0 + "/../.." ).realpath()
SHAKE = Pathname.new( $0 + "/.." ).realpath()
FIND = File.join( SHAKE, "/**/*.rb" )

# require all found ruby scripts/classes
Dir[ FIND ].each { |c|
  unless c.to_s == Pathname.new( $0 ).realpath().to_s
    require c
  end
}

# starts the automagic generator
Generator.new( BASE, ARGV )


#####################################################
####################### USAGE #######################
#####################################################

# ruby shake.rb scaffold areaname action1 action2 action3
# ruby shake.rb model areaname action1 action2 action3
# ruby shake.rb view areaname action1 action2 action3
# ruby shake.rb controller areaname action1 action2 action3