package component.starling
{
	import feathers.layout.VerticalLayout;
	
	public class VBox extends Container
	{
		public function VBox()
		{
			super();
			layout = new VerticalLayout();
		}
		
		public function get gap():int
		{
			return VerticalLayout(layout).gap;
		}
		
		public function set gap(value:int):void
		{
			VerticalLayout(layout).gap = value;
		}
		public function get verticalAlign():String
		{
			return VerticalLayout(layout).verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			VerticalLayout(layout).verticalAlign = value;
		}
		public function get horizontalAlign():String
		{
			return VerticalLayout(layout).horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			VerticalLayout(layout).horizontalAlign = value;
		}

		override protected function initialize():void
		{
			super.initialize();
		}
		
		
	}
}