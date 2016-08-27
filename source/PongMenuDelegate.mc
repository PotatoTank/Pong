using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PongMenuDelegate extends Ui.MenuInputDelegate {

	var sensor;
	var display;
	
	var gameView;
	
	hidden var progressBar;
	hidden var timer;

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	if (sensor != null) {
    		sensor.close();
    	}
    	if (display != null) {
    		display.close();
    	}
    	
        if (item == :item_1) {
            Sys.println("Host");
            sensor = new PongSensor(method(:pongSensorCallback));
        	sensor.open();
        	
        	toProgressBar();          
            
        } else if (item == :item_2) {
            Sys.println("Join");            
            display = new PongDisplay(method(:pongDisplayCallback));
            display.open();
            
            toProgressBar();
            // Ui.switchToView(new GameViewDisplay(display), new GameDelegate(), Ui.SLIDE_RIGHT); 
        }
    }
    
    function toProgressBar() {
    	if (timer == null) {
    		timer = new Timer.Timer();
    	}
    	
    	// A progress bar with "busy" scrolling.
    	progressBar = new Ui.ProgressBar("Searching...", null);
    	Ui.pushView(progressBar, new ProgressBarDelegate(method(:progressBarCallback)), Ui.SLIDE_LEFT);
    	// 10-second delay to match the time-out of the search.
    	timer.start(method(:timerCallback), 10000, true);
    }
    
    //! Called if the watch cannot pair within timeout period.
    function timerCallback() {
    	// Go back to the menu view.
    	Ui.popView(Ui.SLIDE_RIGHT);
    	stopTimer();
	}
    
    function onBack() {
    	stopTimer();
    	sensor.close();
    	display.close();
    }
    
    hidden function stopTimer() {
    	if (timer != null) {
    		timer.stop();
    	}
    }
    
    function progressBarCallback() {
    	stopTimer();
    	if (sensor != null) {
    		sensor.close();
    	}
    	if (display != null) {
    		display.close();
    	}
    	Sys.println("everything stopped");
    }
    
    function pongSensorCallback() {
    	stopTimer();
    	if (progressBar != null) {
    		Ui.popView(Ui.SLIDE_IMMEDIATE);
    	}
		Ui.switchToView(new GameView(sensor), new GameDelegate(), Ui.SLIDE_LEFT);
    }
    
    function pongDisplayCallback() {
    	stopTimer();
    	if (progressBar != null) {
    		Ui.popView(Ui.SLIDE_IMMEDIATE);
    	}
		Ui.switchToView(new GameDisplayView(display), new GameDisplayDelegate(), Ui.SLIDE_LEFT);
    }
}