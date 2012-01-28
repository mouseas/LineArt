package {
	
	public class ArtPoint {
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var radius:Number;
		public var rOuter:Number;
		public var rInner:Number;
		public var offset:Number;
		
		public var offsetX:Number = 430;
		public var offsetY:Number = 430;
		
		public function ArtPoint(_rOuter:Number, _rInner:Number, _offset:Number) {
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