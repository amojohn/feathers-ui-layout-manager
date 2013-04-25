package component.starling
{
	import feathers.controls.Button;
	
	import manager.UIManager;
	
	import starling.display.Image;
	
	public class Button extends feathers.controls.Button
	{

		private var _defaultIconName:String;
		private var _defaultSkinName:String;
		private var _downSkinName:String;
		private var _downIconName:String;
		public function Button()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
		}
		public function get downIconName():String
		{
			return _downIconName;
		}

		public function set downIconName(value:String):void
		{
			_downIconName = value;
			var icon:starling.display.Image = new starling.display.Image(UIManager.getInstance().getTexture(value));
			downIcon = icon;
		}

		public function get defaultIconName():String
		{
			return _defaultIconName;
		}

		public function set defaultIconName(value:String):void
		{
			_defaultIconName = value;
			var icon:starling.display.Image = new starling.display.Image(UIManager.getInstance().getTexture(value));
			defaultIcon = icon;
		}

		public function get downSkinName():String
		{
			return _downSkinName;
		}

		public function set downSkinName(value:String):void
		{
			_downSkinName = value;
			var skin:starling.display.Image = new starling.display.Image(UIManager.getInstance().getTexture(value));
			downSkin = skin;
		}

		public function get defaultSkinName():String
		{
			return _defaultSkinName;
		}

		public function set defaultSkinName(value:String):void
		{
			_defaultSkinName = value;
			var skin:starling.display.Image = new starling.display.Image(UIManager.getInstance().getTexture(value));
			defaultSkin = skin;
		}

	}
}