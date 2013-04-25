package component
{
	import flash.events.MouseEvent;

	/**
	 * 单选按钮组 
	 * @author 袁浩
	 * 
	 */
	public class RadioButtonGroup extends BaseComponent
	{
		/** 按钮数组 */
		private var _btns:Array;
		/** 当前选中的 */
		private var _select:RadioButton;
		
		public function RadioButtonGroup()
		{
			super(null);
			_btns=[];
		}
		
		public function get selectedRadio():RadioButton
		{
			return _select;
		}
		
		/** 添加按钮 */
		public function addButton(... args):void
		{
			for(var i:int=0;i<args.length;i++)
			{
				var rad:RadioButton=args[i];
				_btns.push(rad);
				if(i==0)
				{
					rad.isSelect=true;
				}
				rad.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			for(var i:int=0;i<_btns.length;i++)
			{
				if(_btns[i]==event.currentTarget)
				{
					_select=_btns[i];
				}
				else
				{
					_btns[i].isSelect=false;
				}
			}
			dispatchEvent(event);
		}
		
		override public function dispose():void
		{
			for (var i:int = 0; i < _btns.length; i++) 
			{
				_btns[i].addEventListener(MouseEvent.CLICK,onClick);
				_btns[i].dispose();
			}
			_btns = null;
			_select = null;
			super.dispose();
		}
		
		
	}
}