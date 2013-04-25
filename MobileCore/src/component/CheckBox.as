package component
{
	import events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 多选组件 
	 * @author 袁浩
	 * 
	 */
	public class CheckBox extends BaseComponent
	{
		private var _isSelect:Boolean;
		
		public function CheckBox($bg:MovieClip=null,$label:String="",$isSelect:Boolean=false)
		{
			super($bg);
			viewUI.txt.text=$label;
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
			viewUI.gougou.visible=_isSelect;
		}
		
		public function get label():String
		{
			return viewUI.txt.text;
		}
		
		private function onClick(event:MouseEvent):void
		{
			isSelect=!_isSelect;
			dispatchEvent(event);
		}

	}
}