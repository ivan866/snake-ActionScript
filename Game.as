package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Game extends MovieClip {
		
		//Worm and apple
		var worm:MovieClip;
		var apple:MovieClip;
		
		//Worm array
		private var wormArray:Array;
		
		//Start velocityX for begin worm movement
		var velocityX:Number = 10;
		var velocityY:Number;
		
		//Text
		var scoreText:TextField;
		var score:Number = 0;
		
		var lifeText:TextField;
		var life:Number = 5;
		
		function Game() {
			Key.initialize(stage);
			
			//Start worm in the center of screen
			wormArray = new Array();
			worm = new Worm();
			wormArray.push(worm);
			addChild(worm);
			
			apple = new Apple();
			addChild(apple);
			
			var tf:TextFormat = new TextFormat();
			tf.size = 15;
			tf.bold = true;
			tf.color = 0xB8FAB7;
			tf.font = "Stencil Std";
			
			scoreText = new TextField();
			scoreText.defaultTextFormat = tf;
			scoreText.text = "Score: "+ score;
			addChild(scoreText);
			
			lifeText = new TextField();
			lifeText.x = 320;
			lifeText.defaultTextFormat = tf;
			lifeText.text = "Lifes: "+ life;
			addChild(lifeText);
			
			addEventListener("enterFrame", initGame);
		}
		
		function initGame(e:Event) {
			
			//Worm movement Loop
			//To the END-BEGINNING, cause we want to put the position i-1 to our last "piece of worm"
			for (var i = wormArray.length - 1; i>=1; i--) {
				wormArray[i].x = wormArray[i-1].x;
				wormArray[i].y = wormArray[i-1].y;		
			}
			
			//I GET IT!!!! HYPE MOMENT...
			if (wormArray[0].hitTestObject(apple)) {
				this.removeChild(apple);
				apple = null;
				
				//count score
				score++;
				
				var newWorm = new Worm();
				newWorm.x = wormArray[wormArray.length-1].x;
				newWorm.y = wormArray[wormArray.length-1].y;
				wormArray.push(newWorm);
				addChild(newWorm);
				
				//Create new Apple in != position, Of course!
				apple = new Apple();
				addChild(apple);
			}
			
			//Checking collision beetwen its own body
			//Be careful here! If the snack change the position and the head touch body its gonna take off a life
			//that includes sudden changes in direction of the worm
			//that mean, if head go right and suddenly turn left and the rest of the body are in the same X position
			//than the worm head, its mean life--!!!
			//If you turn head and touches all parts of worm's body, you lost and the game will restart.
			
			  for (var i = wormArray.length - 1; i> 1; i--) {
                if ((wormArray[0].x == wormArray[i].x) && (wormArray[0].y == wormArray[i].y)) {
               		lifeManager();
                    break;
                }
            }
			
			//Update TextFields
			scoreText.text = "Score: "+ score;
			lifeText.text = "Lifes: "+ life;
			
			//Function to move the first piece of worm (Wormhead)
			move();
		}
		
		public function lifeManager() {
			life--;
			
			if(life < 0) {
				resetGame();
			}
		}
		
		public function resetGame() {
			//Remove actual apple to start again
			this.removeChild(apple);
			
			//Now add new apples to stage
			apple = new Apple();
			addChild(apple);
			
			//remove snake body except first component (head)
			for (var i = wormArray.length - 1; i >= 1; i--) {
				this.removeChild(wormArray[i]);
				//splice(start,end); end not included
				wormArray.splice(i, 1);
			}
			
			//Remember restore score and life texts!
			life = 5;
			score = 0;
		}
		
		function move() {
			//If the worm are in the corners, it reappears on the front side
			if (wormArray[0].x > (400 - worm.width/2)) {
				wormArray[0].x = 0 + worm.width/2;
			}
			if (wormArray[0].x < (0 + worm.width/2)) {
				wormArray[0].x = 400 - worm.width/2;
			}
			if (wormArray[0].y > 400 - worm.height/2 ) {
				wormArray[0].y = 0 + worm.height/2 ;
			}
			if (wormArray[0].y < 0 + worm.height/2) {
				wormArray[0].y = 400 - worm.height/2;
			}
			
			//Manage keyboard inputs
			if(Key.isDown(Keyboard.D)) {
				velocityX = 10;
				velocityY = 0;
			}
			if(Key.isDown(Keyboard.A)) {
				velocityX = -10;
				velocityY = 0;
			}
			if(Key.isDown(Keyboard.W)) {
				velocityX = 0;
				velocityY = -10;
			}
			if(Key.isDown(Keyboard.S)) {
				velocityX = 0;
				velocityY = 10;
			}
			
			//Wormhead movement
			wormArray[0].x += velocityX;
			wormArray[0].y += velocityY;
		}
	}
}
