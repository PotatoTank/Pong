using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PongMenuDelegate extends Ui.MenuInputDelegate {

	var sensor;
	var display;

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            Sys.println("Host");
            sensor = new PongSensor();
        	sensor.open();
            Ui.switchToView(new GameView(sensor), new GameDelegate(), Ui.SLIDE_RIGHT);
            
            
        } else if (item == :item_2) {
            Sys.println("Join");
            //Ui.switchToView(new JoinView(), new JoinDelegate(), Ui.SLIDE_RIGHT);
            
            display = new PongDisplay();
            display.open();    
            
            Ui.switchToView(new GameViewDisplay(display), new GameDelegate(), Ui.SLIDE_RIGHT); 
        }
    }

}