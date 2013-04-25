package view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import config.BaseConfig;
	
	import manager.SourceManager;
	
	public class BaseUI extends Sprite
	{
		/** 背景MC */
		protected var viewUI:MovieClip;
		public function BaseUI(viewUI:MovieClip)
		{
			this.viewUI = viewUI;
			super();
			init();
		}
		/**
		 * 初始化 
		 * 
		 */
		protected function init():void
		{
			
		}
		
		public function dispose(isDel:Boolean=true):void 
		{
			removeAllListener();
			removeAllChildren();
			if(isDel && parent)
			{
				parent.removeChild(this);
			}
			nullAllReference();
		}
		
		public function removeAllChildren():void
		{
			removeChildren();
		}
		
		public function removeAllListener():void
		{
			
		}
		
		public function nullAllReference():void
		{
			viewUI=null;
		}
		public function getConfig(configName:String):BaseConfig
		{
			return SourceManager.getInstance().getConfig(configName);
		}
	}
}