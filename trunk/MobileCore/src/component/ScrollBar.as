package component
{
	
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import swf.ui.ScrollBarBar;
	import swf.ui.ScrollBarBg;
	
	/**
	 * 滚动条 
	 * @author 袁浩
	 * 
	 */
	[Event(name="scroll",type="events.ComponentEvent")]
	public class ScrollBar extends BaseComponent
	{
		/** 底图 */
		protected var _pic:MovieClip;
		/** 拖动按钮 */
		protected var _bar:MovieClip;
		/** 父元素 */
		protected var _parent:DisplayObjectContainer;
		/** 被拖动的元素 */
		protected var _source:Sprite;
		/** 遮罩 */
		protected var _mask:Shape;
		/** 上下滚动高度 */
		protected var _moveCell:int=10;
		/** 拖动条最短缩放长度 */
		protected var _minHeight:int=20;
		/** 当前移动比例 */
		protected var _curPer:Number;
		/** 向右移动多少像素 **/
		private var _moveX:uint = 0;
		/** 滚动条灵活度 **/
		protected var _whellNum:uint;
		private var startPoint:Point;
		protected var parentHeight:Number;
		/** 是否为拖动状态 */
		protected var _isDrag:Boolean=false;
		public function ScrollBar($source:Sprite,$whellNum:uint=10,$bg:*=null)
		{
			super($bg);
			if(!viewUI)
			{
				viewUI=new Sprite();
			}
			_whellNum = $whellNum;
			_source=$source;
			_parent=_source.parent;
			_mask=new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0,0,_parent.width,_parent.height);
			_source.mask=_mask;
			_parent.addChild(_mask);
			
			_pic = new ScrollBarBg();
			parentHeight = _pic.height=_parent.height;
			_moveX = _pic.width;
			viewUI.addChild(_pic);
			_bar = new ScrollBarBar();
			_pic.x = _moveX;
			_bar.x = _moveX;
			viewUI.addChild(_bar);
			//viewUI.scrollRect = new Rectangle(viewUI.x,viewUI.y,viewUI.width,viewUI.height);
			layout();
			_source.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		protected function addToStage(event:Event):void
		{
			_source.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			_source.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_source.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_source.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			startPoint = new Point(_source.mouseX,_source.mouseY);
			_isDrag=true;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			setXY();
		}
		private function setXY():void
		{
			if(!_isDrag)
			{
				return;
			}
			var startLocalPoint:Point = _source.parent.localToGlobal(startPoint);
			var newY:Number = _source.stage.mouseY-startLocalPoint.y;
			_source.y += (newY - _source.y);
			_bar.y = -parentHeight*_source.y/_source.height;
			
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			_isDrag=false;
			_source.y = _source.y > 0?0:_source.y;
			_source.y = _source.y < parentHeight - _source.height?parentHeight - _source.height:_source.y;
			_bar.y = -parentHeight*_source.y/_source.height;
		}
		/** 布局 */
		protected function layout():void
		{
			_bar.y = 0;
			_bar.height = viewUI.height;
		}
		
		public function onScroll(top:Boolean=true):void
		{
			if(top)
			{
				if(!viewUI.visible)
				{
					return;
				}
				_bar.height = viewUI.height*(viewUI.height)/_source.height;
				_bar.height = Math.max(_bar.height,_minHeight);
			}
			else
			{
				_bar.y = 0;
			}
		}
		public override function dispose():void
		{
			while(viewUI.numChildren>0)
			{
				viewUI.removeChildAt(0);
			}
			_source.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			_source.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_source.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_source.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_pic=null;
			_bar=null;
			_source.mask=null;
			_mask=null;
			_source=null;
			_parent=null;
			viewUI=null;
		}
	}
}