using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Time as Time;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian; 
using Toybox.Application;
using Toybox.Math;
using Toybox.System;
using Toybox.Time.Gregorian;

var startTime = 0;
var pausedTime = 0;
var delta = 0;
var running = false;

var timer1 = null;
var childViewCreated = false;

class StopWatchWidgetView extends Ui.View {

	function secondPassedEvent(){
		Ui.requestUpdate();
	}

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        View.onUpdate(dc);
        
		restoreProperties();
		
		if(childViewCreated == false){
		      System.println("new view 0"); 
		      childViewCreated = true;   
		      Ui.pushView(new StopWatchWidgetView(), new MyInputDelegate(), Ui.SLIDE_IMMEDIATE);
		}	
	    
	    if(timer1 == null){
	    	System.println("start timer");
	    	timer1 = new Timer.Timer();
        	timer1.start(method(:secondPassedEvent), 100, true);
        }
        
        onUpdate(dc); 
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    function setStartTime(){
    	    startTime = System.getTimer();//new Time.Moment(Time.now().value()).value(); 
		    StopWatchWidgetView.saveMyProperties();	
    }
    
    function resetStartTime(){
    	startTime = 0;
    	running = false;
    	pausedTime = 0;
    	delta = 0;
    	
    	StopWatchWidgetView.saveMyProperties();
    }
    
    
    // Update the view
    function onUpdate(dc) {
        
           // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);     
        var string;
        
      
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE  );
        dc.clear();
        dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        
        //CLOCK PART
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var clockString = Lang.format(
		    "$1$:$2$",
		    [
		        today.hour.format("%02d"),
		        today.min.format("%02d")
		       // today.sec.format("%02d"),
		        //today.day_of_week,
		       // today.day,
		       // today.month,
		       // today.year
		    ]
		);
        dc.drawText( dc.getWidth()/2,  7, Gfx.FONT_MEDIUM, clockString, Gfx.TEXT_JUSTIFY_CENTER);
        
        //separator
        dc.drawLine(0, 40, dc.getWidth(), 40);
        
        //STOPWATCH PART        
		var currentTime = System.getTimer();//new Time.Moment(Time.now().value()).value();
		
		var resp = 0;
		
		if(running == false){
        	if(pausedTime != 0){
        		resp = pausedTime - startTime - delta;
        	}else{
        		resp = 0;
        	}
        }else{
        	resp = currentTime - startTime - delta;
        }

		var hours = Math.floor(resp/3600000l);
		var minutes = Math.floor((resp - hours*3600000l)/60000l);
		var seconds = Math.floor((resp - hours*3600000l - minutes*60000l)/1000l); 
		var hundreds = Math.floor((resp - hours*3600000l - minutes*60000l - seconds*1000l)/10);
		
		var dateString = Lang.format(
		    "$1$:$2$:$3$:$4$",
		    [
		        hours.format("%02d"),
		        minutes.format("%02d"),
		        seconds.format("%02d"),
		        hundreds.format("%02d")
		    ]
		);
		dc.setColor(Gfx.COLOR_DK_RED   , Gfx.COLOR_TRANSPARENT);
		string = dateString;
        dc.drawText( dc.getWidth()/2, (dc.getHeight() / 2) - 20, Gfx.FONT_LARGE, string, Gfx.TEXT_JUSTIFY_CENTER );
        
        
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	StopWatchWidgetView.saveMyProperties();
    }
    
    function restoreProperties(){
    	var app = Application.getApp();
	    startTime = app.getProperty(STOPWATCH_IA_START);
	    pausedTime = app.getProperty(STOPWATCH_IA_PAUSEDTIME);
	    delta = app.getProperty(STOPWATCH_IA_delta);
	    running = app.getProperty(STOPWATCH_IA_RUNNING);
	    	   
	    if(startTime == null){
	    	startTime =0;
	    }
	    if(pausedTime == null){
	    	pausedTime = 0;
	    }
	    if(delta == null){
	    	delta = 0;
	    }
	    if(running == null){
	    	running = false;
	    }	   
	    	    
	    var test1 = (pausedTime != 0) && ((pausedTime - startTime - delta) < 0);
	    var test2 = (pausedTime == 0) && ((System.getTimer() - startTime - delta) < 0);
	    //in case watch had been restarted reset all settings
	    if(test1 || test2){
	    	System.println("!!!!");
	    	startTime = 0;
	    	pausedTime = 0;
	    	delta = 0;
	    	running = false;
	    	saveMyProperties();
	    } 
    }
    
    function saveMyProperties(){
    	var app = Application.getApp();
    	
    	app.setProperty(STOPWATCH_IA_START, startTime);    	
    	app.setProperty(STOPWATCH_IA_PAUSEDTIME, pausedTime);
    	app.setProperty(STOPWATCH_IA_delta, delta);
    	app.setProperty(STOPWATCH_IA_RUNNING, running);
    	
    	app.saveProperties();
    }

}
