import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;
// import Toybox.Attention;

//var del = null as MyServiceDelegate;

(:background)
class ToastsApp extends Application.AppBase {
    

    function initialize() {

             AppBase.initialize();
        var pom = System.getClockTime();
        System.println("Intialize: "+ pom.hour +":"+pom.min+":"+pom.sec);

        // Background.deleteTemporalEvent();
        // if(Background.getTemporalEventRegisteredTime() == null) {
        //     Background.registerForTemporalEvent(new Time.Duration(5 * 60));
        // }

    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new ToastsView() , new MyDelegate() ];
        
    }

     public function getServiceDelegate() as [System.ServiceDelegate] {
        return [new MyServiceDelegate()];
    }    
}
 
function onStart(state){
 }

class MyDelegate extends WatchUi.BehaviorDelegate{

    function initialize(){
        WatchUi.BehaviorDelegate.initialize();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
         var pom = System.getClockTime();
    
        var targetic = 3 * 60;

        var targetTime = getTargetTime(targetic);
        System.println("Sending target time: " + targetTime);

        var target = new Time.Moment(targetTime);
        pom = Gregorian.info(target, Time.FORMAT_SHORT);
        var shortTextData  = {:value => pom.hour +":"+pom.min+":"+pom.sec};
        System.println("Target time is: "+shortTextData);

        Toybox.Complications.updateComplication(200, {:value => targetTime});

        Background.deleteTemporalEvent();
        if(Background.getTemporalEventRegisteredTime() == null) {
            Background.registerForTemporalEvent(new Time.Moment(targetTime));
        }


        return false;
    }

    function getTargetTime(seconds){
        var currTime = Time.now();

        if(seconds == null){
            return currTime;
        }else{             
            var targetTime = currTime.value() + seconds;            
            var targetMoment = new Time.Moment(targetTime);

            if(targetMoment!=null){
                return targetMoment.value();
            }else{
                return targetTime;
            }            
        }
    }
    
}
 

function onStop(state){
    var pom = System.getClockTime();
    System.println("On stop: "+ pom.hour +":"+pom.min+":"+pom.sec);
}

(:background)
class MyServiceDelegate extends System.ServiceDelegate {

    function initialize(){
        ServiceDelegate.initialize();
    }

    function getTargetTime(seconds){
        var currTime = Time.now();

        if(seconds == null){
            return currTime;
        }else{             
            var targetTime = currTime.value() + seconds;            
            var targetMoment = new Time.Moment(targetTime);

            if(targetMoment!=null){
                return targetMoment.value();
            }else{
                return targetTime;
            }            
        }
    }


    public function onTemporalEvent() as Void {
         System.println("On termporal event "+ System.getClockTime());

        Background.deleteTemporalEvent();    
        
        // var targetTime = getTargetTime(60 * 5);
        // System.println("Sending target time: " + targetTime);

        // var target = new Time.Moment(targetTime);
        // var pom = Gregorian.info(target, Time.FORMAT_SHORT);
        // var shortTextData  = {:value => pom.hour +":"+pom.min+":"+pom.sec};
        // System.println("Target time is: "+shortTextData);

        // Complications.updateComplication(200, {:value => targetTime});

        
        System.println("wake up");
        Background.requestApplicationWake("Timer End");
        Background.exit(null);
        
    }

}