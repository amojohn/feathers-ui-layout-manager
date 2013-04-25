package component.starling
{
	import feathers.controls.ImageLoader;
	
	import manager.UIManager;
	
	import starling.textures.Texture;
	
	public class Image extends ImageLoader
	{
		public function Image()
		{
			super();
		}

		override public function set source(value:Object):void
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