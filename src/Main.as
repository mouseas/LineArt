package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.net.FileReference;
	import flash.utils.*;
	import flash.geom.*;
	import com.adobe.images.PNGEncoder;
	
	/**
	 * ...
	 * @author Martin Carney
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../lib/source000.jpg")]public var sourceImage000:Class;
		[Embed(source = "../lib/source001.jpg")]public var sourceImage001:Class;
		[Embed(source = "../lib/source002.jpg")]public var sourceImage002:Class;
		[Embed(source = "../lib/source003.jpg")]public var sourceImage003:Class;
		[Embed(source = "../lib/source004.jpg")]public var sourceImage004:Class;
		
		public var colorBitmapData:BitmapData;
		
		public var myBitmapData:BitmapData;
		
		public var myBitmap:Bitmap;
		
		public var drawLayer:Sprite;
		
		public var points:Array;
		
		public var time:Number = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Pick a random source image.
			var whichSource:int = (int)(Math.random() * 5);
			trace ("Source was: " + whichSource);
			var pic:Bitmap;
			if (whichSource == 0) {
				pic = new sourceImage000;
			} else if (whichSource == 1) {
				pic = new sourceImage001;
			} else if (whichSource == 2) {
				pic = new sourceImage002;
			} else if (whichSource == 3) {
				pic = new sourceImage003;
			} else if (whichSource == 4) {
				pic = new sourceImage004;
			} else {
				pic = new sourceImage000;
				trace("whichSource out of range: " + whichSource);
			}
			
			colorBitmapData = pic.bitmapData;
			pic = null;
			//addChild(new Bitmap(colorBitmapData));
			
			myBitmapData = new BitmapData(860, 860, true, 0x000000);
			myBitmap = new Bitmap(myBitmapData, "auto", true);
			addChild(myBitmap);
			
			drawLayer = new Sprite();
			
			var drawTimer:Timer = new Timer(100, 0);
			drawTimer.addEventListener("timer", drawToBitmapData);
			drawTimer.start();
			drawTimer = null;
			
			points = new Array();
			
			// Mess with these values to get different draw patterns.
			points.push(new ArtPoint(200, 100, 0));  // Original values: 200, 100, 0
			points.push(new ArtPoint(0, 200, 420));  // Original values: 0, 200, 420 (circular path with radius 420)
			points.push(new ArtPoint(100, 100, 50));  // Original values: 100, 100, 50
			
			//Best not mess with these values; this pulls from the color image and will always fit on the bitmap.
			points.push(new ArtPoint(0, 200, Math.min(colorBitmapData.width, colorBitmapData.height) / 2));
			points.push(new ArtPoint(100, 100, Math.min(colorBitmapData.width, colorBitmapData.height) / 18));
			
			points[0].offsetX = myBitmapData.width / 2;
			points[0].offsetY = myBitmapData.height / 2;
			points[1].offsetX = myBitmapData.width / 2;
			points[1].offsetY = myBitmapData.height / 2;
			points[2].offsetX = myBitmapData.width / 2;
			points[2].offsetY = myBitmapData.height / 2;
			
			points[3].offsetX = colorBitmapData.width / 2;
			points[3].offsetY = colorBitmapData.height / 2;
			points[4].offsetX = colorBitmapData.width / 2;
			points[4].offsetY = colorBitmapData.height / 2;
			
			
			addEventListener(Event.ENTER_FRAME, drawLines);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, saveResult);
		}
		
		private function drawToBitmapData(event:TimerEvent):void {
			myBitmapData.draw(drawLayer);
			
			drawLayer.graphics.clear();
			
		}
		
		private function saveResult(event:KeyboardEvent):void {
			trace ("keyboard event");
			if (event.keyCode == Keyboard.SPACE) {
				
				var scale:int = 3; // Scale multiplier of result image.
				
				var resultBMD:BitmapData = new BitmapData(myBitmapData.width * scale, myBitmapData.height * scale, true, 0x000000);
				
				var transMatrix:Matrix = new Matrix(scale, 0, 0, scale, 0, 0);
				var rect:Rectangle = new Rectangle(0, 0, myBitmapData.width * scale, myBitmapData.height * scale);
				resultBMD.draw(myBitmapData, transMatrix, null, null, rect, true);
				
				var bytes:ByteArray = PNGEncoder.encode(resultBMD);
				
				var fileRef:FileReference = new FileReference();
				fileRef.save(bytes, "result.png");
			} else {
				trace ("Key was pressed, but not SPACEBAR.");
			}
		}
		
		private function drawLines(e:Event):void {
			// Add a multiplier to "time" to get a point to move faster or slower than the others. 
			// points[1].setPos(time * 1.2); is a good one to try.
			points[0].setPos(time);
			points[1].setPos(time);
			points[2].setPos(time);
			points[3].setPos(time);
			points[4].setPos(time);
			
			var color1:Number = colorBitmapData.getPixel((int)(points[3].x), (int)(points[3].y));
			var color2:Number = colorBitmapData.getPixel((int)(points[4].x), (int)(points[4].y));
			
			drawLayer.graphics.moveTo(points[0].x, points[0].y);
			drawLayer.graphics.lineStyle(10, color1, 0.1);
			drawLayer.graphics.lineTo(points[1].x, points[1].y);
			drawLayer.graphics.lineStyle(10, color2, 0.1);
			drawLayer.graphics.lineTo(points[2].x, points[2].y);
			
			time += .01;
		}
		
	}
	
}