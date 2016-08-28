using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;

//! Controller for Paddle Two.
class GameDisplayDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	// Pause the game
    }
    
    function onSelect() {
    	// TODO: Pause the game
    }
    
    function onKey(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		paddleTwoDown();
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		paddleTwoUp();
    	}
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}