function getWindowHeight() {
  var windowHeight = 0;
	
  if (typeof(window.innerHeight) == 'number')
    windowHeight = window.innerHeight;
	
  else {
		
    if (document.documentElement && document.documentElement.clientHeight)
      windowHeight = document.documentElement.clientHeight;
		
    else {
      if (document.body && document.body.clientHeight)
        windowHeight = document.body.clientHeight; }; };
				
  return windowHeight;
};

function getWindowWidth() {
  var windowWidth = 0;
	
  if (typeof(window.innerWidth) == 'number')
    windowWidth = window.innerWidth;
	
  else {
		
    if (document.documentElement && document.documentElement.clientWidth)
      windowWidth = document.documentElement.clientWidth;
		
    else {
      if (document.body && document.body.clientWidth)
        windowWidth = document.body.clientWidth; }; };
				
  return windowWidth;
};


function forcesize ()
{
	if ( getWindowWidth() < 820)
		document.getElementById("content").style.width = "800px";
	else
		document.getElementById("content").style.width = "100%";
	
	if ( getWindowHeight() < 720)
		document.getElementById("content").style.height = "720px";
	else
		document.getElementById("content").style.height = "100%";
}

window.onload = function()
{
	forcesize();
}

window.onresize = function()
{
	forcesize();
}