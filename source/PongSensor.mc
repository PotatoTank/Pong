using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System as Sys;

class PongSensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 1;
    const PERIOD = 2731;
    const TRANSMISSION_TYPE = 1;
    const RADIO_FREQUENCY = 25;
    
    hidden var deviceNumber;

    hidden var chanAssign;

	hidden var payloadTx;
	hidden var payloadRx;
	hidden var payloadTemp;
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

	function getPaddleTwoY() {
		return payloadRx[3];
	}

	function updateBallPosition(ballX, ballY) {
		data.ballX = ballX;
		data.ballY = ballY;
		
		updateBroadcast();
	}

	function updatePaddleOnePosition(paddleOneY) {
		data.paddleOneY = paddleOneY;
		
		updateBroadcast();
	}

	function updateBroadcast() {
		dataPage.set(data, payloadTx);
        message.setPayload(payloadTx);
        GenericChannel.sendBroadcast(message);
	}

    function onMessage(msg) {
        // Parse the rx payload.
        payloadTemp = msg.getPayload();
        
        if (payloadTemp[0] == 2){
        	payloadRx[0] = payloadTemp[0];
        	payloadRx[1] = payloadTemp[1];
        	payloadRx[2] = payloadTemp[2];
        	payloadRx[3] = payloadTemp[3];
        	payloadRx[4] = payloadTemp[4];
        	payloadRx[5] = payloadTemp[5];
        	payloadRx[6] = payloadTemp[6];
        	payloadRx[7] = payloadTemp[7];
        }
        
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