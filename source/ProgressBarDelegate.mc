using Toybox.WatchUi as Ui;

class ProgressBarDelegate extends Ui.BehaviorDelegate {
	
    function initialize(callback) {
        BehaviorDelegate.initialize();
    }
    
    function onMenu() {
    }
    
    function onKeyPressed(evt) {
    }

	function onTap(evt) {
    }
    
    function onBack() {
		return false;
    }
}