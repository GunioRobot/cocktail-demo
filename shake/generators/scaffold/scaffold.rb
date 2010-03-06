class Scaffold
  
  #-----------------------------------------------------------------------------
  #   INITIALIZING
  #-----------------------------------------------------------------------------
  
  def initialize( gen, params )
    config( gen, params )
    run()
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   RUNNING SCAFFOLD SEQUENTIAL ACTIONS
  #-----------------------------------------------------------------------------
  
  def run
    interact()
    load()
    prebuild()
    build()
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   CONFIGURING FILES PATH
  #-----------------------------------------------------------------------------
  
  def config( gen, params )
    @gen = gen
    @areaname = params[ 0 ].camelize
    @actions = params.slice( 1, params.length )
    
    @filename = "#{@foldername.singularize.capitalize}.as"
    @filepath = "/#{@foldername}/#{@areaname}#{@filename}"
    @filepath = File.join( @gen.APP_DIR, @filepath )
    
    @fxml_filepath = "cocktail/xml/#{@foldername}/#{@areaname.downcase}.xml"
    @fxml_filepath = File.join( @gen.DEPLOY_DIR, @fxml_filepath )
  end
  
  
  
  #-----------------------------------------------------------------------------
  #   PRE-BUILDING
  #-----------------------------------------------------------------------------
  
  def prebuild
    @buffer = @tmpl.gsub(
      "<PROJECT_NAME>", @gen.PROJECT_NAME
    ).gsub(
      "<AREA_NAME>", @areaname
    )
  end
end