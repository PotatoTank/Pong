using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class GameDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    }
    
    function onKeyPressed(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		Sys.println("Down");
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		Sys.println("Up");
    	}
    }

	function onTap(evt) {
        Sys.println("Hi");
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}