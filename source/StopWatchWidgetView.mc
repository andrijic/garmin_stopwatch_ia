using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.Time as Time;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian; 
using Toybox.Application;
using Toybox.Math;
using Toybox.System;

var timer1;
var startTime;
var running = false;



var STOPWATCH_IA_START = "STOPWATCH_IA_START";

class StopWatchWidgetView extends Ui.View {

	function secondPassedEvent(){
		Ui.requestUpdate();
	}

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
       // setLayout(Rez.Layouts.MainLayout(dc));
        
		var app = Application.getApp();
        var startTimeProp = app.getProperty(STOPWATCH_IA_START);
              //startTimeProp = null; 
        if(startTimeProp == null){	       
	        startTime = System.getTimer();//new Time.Moment(Time.now().value()).value(); 
	        app.setProperty(STOPWATCH_IA_START, startTime);
		    app.saveProperties();
	    }else{
		     startTime = startTimeProp;
		}
	    
	    timer1 = new Timer.Timer();
        timer1.start(method(:secondPassedEvent), 100, true);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        if(childViewCreated == false){
        	View.onUpdate(dc);
        }
        
        var string;
        
        if(running == false){
        	return;
        }

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
		var currentTime = System.getTimer();//new Time.Moment(Time.now().value()).value();
		var resp = currentTime - startTime;

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
		
		string = "Timer: "+dateString;
        dc.drawText( string.length(), (dc.getHeight() / 2) - 30, Gfx.FONT_MEDIUM, string, Gfx.TEXT_JUSTIFY_LEFT);
        
        
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
