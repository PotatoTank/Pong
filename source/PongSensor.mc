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

    function initialize() {
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
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        searching = true;
        
        data.ballX = 0xFF;
        data.ballY = 0xFF;
        data.paddleOneY = 0xFF;
        data.paddleOneScore = 0;
        data.paddleTwoScore = 0;
        data.state = STATE_PAUSE;
        
        dataPage.set(data, payloadTx);
        
        message.setPayload(payloadTx);
        
        GenericChannel.sendBroadcast(message);
    }

    function closeSensor() {
        GenericChannel.close();
    }

	function update(ballX, ballY) {
		data.ballX = ballX;
		data.ballY = ballY;
		
		dataPage.set(data, payloadTx);
		
		message.setPayload(payloadTx);
		GenericChannel.sendBroadcast(message);
	}

    function onMessage(msg) {
        // Parse the rx payload.
        payloadRx = msg.getPayload();
    }
}