using Toybox.Math;

//! Class to generate a random integer between min and max values.
static class Random {	
	static function getRandomNumber(min, max) {
		return Math.rand()%(max - min)+min;
	}
}