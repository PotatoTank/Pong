using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System as Sys;

class PongDisplay extends Ant.GenericChannel {
   	const DEVICE_TYPE = 1;
    const PERIOD = 1966;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;

    hidden var chanAssign;

    var data;
    var searching;
    var pastEventCount;
    var deviceCfg;
    
    var payload;

    function initialize() {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX, Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 1,                 // Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANSMISSION_TYPE,
            :messagePeriod => PERIOD,
            :radioFrequency => RADIO_FREQUENCY,
            :searchTimeoutLowPriority => 10,    // Timeout in 25s
            :searchThreshold => 0} );           // Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        payload = new [8];
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        searching = true;
    }

	function getBallX() {
		return payload[1];
	}
	
	function getBallY() {
		return payload[2];
	}

    function closeSensor() {
        GenericChannel.close();
    }

    function onMessage(msg) {
        // Parse the payload
        payload = msg.getPayload();
		Sys.println(payload);
    }
}