package component.starling
{
	import events.BaseEvent;
	
	import feathers.controls.List;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.IToggle;
	
	import manager.UIManager;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ListItem extends  BaseDefaultItemRenderer implements IListItemRenderer,IToggle
	{
		public static var SELECTED:String='selected';
		public static var UNSELECTED:String='unselected';
		public static var CHANGE:String='itemchange';
		public function ListItem()
		{
			super();
			itemHasLabel = false;
		}
		
		override public function set isSelected(value:Boolean):void
		{
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			if(this._isSelected)
			{
				UIManager.getInstance().dispatchEvent(new BaseEvent(SELECTED,this));
			}
			else
			{
				UIManager.getInstance().dispatchEvent(new BaseEvent(UNSELECTED,this));
			}
			dispatchEventWith(CHANGE,false,this);
		}
		override protected function initialize():void
		{
			UIManager.getInstance().addChildByUIName(this);
		}
		override public function dispose():void
		{
			UIManager.getInstance().removeChildByName(this);
			super.dispose();
		}
		public function getChildByXML(childName:String):DisplayObject
		{
			return UIManager.getInstance().getChildByName(childName,this);
		}
		
		/**
		 * @private
		 */
		protected var _index:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():feathers.controls.List
		{
			return feathers.controls.List(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:feathers.controls.List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				feathers.controls.List(this._owner).removeEventListener(Event.SCROLL, owner_scrollHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				const list:feathers.controls.List = feathers.controls.List(this._owner);
				this.isToggle = list.isSelectable;
				list.addEventListener(Event.SCROLL, owner_scrollHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function owner_scrollHandler(event:Event):void
		{
			this.handleOwnerScroll();
		}
	}
}