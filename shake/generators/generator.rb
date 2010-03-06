class Generator
  
  attr_accessor  :BASE_DIR, :SHAKE_DIR, :TEMPLATES_DIR
  attr_accessor  :SOURCE_DIR, :PROJECT_NAME, :APP_DIR
  attr_accessor  :DEPLOY_DIR, :EMBEDDER_DIR
  
  
  
  ##############################################################################
  #   INITIALIZING
  ##############################################################################
  
  def initialize ( basepath, argv )
    config( basepath, argv )
    run( argv )
  end
  
  
  
  ##############################################################################
  #   CONFIGURING
  ##############################################################################
  def config( basepath, argv  )
    @BASE_DIR      = basepath
    @SHAKE_DIR     = File.join( @BASE_DIR, "shake" )
    @TEMPLATES_DIR = File.join( @SHAKE_DIR, "templates" )
    @SOURCE_DIR    = File.join( @BASE_DIR, "src" )
    @PROJECT_NAME  = find_project_name()
    @APP_DIR       = File.join( @SOURCE_DIR, @PROJECT_NAME )
    
    unless argv[ 0 ] == "embedder"
      @DEPLOY_DIR    = find_deploy_dir
    end
    
    @EMBEDDER_DIR  = File.join( @APP_DIR, "/boot/Embedder.as" )
  end
  
  # executes the requested action/script
  def run( argv  )
    action = argv[ 0 ]
    params = argv.slice( 1, argv.length )
    
    # MODEL
    if action == "model" || action == "scaffold"
      Model.new( self, params )
    end
    
    # VIEW
    if action == "view" || action == "scaffold"
      View.new( self, params )
    end
    
    # CONTROLLER
    if action == "controller" || action == "scaffold"
      Controller.new( self, params)
    end
    
    # EMBEDDER
    if action == "embedder"
      Embedder.new( self, params)
    end
  end
  
  
  
  ##############################################################################
  # FINDING PROJECT NAME (inside src folder)
  ##############################################################################
  
  def find_project_name()
    Dir[ @SOURCE_DIR +"/*" ].each { |i|
      if File::directory?( i )
        @name = i.split( "/" ).pop()
        break
      end
    }
    @name
  end
  
  def find_deploy_dir
    return ask_deploy_dir
  end
  
  
  
  ##############################################################################
  #   ASKING / CREATING DEPLOY DIR
  ##############################################################################
  
  def ask_deploy_dir
    folder = nil
    puts "(>) Please, insert the path to your deploy directory starting with this location:"
    puts "(:) "+ @BASE_DIR
    folder = STDIN.gets.chomp
    
    while folder == ""
      puts "(!) Sorry, I can't proceed without a directory entry. Could you help me to help you?\n"
      puts "(!>) Please, tell me what directory do you use for deploy starting with this location:"
      puts "(:) "+ @BASE_DIR
      folder = STDIN.gets.chomp
    end
    
    folder = File.join( @BASE_DIR, folder )
    
    if !File.directory?folder
      ask_deploy_creation( folder )
    end
    
    return folder
  end
  
  
  def ask_deploy_creation ( folder )
    puts "(>) The informed folder doesn't, do you want me to create it for you? (y/n)"
    puts "(:) "+ folder
    create = STDIN.gets.chomp
    if create == "y"
      FileUtils.makedirs( folder )
    else
      folder = ask_deploy_dir
    end
  end
end