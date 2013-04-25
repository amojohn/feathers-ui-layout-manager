package component.starling
{
	import feathers.layout.HorizontalLayout;
	
	public class HBox extends Container
	{
		public function HBox()
		{
			super();
			layout = new HorizontalLayout();
		}
		
		public function get gap():int
		{
			return HorizontalLayout(layout).gap;
		}
		
		public function set gap(value:int):void
		{
			HorizontalLayout(layout).gap = value;
		}
		public function get verticalAlign():String
		{
			return HorizontalLayout(layout).verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			HorizontalLayout(layout).verticalAlign = value;
		}
		public function get horizontalAlign():String
		{
			return HorizontalLayout(layout).horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			HorizontalLayout(layout).horizontalAlign = value;
		}

		override protected function initialize():void
		{
			super.initialize();
		}
		
		
	}
}