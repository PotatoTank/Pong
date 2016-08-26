using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System as Sys;

class PongSensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 1;
    const PERIOD = 1966; // 16.66 Hz
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;
    
    hidden var deviceNumber;

    hidden var chanAssign;

	hidden var payloadTx;
	hidden var payloadRx;
	hidden var message;

    hidden var data;
    hidden var dataPage;
    hidden var searching;
    hidden var pastEventCount;
    hidden var deviceCfg;

	hidden var pongSensorCallback;
	
	hidden var paired;

    function initialize(callback) {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_TX_NOT_RX, Ant.NETWORK_PUBLIC);
        GenericChannel.initialize(method(:onMessage), chanAssign);
        
        deviceNumber = Random.getRandomNumber(1, 256);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => self.deviceNumber,
            :deviceType => DEVICE_TYPE,
            :transmissionType => TRANSMISSION_TYPE,
            :messagePeriod => PERIOD,
            :radioFrequency => RADIO_FREQUENCY,
            :searchTimeoutLowPriority => 4} ); // 10 second time out.
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        payloadTx = new [8];
        payloadRx = new [8];
        message = new Ant.Message();
        data = new PongData();
        dataPage = new PongDataPage();
        
        pongSensorCallback = callback;
        
        paired = false;
    }

    function open() {
        // Open the channel
        GenericChannel.open();
        searching = true;
        updateBroadcast();
    }

    function close() {
        GenericChannel.close();
    }

	function update(ballX, ballY) {
		data.ballX = ballX;
		data.ballY = ballY;
		
		updateBroadcast();
	}

	function updateBroadcast() {
		dataPage.set(data, payloadTx);
        message.setPayload(payloadTx);
        GenericChannel.sendBroadcast(message);
	}

    function onMessage(msg) {
        // Parse the rx payload.
        payloadRx = msg.getPayload();
        
        if (msg.messageId == Ant.MSG_ID_ACKNOWLEDGED_DATA) {
        	Sys.println("received ack");
        	Sys.println(paired);
        	if (payloadRx[0] == 2 && payloadRx[7] == 1 && !paired) { // TODO: Add constant for page
        		Sys.println("ack received");
        		data.pairing = 0;
        		updateBroadcast();
        		pongSensorCallback.invoke();
        		paired = true;
        	}
        }
    }
}