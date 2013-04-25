package component
{
	import flash.filters.GlowFilter;
	

	/**
	 * 列表项
	 * @author 袁浩
	 *
	 */
	public class ListItem extends BaseComponent
	{
		/** 项的索引 */
		protected var _index:int;
		protected var _data:*;
		protected var _par:int;
		private var _parent:List;
		public function ListItem($index:int,parent:List = null)
		{
			viewUI.doubleClickEnabled = true;
			super(viewUI);
			_index=$index;
			_parent = parent;
		}
		public function listMove(mouseX:Number,mouseY:Number):void
		{
			
		}
		public function onMove(mouseX:Number,mouseY:Number):void
		{
			
		}
		public function onClick(mouseX:Number,mouseY:Number):void
		{
			
		}
		public function onUp(mouseX:Number,mouseY:Number):void
		{
			
		}
		public function onDown(mouseX:Number,mouseY:Number):void
		{
			
		}
		/** 设置选中效果 **/
		public function selected():void
		{
			var filter:GlowFilter=new GlowFilter(0xffffff);
			viewUI.filters=[filter];
		}
		
		/** 设置取消选中效果 **/
		public function unSelected():void
		{
			viewUI.filters=null;
		}
		public function get par():int
		{
			return _par;
		}

		public function set par(value:int):void
		{

			_par=value;

		}
		public function getStage():*
		{

			return viewUI.stage;
		}

		public override function dispose():void
		{
			if (viewUI && viewUI.parent)
			{
				viewUI.parent.removeChild(viewUI);
			}
			viewUI=null;
			_parent = null;
			_data = null;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data=value;
		}

		public function get parent():List
		{
			return _parent;
		}


	}
}
