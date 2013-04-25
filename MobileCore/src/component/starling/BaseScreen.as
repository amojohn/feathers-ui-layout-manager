package component.starling
{
	import flash.utils.Dictionary;
	
	import config.BaseConfig;
	
	import feathers.controls.Screen;
	
	import manager.SourceManager;
	import manager.UIManager;
	
	import starling.display.DisplayObject;
	
	public class BaseScreen extends Screen
	{
		private var _layout:String='auto';
		private var layoutFuns:Dictionary = new Dictionary();
		private var _gap:int;
		public function BaseScreen():void
		{
			layoutFuns['auto'] = layoutAuto;
			layoutFuns['vertical'] = layoutVertical;
			layoutFuns['horizontal'] = layoutHorizontal;
			super();
		}

		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			_gap = value;
		}

		public function get layout():String
		{
			return _layout;
		}
		public function set layout(value:String):void
		{
			_layout = value;
		}

		override protected function initialize():void
		{
			UIManager.getInstance().addChildByUIName(this);
		}
		override protected function draw():void
		{
			layoutFuns[layout]();
		}
		public function updateChildren():void
		{
			layoutFuns[layout]();
		}
		protected function layoutAuto():void
		{
			
		}
		protected function layoutVertical():void
		{
			var h:Number = 0;
			for (var i:int = 0; i < numChildren; i++) 
			{
				getChildAt(i).y = h;
				h += getChildAt(i).height * getChildAt(i).scaleY + gap;
			}
		}
		protected function layoutHorizontal():void
		{
			var w:Number = 0;
			for (var i:int = 0; i < numChildren; i++) 
			{
				getChildAt(i).x = w;
				w += getChildAt(i).width * getChildAt(i).scaleX + gap;
			}
		}
		public function getConfig(configName:String):BaseConfig
		{
			return SourceManager.getInstance().getConfig(configName);
		}
		override public function dispose():void
		{
			layoutFuns = null;
			UIManager.getInstance().removeChildByName(this);
			var textureNames:Array = UIManager.getInstance().getTextureNames(name);
			if(textureNames && !(this is BaseLoadScreen))
			{
				for (var i:int = 0; i < textureNames.length; i++) 
				{
					UIManager.getInstance().assets.removeTexture(textureNames[i]);
				}
			}
			super.dispose();
		}
		public function getChildByXML(childName:String):DisplayObject
		{
			return UIManager.getInstance().getChildByName(childName,this);
		}
		public function addClass(...args):void{};
	}
}