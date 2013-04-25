package component.starling
{
	import feathers.layout.TiledColumnsLayout;
	
	public class Tile extends Container
	{
		public function Tile()
		{
			super();
			layout = new TiledColumnsLayout();
		}
		
		public function get gap():int
		{
			return TiledColumnsLayout(layout).gap;
		}
		
		public function set gap(value:int):void
		{
			TiledColumnsLayout(layout).gap = value;
		}
		public function get verticalAlign():String
		{
			return TiledColumnsLayout(layout).verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			TiledColumnsLayout(layout).verticalAlign = value;
		}
		public function get horizontalAlign():String
		{
			return TiledColumnsLayout(layout).horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			TiledColumnsLayout(layout).horizontalAlign = value;
		}

		override protected function initialize():void
		{
			super.initialize();
		}
		
		
	}
}