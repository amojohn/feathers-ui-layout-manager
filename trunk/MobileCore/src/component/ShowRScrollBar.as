package component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import swf.ui.ScrollBarBar;
	import swf.ui.ScrollBarBg;
	
	/**
	 * 只用于外部更新的简单滚动条,用于垂直滚动，放在被控对象右侧
	 * 2012/12/27 14:37
	 */
	public class ShowRScrollBar extends Sprite
	{
		//滑块
		public var scrollBar:Sprite = new ScrollBarBar();
		//滚动条背景
		public var scrollBg:Sprite = new ScrollBarBg();
		
		//滑块滚动范围
		private var barHeight:Number;
		//高度比例
		private var hRatio:Number;
		//被控对象移动范围
		private var scrollHeight:Number;
		//总比例
		private var showRatio:Number;
		
		private var new_y:Number;
		private var drag_area:Rectangle;
		
		private var showTarget:DisplayObject;
		private var showMask:Sprite;
		
	
		public function ShowRScrollBar()
		{
			addChild(scrollBg);
			addChild(scrollBar);
		}
		
		/**
		 * 参数说明
		 * @param	targetName被控对象名字
		 * @param	maskName遮罩名字
		 * @param	speed速度()
		 */
		public function setData(target:DisplayObject, maskWidth:Number,maskHeight:Number):void
		{
			scrollBg.height = maskHeight;
			showTarget = target;
			showMask = createMask(maskWidth, maskHeight);
			parent.addChildAt(showMask, parent.getChildIndex(showTarget) + 1);
			
			initSet();
		}
		
		private function createMask(dw:Number, dh:Number):Sprite
		{
			var mc:Sprite = new Sprite();
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0, 0);
			bg.graphics.drawRect(0, 0, dw, dh);
			bg.graphics.endFill();
			mc.addChild(bg);
			return mc;
		}
		
		//设置
		private function initSet():void
		{
			showTarget.mask = showMask;
			showTarget.x = showMask.x;
			showTarget.y = showMask.y;
			
			scrollBar.x = scrollBg.x;
			scrollBar.y = scrollBg.y;
			
			hRatio = showMask.height / showTarget.height;
			scrollBar.height = scrollBg.height * hRatio;
			setBarscale9Grid();
			
			barHeight = scrollBg.height - scrollBar.height;
			scrollHeight = showTarget.height - showMask.height;
			showRatio = scrollHeight / barHeight * 1.01;
			
			drag_area = new Rectangle(0, 0, 0, barHeight);
			
			//显示隐藏
			(scrollHeight <= 0)?hide():show();
		}
		
		
		//设置9切片模式
		private function setBarscale9Grid():void
		{
			//var tHeight:Number = scrollBar.height / 3;
			//var tWidth:Number = scrollBar.width / 3;
			//var _scale9Grid:Rectangle = new Rectangle(tWidth, tHeight, tWidth, tHeight);
			//scrollBar.scale9Grid =  _scale9Grid;
		}

		
		//显示隐藏
		private function show():void
		{
			visible = true;
		}
		private function hide():void
		{
			visible = false;
		}
		
		
		/**
		 * 当被控对象高度变化时调用刷新
		 */
		public function freshData():void
		{
			hRatio = showMask.height / showTarget.height;
			scrollBar.height = scrollBg.height * hRatio;
			
			scrollHeight = showTarget.height - showMask.height;
			showRatio = scrollHeight / barHeight * 1.01;
			drag_area = new Rectangle(0, 0, 0, barHeight);
			(scrollHeight <= 0)?hide():show();
		}
		
		//刷新滚动条的位置
		public function freshBarPos():void
		{
			scrollBar.y = scrollBg.y +(showMask.y - showTarget.y) / showRatio;
		}
		public function dispose():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
			removeChildren();
			scrollBar = null;
			scrollBg = null;
			drag_area = null;
			showTarget = null;
			showMask.parent.removeChild(showMask);
			showMask = null;
		}
	}
}