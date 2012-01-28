package {
	
	public class ArtPoint {
		
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var rOuter:Number;
		public var rInner:Number;
		public var offset:Number;
		
		public static const centerX:Number = 430;
		public static const centerY:Number = 430;
		public static const offsetX:Number = 430;
		public static const offsetY:Number = 430;
		
		public function ArtPoint(_radius:Number, _rOuter:Number, _rInner:Number, _offset:Number) {
			radius = _radius;
			rOuter = _rOuter;
			rInner = _rInner;
			offset = _offset;
			
		}
		
		public function setPos(time:Number):void {
			x = offsetX + (rOuter + rInner) * Math.cos(time) - (rInner + offset) * Math.cos(((rOuter + rInner) / rInner) * time);
			y = offsetX + (rOuter + rInner) * Math.sin(time) - (rInner + offset) * Math.sin(((rOuter + rInner) / rInner) * time);
		}
		
		
		
	}
	
}