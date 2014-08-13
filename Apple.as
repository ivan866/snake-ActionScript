package {
	
	import flash.display.MovieClip;
	
	public class Apple extends MovieClip {
		
		var xMax = 400;
		var yMax = 400;
		
		function Apple() {
			this.x = Math.floor(Math.random() * (xMax - 20));
			this.y = Math.floor(Math.random() * (yMax - 20));
			
		}
	}
}
