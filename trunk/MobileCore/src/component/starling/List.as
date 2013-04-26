package component.starling
{
	import flash.geom.Rectangle;
	
	import events.BaseEvent;
	
	import feathers.controls.List;
	import feathers.controls.ScrollBar;
	import feathers.controls.Scroller;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	import utils.tool;
	import manager.UIManager;
	
	import starling.events.Event;
	
	public class List extends feathers.controls.List
	{
		private var _gap:int;
		private var _thumbVerticalDefaultSkinName:String;
		private var _trackVerticalDefaultSkinName:String;
		private var _trackVerticalDefaultRectangle:String;
		private var _decrementButtonVerticalDefaultSkinName:String;
		private var _decrementButtonVerticalDefaultRectangle:String;
		private var _decrementButtonVerticalDownSkinName:String;
		private var _decrementButtonVerticalDownRectangle:String;
		private var _decrementButtonVerticalHoverSkinName:String;
		private var _decrementButtonVerticalHoverRectangle:String;
		private var _incrementButtonVerticalDefaultSkinName:String;
		private var _incrementButtonVerticalDefaultRectangle:String;
		private var _incrementButtonVerticalDownSkinName:String;
		private var _incrementButtonVerticalDownRectangle:String;
		private var _incrementButtonVerticalHoverSkinName:String;
		private var _incrementButtonVerticalHoverRectangle:String;
		private var _scrollerVerticalFirstRegionSize:int = 5;
		private var _scrollerVerticalSecondRegionSize:int = 14;
		private var _interactionMode:String;
		private var _scrollBarDisplayMode:String;
		private var _layoutType:String;
		private var _verticalAlign:String;
		private var _horizontalAlign:String;
		protected var _selectedItems:Vector.<ListItem> = new Vector.<ListItem>();
		public function List()
		{
			_interactionMode = tool.getOSType()==0?Scroller.INTERACTION_MODE_MOUSE:Scroller.INTERACTION_MODE_TOUCH;
			_scrollBarDisplayMode = tool.getOSType()==0?Scroller.SCROLL_BAR_DISPLAY_MODE_FLOAT:Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			UIManager.getInstance().addEventListener(ListItem.SELECTED,itemSelected);
			UIManager.getInstance().addEventListener(ListItem.UNSELECTED,itemUnSelected);
			super();
		}
		public function getSelectedItems():Vector.<ListItem>
		{
			return _selectedItems.concat();
		}
		protected function itemSelected(event:BaseEvent):void
		{
			_selectedItems.push(event.data);
			dispatchEventWith(Event.CHANGE);
		}
		protected function itemUnSelected(event:BaseEvent):void
		{
			for (var i:int = 0; i < _selectedItems.length; i++) 
			{
				if(_selectedItems[i] == event.data)
				{
					_selectedItems.splice(i,1);
				}
			}
			dispatchEventWith(Event.CHANGE);
		}
		override public function dispose():void
		{
			_selectedItems = null;
			UIManager.getInstance().removeEventListener(ListItem.SELECTED,itemSelected);
			UIManager.getInstance().removeEventListener(ListItem.UNSELECTED,itemUnSelected);
			super.dispose();
		}
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
		}
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
		}
		public function get layoutType():String
		{
			return _layoutType;
		}

		public function set layoutType(value:String):void
		{
			_layoutType = value;
			if(_layoutType == 'horizontal')
			{
				layout = new HorizontalLayout();
			}
			else if(_layoutType == 'vertical')
			{
				layout = new VerticalLayout();
			}
		}

		public function get incrementButtonVerticalHoverRectangle():String
		{
			return _incrementButtonVerticalHoverRectangle;
		}

		public function set incrementButtonVerticalHoverRectangle(value:String):void
		{
			_incrementButtonVerticalHoverRectangle = value;
		}

		public function get incrementButtonVerticalDownRectangle():String
		{
			return _incrementButtonVerticalDownRectangle;
		}

		public function set incrementButtonVerticalDownRectangle(value:String):void
		{
			_incrementButtonVerticalDownRectangle = value;
		}

		public function get incrementButtonVerticalDefaultRectangle():String
		{
			return _incrementButtonVerticalDefaultRectangle;
		}

		public function set incrementButtonVerticalDefaultRectangle(value:String):void
		{
			_incrementButtonVerticalDefaultRectangle = value;
		}

		public function get decrementButtonVerticalHoverRectangle():String
		{
			return _decrementButtonVerticalHoverRectangle;
		}

		public function set decrementButtonVerticalHoverRectangle(value:String):void
		{
			_decrementButtonVerticalHoverRectangle = value;
		}

		public function get decrementButtonVerticalDownRectangle():String
		{
			return _decrementButtonVerticalDownRectangle;
		}

		public function set decrementButtonVerticalDownRectangle(value:String):void
		{
			_decrementButtonVerticalDownRectangle = value;
		}

		public function get decrementButtonVerticalDefaultRectangle():String
		{
			return _decrementButtonVerticalDefaultRectangle;
		}

		public function set decrementButtonVerticalDefaultRectangle(value:String):void
		{
			_decrementButtonVerticalDefaultRectangle = value;
		}

		public function get trackVerticalDefaultRectangle():String
		{
			return _trackVerticalDefaultRectangle;
		}

		public function set trackVerticalDefaultRectangle(value:String):void
		{
			_trackVerticalDefaultRectangle = value;
		}
		public function getRectangle(value:String):Rectangle
		{
			var values:Array = value.split(',');
			return new Rectangle(values[0],values[1],values[2],values[3]);
		}
		public function get incrementButtonVerticalDefaultSkinName():String
		{
			return _incrementButtonVerticalDefaultSkinName;
		}

		public function set incrementButtonVerticalDefaultSkinName(value:String):void
		{
			_incrementButtonVerticalDefaultSkinName = value;
		}

		public function get incrementButtonVerticalDownSkinName():String
		{
			return _incrementButtonVerticalDownSkinName;
		}

		public function set incrementButtonVerticalDownSkinName(value:String):void
		{
			_incrementButtonVerticalDownSkinName = value;
		}

		public function get incrementButtonVerticalHoverSkinName():String
		{
			return _incrementButtonVerticalHoverSkinName;
		}

		public function set incrementButtonVerticalHoverSkinName(value:String):void
		{
			_incrementButtonVerticalHoverSkinName = value;
		}

		public function get decrementButtonVerticalHoverSkinName():String
		{
			return _decrementButtonVerticalHoverSkinName;
		}

		public function set decrementButtonVerticalHoverSkinName(value:String):void
		{
			_decrementButtonVerticalHoverSkinName = value;
		}

		public function get decrementButtonVerticalDownSkinName():String
		{
			return _decrementButtonVerticalDownSkinName;
		}

		public function set decrementButtonVerticalDownSkinName(value:String):void
		{
			_decrementButtonVerticalDownSkinName = value;
		}

		public function get decrementButtonVerticalDefaultSkinName():String
		{
			return _decrementButtonVerticalDefaultSkinName;
		}

		public function set decrementButtonVerticalDefaultSkinName(value:String):void
		{
			_decrementButtonVerticalDefaultSkinName = value;
		}

		public function get trackVerticalDefaultSkinName():String
		{
			return _trackVerticalDefaultSkinName;
		}

		public function set trackVerticalDefaultSkinName(value:String):void
		{
			_trackVerticalDefaultSkinName = value;
		}

		/**
		 * 垂直滚动条三宫切片中间大小 
		 * @return 
		 * 
		 */
		public function get scrollerVerticalSecondRegionSize():int
		{
			return _scrollerVerticalSecondRegionSize;
		}

		public function set scrollerVerticalSecondRegionSize(value:int):void
		{
			_scrollerVerticalSecondRegionSize = value;
		}
		
		/**
		 * 垂直滚动条三宫切片边缘大小 
		 * @return 
		 * 
		 */
		public function get scrollerVerticalFirstRegionSize():int
		{
			return _scrollerVerticalFirstRegionSize;
		}

		public function set scrollerVerticalFirstRegionSize(value:int):void
		{
			_scrollerVerticalFirstRegionSize = value;
		}
		/**
		 * 垂直滚动条皮肤名称（其实就是你的png名称） 
		 * @return 
		 * 
		 */
		public function get thumbVerticalDefaultSkinName():String
		{
			return _thumbVerticalDefaultSkinName;
		}

		public function set thumbVerticalDefaultSkinName(value:String):void
		{
			_thumbVerticalDefaultSkinName = value;
		}
		override protected function initialize():void
		{
			super.initialize();
			initLayOut();
			initScroll();
		}
		protected function initLayOut():void
		{
			layout['gap'] = gap;
			layout['verticalAlign'] = verticalAlign;
			layout['horizontalAlign'] = horizontalAlign;
		}
		protected function initScroll():void
		{
			var thumbPropertiesDefaultSkin:Scale3Image;			
			if(thumbVerticalDefaultSkinName)
			{
				thumbPropertiesDefaultSkin = new Scale3Image(
					new Scale3Textures(
						UIManager.getInstance().getTexture(thumbVerticalDefaultSkinName),scrollerVerticalFirstRegionSize,scrollerVerticalSecondRegionSize,Scale3Textures.DIRECTION_VERTICAL
					)
				);
			}
			var trackPropertiesDefaultSkin:Scale9Image;
			if(trackVerticalDefaultSkinName)
			{
				trackPropertiesDefaultSkin = new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(trackVerticalDefaultSkinName),getRectangle(trackVerticalDefaultRectangle)
					)
				);
			}
			var decrementButtonPropertiesDefaultSkin:Scale9Image;
			if(decrementButtonVerticalDefaultSkinName)
			{
				decrementButtonPropertiesDefaultSkin = new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(decrementButtonVerticalDefaultSkinName),getRectangle(decrementButtonVerticalDefaultRectangle)
					)
				);
			}
			var decrementButtonPropertiesDownSkin:Scale9Image;
			if(decrementButtonVerticalDownSkinName)
			{
				decrementButtonPropertiesDownSkin =  new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(decrementButtonVerticalDownSkinName),getRectangle(decrementButtonVerticalDownRectangle)
					)
				);
			}
			var decrementButtonPropertiesHoverSkin:Scale9Image;
			if(decrementButtonVerticalHoverSkinName)
			{
				decrementButtonPropertiesHoverSkin =  new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(decrementButtonVerticalHoverSkinName),getRectangle(decrementButtonVerticalHoverRectangle)
					)
				);
			}
			
			
			var incrementButtonPropertiesDefaultSkin:Scale9Image;
			
			if(incrementButtonVerticalDefaultSkinName)
			{
				incrementButtonPropertiesDefaultSkin = new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(incrementButtonVerticalDefaultSkinName),getRectangle(incrementButtonVerticalDefaultRectangle)
					)
				);
			}
			var incrementButtonPropertiesDownSkin:Scale9Image;
			if(incrementButtonVerticalDownSkinName)
			{
				incrementButtonPropertiesDownSkin =  new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(incrementButtonVerticalDownSkinName),getRectangle(incrementButtonVerticalDownRectangle)
					)
				);
			}
			var incrementButtonPropertiesHoverSkin:Scale9Image;
			if(incrementButtonVerticalHoverSkinName)
			{
				incrementButtonPropertiesHoverSkin =  new Scale9Image(
					new Scale9Textures(
						UIManager.getInstance().getTexture(incrementButtonVerticalHoverSkinName),getRectangle(incrementButtonVerticalHoverRectangle)
					)
				);
			}
			
			scroller.interactionMode = interactionMode;
			scroller.verticalScrollStep = verticalScrollStep;
			scroller.scrollBarDisplayMode = scrollBarDisplayMode;
			scroller.verticalScrollBarFactory = function verticalScrollBarFactory():ScrollBar
			{
				const scrollBar:ScrollBar = new ScrollBar();
				scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
				scrollBar.thumbProperties.defaultSkin = thumbPropertiesDefaultSkin?thumbPropertiesDefaultSkin:scrollBar.thumbProperties.defaultSkin;
				scrollBar.thumbProperties.downSkin = thumbPropertiesDefaultSkin?thumbPropertiesDefaultSkin:scrollBar.thumbProperties.defaultSkin;
				
				scrollBar.minimumTrackProperties.defaultSkin = trackPropertiesDefaultSkin?trackPropertiesDefaultSkin:scrollBar.minimumTrackProperties.defaultSkin;
				scrollBar.minimumTrackProperties.downSkin = trackPropertiesDefaultSkin?trackPropertiesDefaultSkin:scrollBar.minimumTrackProperties.downSkin;
				scrollBar.maximumTrackProperties.defaultSkin = trackPropertiesDefaultSkin?trackPropertiesDefaultSkin:scrollBar.maximumTrackProperties.defaultSkin;
				scrollBar.maximumTrackProperties.downSkin = trackPropertiesDefaultSkin?trackPropertiesDefaultSkin:scrollBar.maximumTrackProperties.downSkin;
				
				scrollBar.decrementButtonProperties.defaultSkin = decrementButtonPropertiesDefaultSkin?decrementButtonPropertiesDefaultSkin:scrollBar.decrementButtonProperties.defaultSkin;
				scrollBar.decrementButtonProperties.downSkin = decrementButtonPropertiesDownSkin?decrementButtonPropertiesDownSkin:scrollBar.decrementButtonProperties.downSkin;
				scrollBar.decrementButtonProperties.hoverSkin = decrementButtonPropertiesHoverSkin?decrementButtonPropertiesHoverSkin:scrollBar.decrementButtonProperties.hoverSkin;
				
				scrollBar.incrementButtonProperties.defaultSkin = incrementButtonPropertiesDefaultSkin?incrementButtonPropertiesDefaultSkin:scrollBar.incrementButtonProperties.defaultSkin;
				scrollBar.incrementButtonProperties.downSkin = incrementButtonPropertiesDownSkin?incrementButtonPropertiesDownSkin:scrollBar.incrementButtonProperties.downSkin;
				scrollBar.incrementButtonProperties.hoverSkin = incrementButtonPropertiesHoverSkin?incrementButtonPropertiesHoverSkin:scrollBar.incrementButtonProperties.hoverSkin;
				return scrollBar;
			}
		}
		private var _verticalScrollStep:Number = 10;
		public function get verticalScrollStep():Number
		{
			return _verticalScrollStep;
		}
		
		public function set verticalScrollStep(value:Number):void
		{
			_verticalScrollStep = value;
		}
		public function get scrollBarDisplayMode():String
		{
			return _scrollBarDisplayMode;
		}
		
		public function set scrollBarDisplayMode(value:String):void
		{
			_scrollBarDisplayMode = value;
		}
		public function get interactionMode():String
		{
			return _interactionMode;
		}
		
		public function set interactionMode(value:String):void
		{
			_interactionMode = value;
		}
		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			_gap = value;
		}

	}
}