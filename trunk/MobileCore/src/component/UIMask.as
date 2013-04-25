package component
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 绘制一个遮挡层 
	 * @author 袁浩
	 * 
	 */
	public class UIMask extends Sprite
	{
		private var _color:uint;
		private var _maskalpha:Number;
		public function UIMask(width:Number,height:Number,color:uint=0,alpha:Number=0.4)
		{
			super();
			_color = color;
			_maskalpha = alpha;
			graphics.beginFill(color,alpha);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}

		public function get maskalpha():Number
		{
			return _maskalpha;
		}

		public function get color():uint
		{
			return _color;
		}
		public function update(rectangle:Rectangle):void
		{
			graphics.clear();
			graphics.beginFill(color,maskalpha);
			graphics.drawRect(rectangle.x,rectangle.y,rectangle.width,rectangle.height);
			graphics.endFill();
		}
	}
}