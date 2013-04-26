package component.starling
{
	import feathers.controls.ImageLoader;
	
	import manager.UIManager;
	
	import starling.textures.Texture;
	
	public class Image extends ImageLoader
	{
		private var _source:Object;
		public function Image()
		{
			super();
		}
		override public function get source():Object
		{
			return _source;
		}
		override public function set source(value:Object):void
		{
			_source = value;
			setSource(value);
		}
		public function setSource(value:Object):void
		{
			if(value is Texture)
			{
				super.source = value;
			}
			if(value is String)
			{
				var texture:Texture = UIManager.getInstance().getTexture(value as String);
				if(texture)
				{
					super.source = texture;
				}
				else
				{
					super.source = value;
				}
			}
		}
	}
}