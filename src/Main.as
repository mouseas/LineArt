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
		
		public var time:Number = 0.5;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			// Pick a random source image.
			var whichSource:int = (int)(Math.random() * 5);
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
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
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
			points.push(new ArtPoint(50, 200, 100, 0));
			points.push(new ArtPoint(100, 0, 200, 420));
			points.push(new ArtPoint(150, 100, 100, 50));
			
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
				var resultBMD:BitmapData = new BitmapData(myBitmapData.width * 3, myBitmapData.height * 3, true, 0x000000);
				
				var transMatrix:Matrix = new Matrix(3, 0, 0, 3, 0, 0);
				var rect:Rectangle = new Rectangle(0, 0, myBitmapData.width * 3, myBitmapData.height * 3);
				resultBMD.draw(myBitmapData, transMatrix, null, null, rect, true);
				
				var bytes:ByteArray = PNGEncoder.encode(resultBMD);
				
				var fileRef:FileReference = new FileReference();
				fileRef.save(bytes, "result.jpg");
			} else {
				trace ("Key was pressed, but not SPACEBAR.");
			}
		}
		
		private function drawLines(e:Event):void {
			points[0].setPos(time);
			points[1].setPos(time * 1.2);
			points[2].setPos(time);
			
			var color1:Number = colorBitmapData.getPixel((int)(points[1].x), (int)(points[1].y));
			var color2:Number = colorBitmapData.getPixel((int)(points[2].x), (int)(points[2].y));
			
			drawLayer.graphics.moveTo(points[0].x, points[0].y);
			drawLayer.graphics.lineStyle(10, color1, 0.1);
			drawLayer.graphics.lineTo(points[1].x, points[1].y);
			drawLayer.graphics.lineStyle(10, color2, 0.1);
			drawLayer.graphics.lineTo(points[2].x, points[2].y);
			
			time += .01;
		}
		
	}
	
}