using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;

//! Controller for Paddle Two.
class GameDisplayDelegate extends Ui.BehaviorDelegate {

	var prevKeyBack = false; // double tap back to go back

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	// Pause the game
    	prevKeyBack = false;
    }
    
    function onSelect() {
    	// TODO: Pause the game
    	prevKeyBack = false;
    }
    
    function onBack() {
    	if (gameState == STATE_PLAY) {
    		if (prevKeyBack) {
    			return false;
    		}
    		else {
    			prevKeyBack = true;
    			return true; // disables back key
    		}
    	}
    	else {
    		return false;
    	}
    }
    
    function onKey(evt) {
    	if (evt.getKey() == Ui.KEY_DOWN) {
    		paddleTwoDown();
    		prevKeyBack = false;
    	}
    	else if (evt.getKey() == Ui.KEY_UP) {
    		paddleTwoUp();
    		prevKeyBack = false;
    	}
    }
    
    function getDelegate()
    {
        var delegate = new GameDelegate();
        return delegate;
    }
}