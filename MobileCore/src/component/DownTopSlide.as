package   component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 滑动效果
	 * @author Tiger 1748055943@qq.com
	 * 2012/12/27 10:39
	 */
	public class DownTopSlide
	{
		private var fTarget:DisplayObject;
		private var fTargetMask:Sprite;
		private var mcScroll:ShowRScrollBar;
		
		private var accDecay:uint = 2;				//运动的平滑程度，1到10， 10为不缓动，越大越生硬
		private var outBoundResist:uint = 7;			//超出范围时的阻力，大于1的整数，等于1时无阻力
		private var slideDecay:uint = 95;			//滑动速度衰减参数,1到100，越小速度降低越快
		
		private var slidVel:int;					//滑动时的速度 
		
		private var isMouseDown:Boolean = false;	//鼠标是否按下
		private var isTweening:Boolean = false;		//是否在运动中
		
		private var offset:int = 10;
		private var topY:int = 0;
		private var downY:int = 0;
		private var newY:int = 0;
		private var oldY:int = 0;
		
		private var sContainerPoint:Point;
		private var sMousePoint:Point;
		
		public var onMouseClickHandler:Function;
		public var onMouseDownHandler:Function;
		public var onMouseUpHandler:Function;
		public var onMouseMoveHandler:Function;
		
		public function DownTopSlide() 
		{
		}
		
		public function setData(target:DisplayObject, slidRec:Rectangle, maskRec:Rectangle):void
		{
			fTarget = target;
			
			//创建滑动区域
			fTargetMask = getMask(slidRec);
			fTargetMask.x = slidRec.x;
			fTargetMask.y = slidRec.y;
			target.parent.addChildAt(fTargetMask, target.parent.getChildIndex(target) + 1);
			//创建滚动条
			mcScroll = new ShowRScrollBar();
			mcScroll.x = target.x + target.width;
			mcScroll.y = target.y;
			target.parent.addChild(mcScroll);
			mcScroll.setData(target, maskRec.width, maskRec.height);
			
			init();
		}
		/**
		 * 创建滑动区域
		 * @param	rec
		 * @return
		 */
		private function getMask(rec:Rectangle):Sprite
		{
			var mc:Sprite = new Sprite();
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0, 0);
			bg.graphics.drawRect(0,0, rec.width, rec.height);
			bg.graphics.endFill();
			mc.addChild(bg);
			return mc;
		}
		
		private function init():void
		{
			
			sContainerPoint = new Point();
			sMousePoint = new Point();
			
			topY = fTargetMask.height - fTarget.height - offset;
			downY = offset;
			newY = fTarget.y;
						
			initListiner();
		}
		
		private function initListiner():void
		{
			fTargetMask.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * 帧更新
		 */
		public function frameUpdate():void
		{
			if (isTweening) return;
			isTweening = true;
			fTargetMask.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			fTargetMask.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			
			isMouseDown = true;
			
			sContainerPoint.x = fTarget.x;
			sContainerPoint.y = fTarget.y;
			
			sMousePoint.x = fTargetMask.mouseX;
			sMousePoint.y = fTargetMask.mouseY;
			if(onMouseDownHandler)
			{
				onMouseDownHandler(sMousePoint.x, sMousePoint.y);
			}
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//fTargetMask.removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			fTargetMask.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			fTargetMask.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//fTargetMask.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			
			//trace("mouseDown");
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			isMouseDown = false;
			
			slidVel = fTarget.y - oldY;
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			if(onMouseUpHandler)
			{
				onMouseUpHandler(fTargetMask.mouseX, fTargetMask.mouseY);
			}
			if (Math.abs(sMousePoint.y - fTargetMask.mouseY) <= 50 && Math.abs(sMousePoint.x - fTargetMask.mouseX) <= 50 && sContainerPoint.x == fTarget.x && sContainerPoint.y == fTarget.y) 
			{
				//trace(" --------------------- ");
				if(onMouseClickHandler)
				{
					onMouseClickHandler(sMousePoint.x, sMousePoint.y);
				}
			}
		}
		
		
		private function enterFrameHandler(e:Event):void
		{
			
			var cy:int = fTarget.y;
			oldY = cy;
			if (isMouseDown) {
				
				var dy:int = fTargetMask.mouseY - sMousePoint.y + sContainerPoint.y;
				
				if (cy > downY) {
					newY = downY + (dy - downY) / outBoundResist;
				}else if (cy < topY) {
					newY = topY + (dy - topY) / outBoundResist;
				}else {
					newY = dy;
				}
			}else {
				
				if (newY > downY) {
					newY = downY;
					slidVel = 0;
				}else if (newY < topY) {
					newY = topY;
					slidVel = 0;
				}else {
					slidVel *= slideDecay / 100;
					if (Math.abs(slidVel) < 2) slidVel = 0;
				}
				
				newY += slidVel;
			}
			
			fTarget.y += (newY - cy) * accDecay / 10;
			
			if (Math.abs(fTarget.y - newY) < 0.02) stopEnterFrameHandler();
			
			//刷新滚动条
			mcScroll.freshBarPos();
		}
		
		private function stopEnterFrameHandler():void
		{
			fTarget.y = newY;
			isTweening = false;
			fTargetMask.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function mouseMoveHandler(e:Event):void
		{
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			frameUpdate();
			if(onMouseMoveHandler)
			{
				onMouseMoveHandler(fTargetMask.mouseX, fTargetMask.mouseY);
			}
		}
		public function dispose():void
		{
			fTargetMask.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			fTargetMask.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			fTargetMask.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			fTarget = null;
			if(fTargetMask.parent)
			{
				fTargetMask.parent.removeChild(fTargetMask);
			}
			fTargetMask = null;
			mcScroll.dispose();
			mcScroll = null;
			sContainerPoint = null;
			sMousePoint = null;
			onMouseClickHandler = null;
			onMouseDownHandler = null;
			onMouseUpHandler = null;
			onMouseMoveHandler = null;
		}
	}
}