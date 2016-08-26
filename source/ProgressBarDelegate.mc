using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

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