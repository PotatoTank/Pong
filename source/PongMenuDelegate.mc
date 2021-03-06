using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

var sensor;
var display;

class PongMenuDelegate extends Ui.MenuInputDelegate {

	//var gameView;
	//var gameDisplayView;
	
	hidden var progressBar;
	hidden var timer;

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	stopTimer();
        if (item == :item_1) {
            sensor = new PongSensor(method(:pongSensorCallback));
        	sensor.open();
        	
        	toProgressBar();          
            
        } else if (item == :item_2) {           
            display = new PongDisplay(method(:pongDisplayCallback));
            display.open();
            
            toProgressBar();
        }
    }
    
    function toProgressBar() {
    	if (timer == null) {
    		timer = new Timer.Timer();
    	}
    	
    	// A progress bar with "busy" scrolling.
    	progressBar = new Ui.ProgressBar("Searching...", null);
    	Ui.pushView(progressBar, new ProgressBarDelegate(), Ui.SLIDE_LEFT);
    	// 10-second delay to match the time-out of the search.
    	timer.start(method(:timerCallback), 10000, true);
    }
    
    //! Called if the watch cannot pair within timeout period.
    function timerCallback() {
    	// Go back to the menu view.
    	Ui.popView(Ui.SLIDE_RIGHT);
    	stopTimer();
    	if (sensor != null) {
    		sensor.close();
    	}
    	if (display != null) {
    		display.close();
    	}
	}
    
    function onBack() {
    	stopTimer();
    }
    
    hidden function stopTimer() {
    	if (timer != null) {
    		timer.stop();
    	}
    }
    
    function pongSensorCallback() {
    	stopTimer();
		Ui.switchToView(new GameView(), new GameDelegate(), Ui.SLIDE_LEFT);
		//gameView.sensor = sensor;
    }
    
    function pongDisplayCallback() {
    	stopTimer();
		Ui.switchToView(new GameDisplayView(), new GameDisplayDelegate(), Ui.SLIDE_LEFT);
		//gameDisplayView.display = display;
    }
}