package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Martin Carney
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../lib/source.jpg")]public var sourceImage:Class;
		
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
			removeEventListener(Event.ADDED_TO_STAGE, init);
			colorBitmapData = new BitmapData(960, 960, true, 0x000000);
			var pic:Bitmap = new sourceImage();
			var bmd:BitmapData = pic.bitmapData
			colorBitmapData.draw(bmd);
			pic = null;
			bmd = null;
			
			myBitmapData = new BitmapData(960, 960, true, 0x000000);
			myBitmap = new Bitmap(myBitmapData, "auto", true);
			addChild(myBitmap);
			
			drawLayer = new Sprite();
			
			var drawTimer:Timer = new Timer(100, 0);
			drawTimer.addEventListener("timer", drawToBitmapData);
			drawTimer.start();
			drawTimer = null;
			
			points = new Array();
			points.push(new ArtPoint(50, 200, 100, 0));
			points.push(new ArtPoint(100, 0, 200, 480));
			points.push(new ArtPoint(150, 100, 100, 50));
			
			addEventListener(Event.ENTER_FRAME, drawLines);
		}
		
		private function drawToBitmapData(event:TimerEvent):void {
			myBitmapData.draw(drawLayer);
			
		}
		
		private function drawLines(e:Event):void {
			points[0].setPos(time);
			points[1].setPos(time);
			points[2].setPos(time);
			
			var color1:Number = colorBitmapData.getPixel((int)(points[1].x), (int)(points[1].y));
			var color2:Number = colorBitmapData.getPixel((int)(points[2].x), (int)(points[2].y));
			
			drawLayer.graphics.clear();
			
			drawLayer.graphics.moveTo(points[0].x, points[0].y);
			drawLayer.graphics.lineStyle(10, color1, 0.1);
			drawLayer.graphics.lineTo(points[1].x, points[1].y);
			drawLayer.graphics.lineStyle(10, color2, 0.1);
			drawLayer.graphics.lineTo(points[2].x, points[2].y);
			
			time += .01;
		}
		
	}
	
}