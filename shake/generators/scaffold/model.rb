require Pathname.new( $0 ).realpath() + "../generators/scaffold/scaffold.rb"

class Model < Scaffold
  
  #-----------------------------------------------------------------------------
  #   INITIALIZING
  #-----------------------------------------------------------------------------
  
  def initialize( gen, params )
    @foldername = "models"
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
    base = File.join( @gen.TEMPLATES_DIR, "/scaffold/model/" )
    @tmpl = IO.read( File.join( base, "model.tmpl"  ) )
    @tmpl_load_case = IO.read( File.join( base, "model.load.case.tmpl"  ) )
    @tmpl_action = IO.read( File.join( base, "model.action.tmpl"  ) )
    
    # fxml templates
    base = File.join( @gen.TEMPLATES_DIR, "/scaffold/xml/" )
    @tmpl_fxml = IO.read( File.join( base, "model.tmpl" ) )
    @tmpl_fxml_action = IO.read( File.join( base, "model.action.tmpl" ) )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING
  #-----------------------------------------------------------------------------
  
  def build
    # actionscript
    build_load_cases
    build_actions
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
  
  def build_load_cases
    output = Array.new
    @actions.each { |action|
      block = @tmpl_load_case.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%LOAD_CASES%", output.join( "\n\t\t\t\t\n" ) )
  end
  
  def build_actions
    output = Array.new
    @actions.each { |action|
      block = @tmpl_action.gsub( "<ACTION_NAME>", action  )
      output.push( block )
    }
    @buffer = @buffer.gsub( "%ACTIONS%", output.join( "\n\t\t\n" ) )
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