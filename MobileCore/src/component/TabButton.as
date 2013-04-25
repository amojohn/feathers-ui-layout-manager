package component
{
	
	import events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 有选中状态的按钮 
	 * @author 袁浩
	 * 
	 */
	public class TabButton extends BaseComponent
	{
		/** 当前选中的 */
		private var _select:MovieClip;
		
		public function TabButton(mc:MovieClip=null)
		{
			super(null);
			_select=mc;
			if(mc)
				mc.gotoAndStop("_select");
		}
		/** 获取选中的 */
		public function get select():MovieClip
		{
			return _select;
		}
		/** 渲染影片剪辑 */
		public function render(mc:MovieClip):void
		{
			mc.addEventListener(MouseEvent.CLICK,onClick);
			mc.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			mc.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		/** 渲染逆操作 */
		public function unrender(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.CLICK,onClick);
			mc.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			mc.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(_select)
			{
				_select.gotoAndStop("_up");
			}
			_select=event.currentTarget as MovieClip;
			_select.gotoAndStop("_select");
			dispatchEvent(event);
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			if(event.currentTarget!=_select)
				event.currentTarget.gotoAndStop("_over");
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			if(event.currentTarget!=_select)
				event.currentTarget.gotoAndStop("_up");
		}
	}
}