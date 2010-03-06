require Pathname.new( $0 ).realpath() + "../generators/scaffold/scaffold.rb"

class View < Scaffold
  
  #-----------------------------------------------------------------------------
  #   INITIALIZING
  #-----------------------------------------------------------------------------
  
  def initialize( gen, params )
    @foldername = "views"
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
    # actionscript templates
    base = File.join( @gen.TEMPLATES_DIR, "/scaffold/view/" )
    @tmpl = IO.read( File.join( base, "view.tmpl"  ) )
    @tmpl_before_render = IO.read( File.join( base, "view.before.render.case.tmpl"  ) )
    @tmpl_after_render = IO.read( File.join( base, "view.after.render.case.tmpl"  ) )
    @tmpl_before_destroy = IO.read( File.join( base, "view.before.destroy.case.tmpl"  ) )
    
    # fxml templates
    base = File.join( @gen.TEMPLATES_DIR, "/scaffold/xml/" )
    @tmpl_fxml = IO.read( File.join( base, "view.tmpl" ) )
    @tmpl_fxml_action = IO.read( File.join( base, "view.action.tmpl" ) )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING
  #-----------------------------------------------------------------------------
  
  def build
    # actionscript
    build_before_render_cases
    build_after_render_cases
    build_before_destroy_cases
    File.open( @filepath, "w" ) { |f|
      f.write @buffer
    }
    
    # fxml
    @buffer = @tmpl_fxml
    build_fxml_actions
    File.open( @fxml_filepath, "w" ) { |f|
      f.write @buffer
    }
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING ACTIONSCRIPT
  #-----------------------------------------------------------------------------
  
  def build_before_render_cases
    output = Array.new
    @actions.each { |action|
      block = @tmpl_before_render.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%BEFORE_RENDER_CASES%", output.join( "\n\t\t\t\t\n" ) )
  end
  
  def build_after_render_cases
    output = Array.new
    @actions.each { |action|
      block = @tmpl_after_render.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%AFTER_RENDER_CASES%", output.join( "\n\t\t\t\t\n" ) )
  end
  
  def build_before_destroy_cases
    output = Array.new
    @actions.each { |action|
      block = @tmpl_before_destroy.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%BEFORE_DESTROY_CASES%", output.join( "\n\t\t\t\t\n" ) )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING FXML
  #-----------------------------------------------------------------------------
  
  def build_fxml_actions
    output = Array.new
    @actions.each { |action|
      block = @tmpl_fxml_action.gsub(
        "<AREA_NAME>", @areaname 
      ).gsub(
        "<ACTION_NAME>", action
      )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%ACTIONS%", output.join( "\n\t\t\n\t\t\n\t\t\n" ) )
  end
  
end