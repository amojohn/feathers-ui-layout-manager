package component.starling
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import starling.display.DisplayObject;

	/**
	 * 如果位置发生改变，那么不支持子元件的滤镜 
	 * @author user
	 * 
	 */	
	public class Container extends ScrollContainer
	{
		private var _scaleMode:String = 'none';
		private var scaleModeFuns:Dictionary = new Dictionary();
		private var _parentHorizontalAlign:String = 'none';
		private var parentHorizontalAlignFuns:Dictionary = new Dictionary();
		private var _parentVerticalAlign:String = 'none';
		private var parentVerticalAlignFuns:Dictionary = new Dictionary();
		private var _childCenter:Boolean;
		private var _childMiddle:Boolean;
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		public function Container()
		{
			scaleModeFuns['horizontal'] = scaleModeHorizontal;
			scaleModeFuns['vertical'] = scaleModeVertical;
			scaleModeFuns['horizontalOnly'] = scaleModeHorizontalOnly;
			scaleModeFuns['verticalOnly'] = scaleModeVerticalOnly;
			scaleModeFuns['auto'] = scaleModeAuto;
			scaleModeFuns['none'] = scaleModeNone;
			scaleModeFuns['full'] = scaleModeFull;
			parentHorizontalAlignFuns['none'] = parentHorizontalAlignNone;
			parentHorizontalAlignFuns['center'] = parentHorizontalAlignCenter;
			parentHorizontalAlignFuns['left'] = parentHorizontalAlignLeft;
			parentHorizontalAlignFuns['right'] = parentHorizontalAlignRight;
			parentVerticalAlignFuns['none'] = parentVerticalAlignNone;
			parentVerticalAlignFuns['top'] = parentVerticalAlignTop;
			parentVerticalAlignFuns['middle'] = parentVerticalAlignMiddle;
			parentVerticalAlignFuns['bottom'] = parentVerticalAlignBottom;
			super();
			scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
		}

		public function get childMiddle():Boolean
		{
			return _childMiddle;
		}

		public function set childMiddle(value:Boolean):void
		{
			_childMiddle = value;
		}

		public function get percentHeight():Number
		{
			return _percentHeight;
		}

		public function set percentHeight(value:Number):void
		{
			_percentHeight = value;
		}

		public function get percentWidth():Number
		{
			return _percentWidth;
		}

		public function set percentWidth(value:Number):void
		{
			_percentWidth = value;
		}

		/**
		 * 子元件的x坐标基线 ,仅在添加时候有用
		 */
		public function get childCenter():Boolean
		{
			return _childCenter;
		}

		/**
		 * @private
		 */
		public function set childCenter(value:Boolean):void
		{
			_childCenter = value;
		}

		/**
		 * 在父容器中纵向布局的属性，x属性为偏移量，具体值为middle、top、bottom
		 * @return 
		 * 
		 */
		public function get parentVerticalAlign():String
		{
			return _parentVerticalAlign;
		}

		public function set parentVerticalAlign(value:String):void
		{
			_parentVerticalAlign = value;
		}

		/**
		 * 在父容器中横向布局的属性，x属性为偏移量，具体值为center、left、right 
		 * @return 
		 * 
		 */
		public function get parentHorizontalAlign():String
		{
			return _parentHorizontalAlign;
		}

		public function set parentHorizontalAlign(value:String):void
		{
			_parentHorizontalAlign = value;
		}
		protected function parentVerticalAlignTop():void
		{
			
		}
		protected function parentVerticalAlignMiddle():void
		{
			if(parent.width && parent.height && width && height)
			{
				y += parent.height * parent.scaleY/2 - height * scaleY/2;
			}
		}
		protected function parentVerticalAlignBottom():void
		{
			if(parent.width && parent.height && width && height)
			{
				y += parent.height * parent.scaleY- height * scaleY;
			}
		}
		protected function parentHorizontalAlignLeft():void
		{
			
		}
		protected function parentHorizontalAlignRight():void
		{
			if(parent.width && parent.height && width && height)
			{
				x += parent.width * parent.scaleX - width * scaleX;
			}
		}
		protected function parentHorizontalAlignCenter():void
		{
			if(parent.width && parent.height && width && height)
			{
				x += parent.width * parent.scaleX/2 - width * scaleX/2;
			}
		}
		protected function scaleModeHorizontalOnly():void
		{
			if(parent.width && parent.height && width && height)
			{
				scaleX = parent.width/width;
			}
		}
		protected function scaleModeVertical():void
		{
			if(parent.width && parent.height && width && height)
			{
				scaleX += parent.height/height - scaleY;
				scaleY = parent.height/height;
			}
		}
		protected function scaleModeVerticalOnly():void
		{
			if(parent.width && parent.height && width && height)
			{
				scaleY = parent.height/height;
			}
		}
		protected function scaleModeHorizontal():void
		{
			var parentWidth:Number = parent.width;
			var parentHeight:Number = parent.height;
			if(parentWidth && parentHeight && width && height)
			{
				scaleY += parentWidth/width - scaleX;
				scaleX = parentWidth/width;
			}
		}
		override protected function draw():void
		{
			if(!isNaN(percentWidth))
			{
				width = parent.width*percentWidth/100;
			}
			if(!isNaN(percentHeight))
			{
				height = parent.height*percentHeight/100;
			}
			updateChildrenPoint();
			scaleModeFuns[scaleMode]();
			parentHorizontalAlignFuns[parentHorizontalAlign]();
			parentVerticalAlignFuns[parentVerticalAlign]();
			super.draw();
			if(parent && parent.hasOwnProperty('updateChildren'))
			{
				parent['updateChildren']();
			}
		}
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		protected function scaleModeAuto():void
		{
			if(parent.width && parent.height && width && height)
			{
				if(parent.width-width < parent.height-height)
				{
					scaleY += parent.width/width - scaleX;
					scaleX = parent.width/width;
				}
				else if(parent.width-width > parent.height-height)
				{
					scaleX += parent.height/height - scaleY;
					scaleY = parent.height/height;
				}
			}
		}
		protected function scaleModeFull():void
		{
			if(parent.width && parent.height && width && height)
			{
				scaleX = parent.width/width;
				scaleY = parent.height/height;
			}
		}
		override protected function initialize():void
		{
			super.initialize();
			updateChildrenPoint();
		}
		private var childDefaultPoints:Array;
		protected function updateChildrenPoint():void
		{
			if(childCenter || childMiddle)
			{
				childDefaultPoints = childDefaultPoints==null?[]:childDefaultPoints;
				var updated:Boolean = childDefaultPoints.length;
				for (var i:int = 0; i < numChildren; i++) 
				{
					var child:DisplayObject = getChildAt(i);
					if(childCenter)
					{
						if(updated)
						{
							child.x = childDefaultPoints[i].x + width/2 - child.width/2;
						}
						else
						{
							childDefaultPoints.push(new Point(child.x,child.y));
							child.x += width/2 - child.width/2;
						}
					}
					if(childMiddle)
					{
						if(updated)
						{
							child.y = childDefaultPoints[i].y + height/2 - child.height/2;
						}
						else
						{
							childDefaultPoints.push(new Point(child.x,child.y));
							child.y += height/2 - child.height/2;
						}
					}
				}
			}
		}
		protected function scaleModeNone():void	{};
		protected function parentHorizontalAlignNone():void	{};
		protected function parentVerticalAlignNone():void	{};
		public function set scaleMode(value:String):void
		{
			_scaleMode = value;
		}
		override public function dispose():void
		{
			childDefaultPoints = null;
			scaleModeFuns = null;
			parentHorizontalAlignFuns = null;
			super.dispose();
		}
	}
}