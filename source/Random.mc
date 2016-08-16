using Toybox.Math;

static class Random 
{	
	static function getRandomNumber(min, max) {
		return Math.rand()%(max - min)+min;
	}
}