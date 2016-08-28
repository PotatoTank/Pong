using Toybox.WatchUi as Ui;

class ProgressBarDelegate extends Ui.BehaviorDelegate {
	
	hidden var callback;
	
    function initialize(callback) {
        BehaviorDelegate.initialize();
        self.callback = callback;
    }
    
    function onMenu() {
    }
    
    function onKeyPressed(evt) {
    }

	function onTap(evt) {
    }
    
    function onBack() {
    	callback.invoke();
    }
}