package component.starling
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import manager.UIManager;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ListItem extends FeathersControl implements IListItemRenderer
	{
		public function ListItem()
		{
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
		protected var _index:int = -1;
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _owner:feathers.controls.List;
		
		public function get owner():feathers.controls.List
		{
			return feathers.controls.List(this._owner);
		}
		
		public function set owner(value:feathers.controls.List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _data:Object;
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _isSelected:Boolean;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		override protected function draw():void
		{
			const dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			if(dataInvalid)
			{
				commitData();
			}
		}
		protected function commitData():void
		{
			
		}
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}