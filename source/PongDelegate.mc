using Toybox.WatchUi as Ui;

class PongDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        showMenu();
        return true;
    }
    
    // Some watches do not have a "Menu" button, but have a "Select" button.
    function onSelect() {
    	showMenu();
    	return true;
    }
    
    function onTap(evt) {
    	showMenu();
    	return true;
    }
    
    hidden function showMenu() {
    	Ui.pushView(new Rez.Menus.MainMenu(), new PongMenuDelegate(), Ui.SLIDE_LEFT);
    }

}