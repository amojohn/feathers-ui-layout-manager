package load
{
	
	/**
	 * 资源对象 
	 * @author 袁浩
	 * 
	 */	
	public class LoadToolItem
	{
		private var _path:String;
		private var _name:String;
		private var _type:String = LoadToolType.DISPLAYOBJECT;
		private var _info:String;
		private var _percent:int;
		private var _data:*;
		private var _index:uint;
		private var _count:uint;
		/**
		 * 创建一个资源对象。利用资源加载工具对象进行资源加载之前您必须先创建这个对象才能进行资源加载。<br>
		 * 加载完成您也需要通过event.resourceItem来知道加载的资源。
		 * 
		 */		
		public function LoadToolItem()
		{
			
		}
		/**
		 * 对象数据 
		 * @return 
		 * 
		 */
		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}
		/**
		 * 创建一个资源 
		 * @param path 路径
		 * @return 资源对象
		 * 
		 */
		public static function createResourceItem(path:String):LoadToolItem
		{
			var resourceItem:LoadToolItem = new LoadToolItem();
			resourceItem.info = path;
			resourceItem.path = path;
			return resourceItem;
		}
		/**
		 * 创建一组资源 
		 * @param paths 路径列表
		 * @return 资源列表
		 * 
		 */		
		public static function createResourceItems(paths:Vector.<String>):Vector.<LoadToolItem>
		{
			var resourceItems:Vector.<LoadToolItem> = new Vector.<LoadToolItem>();
			for (var i:int = 0; i < paths.length; i++) 
			{
				resourceItems.push(createResourceItem(paths[i]));
			}
			
			return resourceItems;
		}
		/**
		 * 当前下载百分比 
		 * @return 
		 * 
		 */
		public function get percent():int
		{
			return _percent;
		}

		public function set percent(value:int):void
		{
			_percent = value;
		}
		/**
		 * 资源信息 
		 * @return 
		 * 
		 */
		public function get info():String
		{
			return _info;
		}

		public function set info(value:String):void
		{
			_info = value;
		}
		/**
		 * 资源类型，默认值为ResourceType.DISPLAYOBJECT 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		/**
		 * 资源路径 
		 * @return 
		 * 
		 */
		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}


		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			_index = value;
		}

		public function get count():uint
		{
			return _count;
		}

		public function set count(value:uint):void
		{
			_count = value;
		}


	}
}