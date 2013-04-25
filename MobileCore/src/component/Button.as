package component
{

	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import swf.ui.ButtonBg;
	
	import utils.StringUtil;
	
	/**
	 * 按钮组件 
	 * 最多4个字的标准按钮或者图形按钮
	 * @author 袁浩
	 * 
	 */
	public class Button extends BaseComponent
	{
		/** 按钮标签 */
		private var _label:String;
		
		public function Button($bg:InteractiveObject=null,$label:String="",toolTipStr:String="",useHandCursor:Boolean=false)
		{
			super($bg);
			_label=$label;
			if(!$bg)
			{
				viewUI = new ButtonBg();
			}
			if(viewUI is MovieClip)
			{
				if(viewUI.txt)
				{
					if(StringUtil.trim($label)!=''&&$label != null)
					{
						viewUI.txt.text=_label;
					}
					viewUI.txt.mouseEnabled=false;
				}
				viewUI.stop();
				viewUI.buttonMode=true;
				viewUI.useHandCursor = useHandCursor;
			}
			viewUI.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			dispatchEvent(event);
		}
		
		public function set label(value:String):void
		{
			viewUI.txt.text=value;
		}
		
		
		public override function dispose():void
		{
			viewUI.removeEventListener(MouseEvent.CLICK,onClick);
			super.dispose();
		}
	}
}