package component
{
	import events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/** 按钮组选中项改变事件 **/
	[Event(name="change",type="events.ComponentEvent")]
	
	/**
	 * 带选中状态的按钮组 
	 * @author 袁浩
	 * 
	 */	
	public class TabButtonBar extends EventDispatcher
	{
		/** 按钮组 */
		protected var _btns:Array = [];
		private var index:int;
		private var moveChange:Boolean;
		/** 当前选中项索引 */
		public function get selectedIndex():int
		{
			return index;
		}
		public function set selectedIndex(value:int):void
		{
			index = value;
			setSelect(_btns[index]);
			setUnSelect(_btns[index]);
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE,index));
		}
		/**
		 *  
		 * @param moveChange 鼠标经过的时候如果鼠标是按下状态是否改变索引
		 * @param args
		 * 
		 */		
		public function TabButtonBar(moveChange:Boolean,...args)
		{
			this.moveChange = moveChange;
			for(var i:int=0;i<args.length;i++)
			{
				_btns.push(args[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,onClick);
				_btns[i].addEventListener(MouseEvent.ROLL_OVER,onRollOver);
				_btns[i].addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			}
			setSelect(_btns[0]);
			setUnSelect(_btns[index]);
			index=0;
		}
		/** 根据索引项获取对应资源 **/
		public function getItemAt($index:int):MovieClip
		{
			return _btns[$index];
		}
		/** 根据资源获取对应索引 **/
		public function getItemIndex($item:MovieClip):int
		{
			return _btns.indexOf($item);
		}
		protected function onClick(event:MouseEvent):void
		{
			if(_btns[index]==event.currentTarget)
			{
				return;
			}
			index = _btns.indexOf(event.currentTarget);
			setSelect(_btns[index]);
			setUnSelect(_btns[index]);
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE,index));
		}		
		protected function onRollOver(event:MouseEvent):void
		{
			if(event.buttonDown && moveChange)
			{
				onClick(event);
				return;
			}
			if(event.currentTarget==_btns[index])
			{
				return;
			}
			event.currentTarget.gotoAndStop("_over");
			dispatchEvent(event);
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			if(event.currentTarget==_btns[index])
			{
				return;
			}
			event.currentTarget.gotoAndStop("_up");
			dispatchEvent(event);
		}
		/** 设置选中 **/
		protected function setSelect(selectedBtn:MovieClip):void
		{
			selectedBtn.gotoAndStop("_select");
		}
		/** 设置弹起 **/
		protected function setUnSelect(selectedBtn:MovieClip):void
		{
			for(var i:int=0;i<_btns.length;i++)
			{
				if(_btns[i] != selectedBtn)
				{
					_btns[i].gotoAndStop("_up");
				}
			}
		}
		public function dispose():void
		{
			for(var i:int=0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,onClick);
				_btns[i].removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
				_btns[i].removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
				_btns[i] = null;
			}
			_btns = null;
		}

	}
}