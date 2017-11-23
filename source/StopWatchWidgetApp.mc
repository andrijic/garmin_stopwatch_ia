using Toybox.Application as App;
using Toybox.WatchUi as Ui;


var childViewCreated = false;
var STOPWATCH_IA_START = "STOPWATCH_IA_START";
var STOPWATCH_IA_PAUSEDTIME = "STOPWATCH_IA_PAUSEDTIME";
var STOPWATCH_IA_delta = "STOPWATCH_IA_delta";
var STOPWATCH_IA_RUNNING = "STOPWATCH_IA_RUNNING";


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
    
    
    function onKey(event){    	
    	var key = event.getKey();
    	
    	//System.println("key: "+key);
    	
    	
    	    	
        if(key == Ui.KEY_ESC){   
        	System.println("BACK "+counterInter);
        	
        	
        	if(startTime == 0){
        		
        		//Ui.popView(Ui.SLIDE_IMMEDIATE);
        	
	        		/*if(childViewCreated == true){
						Ui.popView(Ui.SLIDE_IMMEDIATE);
						childViewCreated = false;						
				   	}*/
	    	    	
	    	    	//System.exit();
	    	    	return false;
	    	 }else if(running == false){        		
        			StopWatchWidgetView.resetStartTime();
        			return true;
        	}else{
        		//TODO:LAP RECORD
    	    }        
    	    
    	    return false;	
       	    	
        }/*else if(key == Ui.KEY_DOWN){
        	System.println("DOWN "+counterInter); 
        	return false;
        }else if(key == Ui.KEY_UP){
        	System.println("UP "+counterInter);        	
        }else*/ if(key == Ui.KEY_ENTER){
        	System.println("ENTER "+counterInter);  
        	
        	if(running == true){
        		running = false;
        		pausedTime = System.getTimer();
        	}else{
        		if(pausedTime > 0){
        			delta = System.getTimer() - pausedTime + delta;
        		}else{
        			StopWatchWidgetView.setStartTime();
        		}  
        		running = true;
        		
        		if(childViewCreated == false && startTime == 0){
		        	System.println("new view"); 
		        	childViewCreated = true;       		
		        	Ui.pushView(new StopWatchWidgetView(), new MyInputDelegate(), Ui.SLIDE_IMMEDIATE);
		        }		
        	}
        	
			return true;        	 	
        }
        
        return false;
    }
    
    /*
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
    }*/
 
}
