class Embedder
  
  #-----------------------------------------------------------------------------
  #   INITIALIZING
  #-----------------------------------------------------------------------------
  
  def initialize( gen, params )
    config( gen, params )
    run()
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   CONFIGURING FILES PATH
  #-----------------------------------------------------------------------------
  
  def config( gen, params )
    @gen = gen
    @params = params
    @filepath = File.join( @gen.APP_DIR, "/boot/Embedder.as" )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   RUNNING INITIAL TASKS
  #-----------------------------------------------------------------------------
  
  def run
    load()
    build()
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   LOADING TEMPLATES
  #-----------------------------------------------------------------------------
  
  def load
    # actionscript templates
    base = File.join( @gen.TEMPLATES_DIR, "/embed/" )
    @tmpl = IO.read( File.join( base, "embedder.tmpl" ) )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING
  #-----------------------------------------------------------------------------
  
  def build
    @buffer = @tmpl
    build_packages_classes
    File.open( @filepath, "w" ) { |f|
      f.write @buffer
    }
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   BUILDING IMPORTS AND CLASSES
  #-----------------------------------------------------------------------------
  
  def build_packages_classes
    imports = Array.new
    classes = Array.new
    
    find = File.join( @gen.APP_DIR, "/**/*.as" )
    files = Dir[ find ].grep( %r[.*/(views|controllers|models|layouts)] )
    
    files.each { |file|
      package = "\timport "+ @gen.PROJECT_NAME.downcase
      package += file.gsub( @gen.APP_DIR, "" ).gsub( "/", "." ).gsub( ".as", ";" )
      classname = "\t\t\t"+ package.split( "." ).pop()
      
      imports.push( package )
      classes.push( classname )
    }
    
    @buffer = @tmpl.gsub(
      "%IMPORTS%", imports.sort.join( "\n" )
    ).gsub(
      "%CLASSES%", classes.sort.join( "\n" )
    ).gsub(
      "<PROJECT_NAME>", @gen.PROJECT_NAME
    )
  end
  
end