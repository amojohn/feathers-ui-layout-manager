package view
{
	import flash.display.MovieClip;
	
	public class BaseScene extends BaseUI
	{
		public function BaseScene(viewUI:MovieClip)
		{
			super(viewUI);
		}
		protected override function init():void
		{
			if(!viewUI)
			{
				throw new Error(this+"的UI不能为空！");
			}
			addChild(viewUI);
			super.init();
			addEvents();
		}
		protected function addEvents():void
		{
			
		}
		public override function set visible(value:Boolean):void
		{
			if(viewUI)
			{
				viewUI.visible = value;
			}
			super.visible = value;
		}
		
		public override function removeAllChildren():void
		{
			if(viewUI && viewUI.parent)
			{
				viewUI.parent.removeChild(viewUI);
			}
			viewUI.removeChildren();
			super.removeAllChildren();
		}
	}
}