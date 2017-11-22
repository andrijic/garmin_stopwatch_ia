using Toybox.Application as App;
using Toybox.WatchUi as Ui;


var childViewCreated = false;

class StopWatchWidgetApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	
        return [ new StopWatchWidgetView(), new MyInputDelegate() ];
    }
   
}


 class MyInputDelegate extends Ui.InputDelegate {
 
 	var counterInter;
 	
	  function initialize() {
	        MenuInputDelegate.initialize();
	       	       
	    }
    
       function onHold(event){
    	return true;
    }
    
    function onKey(event){    	
    	var key = event.getKey();
    	
    	//System.println("key: "+key);
    	    	
        if(key == Ui.KEY_ESC){   
        	System.println("BACK "+counterInter);
        	Ui.popView(Ui.SLIDE_IMMEDIATE);
        	
        	if(childViewCreated == true){
        		Ui.popView(Ui.SLIDE_IMMEDIATE);
        	}
        	
       	    	
        }else if(key == Ui.KEY_DOWN){
        	System.println("DOWN "+counterInter); 
        	return false;
        }else if(key == Ui.KEY_UP){
        	System.println("UP "+counterInter);        	
        }else if(key == Ui.KEY_ENTER){
        	System.println("ENTER "+counterInter);  
        	
        	if(running == true){
        		running = false;
        	}else{
        		running = true;        		
        	}
        	
        	if(childViewCreated == false){
        		System.println("new view"); 
        		childViewCreated = true;       		
        		Ui.pushView(new StopWatchWidgetView(), new MyInputDelegate(), Ui.SLIDE_IMMEDIATE);
        	}      	
        }
        
        return true;
    }
    
    function onKeyPressed(event){
    	System.println("Enter = add KB's " + event.getKey());
    	return true;
    } 
    
    function onKeyReleased(event){
    	System.println("released");
    	return true;
    }
    
     function onRelease(event){
    	System.println("release");
    	return true;
    }
    
    function onSelectable(event){
    	System.println("selectable");
    	return true;
    }
    
     function onSwipe(event){
    	System.println("onSwipe");
    	return true;
    }
    
    function onTap(event){
    	System.println("onTap");
    	return true;
    }
 
}
