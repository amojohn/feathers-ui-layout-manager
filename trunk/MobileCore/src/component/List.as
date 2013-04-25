package component
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import events.ComponentEvent;
	
	[Event(name="itemdoublieclick",type="events.ComponentEvent")]
	[Event(name="itemclick",type="events.ComponentEvent")]
	
	/**
	 * 纵向的列表 
	 * @author 袁浩
	 * 
	 */
	public class List extends BaseComponent
	{
		/** 列表数据 */
		public var data:Array;
		/** 列表项类 */
		protected var ItemClass:Class;
		/** 选中的项目 **/
		private var _selectItem:ListItem;
		protected var _selectIndex:int;
		/** 所有项 */
		public var items:Array=[];
		/** 项容器 */
		protected var _ctn:Sprite;
		/** 滚动条 */
		protected var _scrollBar:DownTopSlide;
		/** 高度 */
		protected var _height:int;
		/** 宽度 */
		protected var _width:int;
		protected var _gap:Number;
		protected var _top:int;
		protected var _left:int;
		public function List($bg:DisplayObjectContainer,$data:Array,$ItemClass:Class,$gap:Number=0,$top:int=0,$left:int=0,$whellNum:uint=20)
		{
			super($bg);
			_gap = $gap;
			_top = $top;
			_left = $left;
			_height=viewUI.height;
			_width=viewUI.width;
			if(!$data)
			{
				data = [];
			}
			else
			{
				data = $data;
			}
			ItemClass=$ItemClass;
			_ctn=new Sprite();
			viewUI.addChild(_ctn);
			_scrollBar=new DownTopSlide();
			viewUI.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			update();
			viewUI.mouseEnabled = false;
		}
		private function addToStage(event:Event):void
		{
			_scrollBar.setData(_ctn,new Rectangle(0, 0, _width, _height), new Rectangle(0, 0, _width,_height));
			_scrollBar.onMouseClickHandler = onClick;
			_scrollBar.onMouseDownHandler = onMouseDown;
			_scrollBar.onMouseUpHandler = onMouseUp;
			_scrollBar.onMouseMoveHandler = onMouseMove;
		}
		/** 更新列表 */
		public function update($data:Array=null,$isRemove:Boolean=true):void
		{
			if($data)
				data=$data;
			if($isRemove)
				removeAllItems();
			var item:ListItem;
			var h:int=_top;
			for(var i:int=0;i<data.length;i++)
			{
				if($isRemove)
				{
					item=createItem(i);
					items.push(item);
					item.addParent(_ctn);
				}
				else
				{
					item = items[i];
				}
				item.setProp("y",h);
				item.setProp("x",_left);
				h+=item.getProp("height")+_gap;
				item.data = data[i];
			}
			if(items.length>0)
			{
				selectItem = items[0];
			}
//			if(_ctn.height>_height)          
//			{
//				_scrollBar.visible = true&&_showScrollBar;
//				_scrollBar.freshData();
//			}
//			else
//			{
//				_scrollBar.visible = false&&_showScrollBar;
//			}
		}
		/** 根据数据删除item **/
		public function deleteItems(array:Array):Array
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				for (var j:int = 0; j < items.length; j++) 
				{
					if(items[j].data == array[i])
					{
						var item:ListItem=items[j];
						item.dispose();
						item=null;
						items.splice(j,1);
						data.splice(j,1);
						break;
					}
				}
			}
			update(data,false);
			return data;
		}
		/** 添加新项 **/
		public function addItems(array:Array):void
		{
			data = data.concat(array);
			update(data);
		}
		/** 创建新项 */
		protected function createItem($index:int):ListItem
		{
			return new ItemClass($index,this);
		}
		/** 列表项点击 */
		protected function onMouseMove(mouseX:Number,mouseY:Number):void
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				items[i].listMove(mouseX,mouseY);
				if(mouseX <= items[i].viewUI.x+items[i].viewUI.width && mouseY-_ctn.y <= items[i].viewUI.y+items[i].viewUI.height)
				{
					items[i].onMove(mouseX,mouseY);
					return;
				}
			}
		}
		/** 列表项点击 */
		protected function onMouseUp(mouseX:Number,mouseY:Number):void
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				if(mouseX <= items[i].viewUI.x+items[i].viewUI.width && mouseY-_ctn.y <= items[i].viewUI.y+items[i].viewUI.height)
				{
					items[i].onUp(mouseX,mouseY);
					return;
				}
			}
		}
		/** 列表项点击 */
		protected function onMouseDown(mouseX:Number,mouseY:Number):void
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				if(mouseX <= items[i].viewUI.x+items[i].viewUI.width && mouseY-_ctn.y <= items[i].viewUI.y+items[i].viewUI.height)
				{
					items[i].onDown(mouseX,mouseY);
					return;
				}
			}
		}
		/** 列表项点击 */
		protected function onClick(mouseX:Number,mouseY:Number):void
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				if(mouseX <= items[i].viewUI.x+items[i].viewUI.width && mouseY-_ctn.y <= items[i].viewUI.y+items[i].viewUI.height)
				{
					selectItem = items[i];
					_selectIndex = i;
					dispatchEvent(new ComponentEvent(ComponentEvent.ITEM_CLICK,selectItem.data));
					items[i].onClick(mouseX,mouseY);
					return;
				}
			}
		}
		/** 删除所有项目 */
		protected function removeAllItems():void
		{
			selectItem = null;
			for(var i:int=0;i<items.length;i++)
			{
				var item:ListItem=items[i];
				item.dispose();
				item=null;
			}
			items = [];
		}
		
	
		/** 间距 **/
		public function get gap():Number
		{
			return _gap;
		}
		
		/** 当前选中的项 */
		public function get selectItem():ListItem
		{
			return _selectItem;
		}
		
		/**
		 * @private
		 */
		public function set selectItem(value:ListItem):void
		{
			if(value == selectItem)
			{
				return;
			}
			if(selectItem)
			{
				selectItem.unSelected();
			}
			if(!value)
			{
				_selectItem = value;
				return;
			}
			_selectItem = value;
			if(selectItem)
			{
				selectItem.selected();
			}
		}
		public function getItemAt(index:int):ListItem
		{			
			//			for(var i:int=0;i<_items.length;i++)
			//			{
			//				if(_items[index] ==)
			//			}
			return items[index];
		}
		public function getIndexByItem(item:ListItem):int
		{			
			for(var i:int=0;i<items.length;i++)
			{
				if(items[i] == item)
				{
					return i;
				}
			}
			return -1;
		}
		/** 选中项目的索引 **/
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		
		/**
		 * @private
		 */
		public function set selectIndex(value:int):void
		{
			selectItem = items[value];
			_selectIndex = value;
		}
		
		public override function dispose():void
		{
			if(_scrollBar)
			{
				_scrollBar.dispose();
			}
			_selectItem = null;
			data = null;
			_ctn = null;
			removeAllItems();
 			if(viewUI.parent)
			{
				viewUI.parent.removeChild(viewUI);
			}
			viewUI.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			_scrollBar = null;
			super.dispose();
		}

		
	}
}