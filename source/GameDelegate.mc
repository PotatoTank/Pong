using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;

//! Handles inputs for Paddle One.
class GameDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	// TODO: Pause the game
    }
    
    function onSelect() {
    	// TODO: Pause the game
    }
    
    function onKey(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		paddleOneDown();
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		paddleOneUp();
    	}
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}