package component
{
	import events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 单选按钮 
	 * @author 袁浩
	 * 
	 */
	public class RadioButton extends BaseComponent
	{
		private var _isSelect:Boolean;
		
		public function RadioButton($bg:MovieClip,$label:String="",$isSelect:Boolean=false)
		{
			super($bg);
			//_bg.txt.text=$label;
			isSelect=$isSelect;
			viewUI.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		/** 是否选中 */
		public function get isSelect():Boolean
		{
			return _isSelect;
		}
		
		/**
		 * @private
		 */
		public function set isSelect(value:Boolean):void
		{
			_isSelect = value;
			viewUI.point.visible=_isSelect;
		}
		
		private function onClick(event:MouseEvent):void
		{
			isSelect=true;
			dispatchEvent(event);
		}
		
		
	}
}