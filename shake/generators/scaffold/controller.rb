require Pathname.new( $0 ).realpath() + "../generators/scaffold/scaffold.rb"

class Controller < Scaffold
  
  #-----------------------------------------------------------------------------
  #   INITIALIZING
  #-----------------------------------------------------------------------------
  
  def initialize( gen, params )
    @foldername = "controllers"
    super( gen, params )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   INTERACTIONS
  #-----------------------------------------------------------------------------
  
  def interact
#    puts "Please, insert this and that"
#    thisandthat = STDIN.gets.chomp
#    puts thisandthat
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   LOADING TEMPLATES
  #-----------------------------------------------------------------------------
  
  def load
    base = File.join( @gen.TEMPLATES_DIR, "/scaffold/controller/" )
    @tmpl = IO.read( File.join( base, "controller.tmpl"  ) )
    @tmpl_dependency = IO.read( File.join( base, "controller.dependency.tmpl"  ) )
    @tmpl_action = IO.read( File.join( base, "controller.action.tmpl"  ) )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING
  #-----------------------------------------------------------------------------
  
  def build
    build_dependencies
    build_actions
    File.open( @filepath, "w" ) { |f|
      f.write @buffer
    }
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING ACTIONSCRIPT
  #-----------------------------------------------------------------------------
  
  def build_dependencies
    output = Array.new
    @actions.each { |action|
      block = @tmpl_dependency.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%DEPENDENCIES%", output.join( "\n\t\t\n" ) )
  end
  
  def build_actions
    output = Array.new
    @actions.each { |action|
      block = @tmpl_action.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%ACTIONS%", output.join( "\n\t\t\n" ) )
  end
end