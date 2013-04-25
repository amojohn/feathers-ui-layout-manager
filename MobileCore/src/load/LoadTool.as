package load
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * 资源加载工具，负责资源的加载和缓存
	 * @author 袁浩
	 * 
	 */
	public class LoadTool extends EventDispatcher
	{
		public static var VERSION:String="";
		private var _pool:Dictionary = new Dictionary();
		private var _items:Vector.<LoadToolItem>;
		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		private var _isLoading:Boolean;
		private var _context:LoaderContext = new LoaderContext();
		/**
		 * 创建一个资源加载工具对象
		 * 
		 */		
		public function LoadTool()
		{
			_context.allowCodeImport = true;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoading);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			_urlLoader = new URLLoader();
			_urlRequest = new URLRequest();
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,onLoading);
			_urlLoader.addEventListener(Event.COMPLETE,onLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			super();
		}
		public function get loader():Loader
		{
			return _loader;
		}

		/** 加载中的队列 **/
		public function removeResources():void
		{
			if(_items)
			{
				_items.length = 0;
			}
		}

		/** 加载中的队列 **/
		public function get items():Vector.<LoadToolItem>
		{
			return _items;
		}

		/** 是否在下载 **/
		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		/**
		 * 添加要加载的资源 
		 * @param resourceItem 资源对象
		 * @param oneLoad 是否同路径资源只允许加载一次
		 * 
		 */		
		public function addResource(resourceItem:LoadToolItem,oneLoad:Boolean=false):void
		{
			if(haveResourceInPool(resourceItem))//在资源池中
			{
				return;
			}
			if(oneLoad && haveResourceInLoad(resourceItem))
			{
				return;
			}
			if(!_items)
			{
				_items = new Vector.<LoadToolItem>();
			}
			_items.push(resourceItem);
		}
		/**
		 * 添加要加载的一组资源 
		 * @param resourceItems 资源列表
		 * @param oneLoad 是否同路径资源只允许加载一次
		 * 
		 */		
		public function addResources(resourceItems:Vector.<LoadToolItem>,oneLoad:Boolean=false):void
		{
			for (var i:int = 0; i < resourceItems.length; i++) 
			{
				addResource(resourceItems[i],oneLoad);
			}
			
		}
		/**
		 * 添加要加载的一组资源 
		 * @param resourceItems 资源列表
		 * @param oneLoad 是否同路径资源只允许加载一次
		 * 
		 */		
		public function addResourcesFast(array:Array,oneLoad:Boolean=false):void
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var resourceItem:LoadToolItem = new LoadToolItem();
				resourceItem.info = array[i].info;
				resourceItem.path = array[i].path;
				resourceItem.type = array[i].type;
				resourceItem.data = array[i].data;
				addResource(resourceItem,oneLoad);
			}
			
		}
		/**
		 * 判断要加载资源是否存在于队列 
		 * @param resourceItem 资源对象
		 * @return 
		 * 
		 */		
		public function haveResourceInLoad(resourceItem:LoadToolItem):Boolean
		{
			if(!_items)
			{
				return false;
			}
			for (var i:int = 0; i < _items.length; i++)
			{
				if(_items[i].path == resourceItem.path)
				{
					return true;
				}
			}			
			return false;
		}
		/**
		 * 判断要加载资源是否存在于资源池 
		 * @param resourceItem 资源对象
		 * @return 
		 * 
		 */		
		public function haveResourceInPool(resourceItem:LoadToolItem):Boolean
		{
			if(_pool[resourceItem.path])
			{
				return true;
			}
			return false;
		}
		/** 按队列加载多个资源 */
		public function loadResources():void
		{
			for (var i:int = 0; i < _items.length; i++) 
			{
				_items[i].count = _items.length;
			}
			
			if(_items && _items.length > 0)
			{
				if(!_isLoading)
				{
					load(_items[0]);
					_isLoading = true;
				}
			}
			
		}
		/**
		 * 加载单个资源 
		 * @param resourceItem 资源对象
		 * 
		 */		
		protected function load(resourceItem:LoadToolItem):void
		{
			var catchString:String = "?v=" + VERSION;
			_urlRequest.url = resourceItem.path + catchString;
			if(haveResourceInPool(resourceItem))//如果在资源池中则不需要再下载
			{
				onLoaded();
			}
			else if(resourceItem.type == LoadToolType.DISPLAYOBJECT)
			{
				_context.allowCodeImport = true;
				_context.applicationDomain = ApplicationDomain.currentDomain;
				_context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				_loader.load(_urlRequest,_context);
			}
			else
			{
				_urlLoader.dataFormat = resourceItem.type;
				_urlLoader.load(_urlRequest);
			}
		}
		/**
		 * 资源加载发生文件输入输出流错误 
		 * @param event 错误事件对象
		 * 
		 */		
		protected function ioError(event:IOErrorEvent):void
		{
			dispatchEvent( new LoadToolEvent(LoadToolEvent.LOAD_IO_ERROR,_items[0]));
			if(!hasEventListener(LoadToolEvent.LOAD_IO_ERROR))
			{
				t0(event.text);
			}
			_items.shift();
			if(items.length)
			{
				load(_items[0]);
			}
			else
			{
				_items.length = 0;
				_isLoading = false;
			}
		}
		/**
		 * 资源正在加载中 
		 * @param event 事件对象
		 * 
		 */		
		protected function onLoading(event:ProgressEvent):void
		{
			var loadToolEvent:LoadToolEvent = new LoadToolEvent(LoadToolEvent.LOAD_PROGRESS);
			loadToolEvent.loadToolItem = _items[0];
			loadToolEvent.loadToolItem.percent = event.bytesLoaded/event.bytesTotal*100;
			dispatchEvent(loadToolEvent);
		}
		/**
		 * 资源加载完成 
		 * @param event 事件对象
		 * 
		 */		
		protected function onLoaded(event:Event=null):void
		{
			var resourceEvent:LoadToolEvent = new LoadToolEvent(LoadToolEvent.LOADONE_COMPLETE);
			resourceEvent.loadToolItem = _items[0];
			resourceEvent.loadToolItem.percent = 100;
			if(event)
			{
				if(resourceEvent.loadToolItem.type == LoadToolType.DISPLAYOBJECT)
				{
					addToPool(resourceEvent.loadToolItem,event.target.content);
				}
				else
				{
					addToPool(resourceEvent.loadToolItem,event.target.data);
				}
			}
			dispatchEvent(resourceEvent);
			_items.shift();
			if(_items.length)
			{
				load(_items[0]);
			}
			else
			{
				_items.length = 0;
				_isLoading = false;
				dispatchEvent(new LoadToolEvent(LoadToolEvent.LOAD_COMPLETE));
			}
		}
		/**
		 * 向资源池添加资源 
		 * @param resourceItem 资源对象
		 * @param data 资源数据
		 * 
		 */		
		public function addToPool(resourceItem:LoadToolItem,data:*):void
		{
			_pool[resourceItem.path] = data;
		}
		/**
		 * 从资源池中删除资源 
		 * @param path 资源路径
		 * 
		 */		
		public function deleteFromPool(path:String):void
		{
			if(_pool[path])
			{
				_pool[path] = null;
				delete _pool[path];
			}
		}
		/**
		 * 删除资源池中所有资源
		 * 
		 */		
		public function deleteAll():void
		{
			for(var key:String in _pool)
			{
				deleteFromPool(key);
			}
		}
		/**
		 * 从资源池中获取数据 
		 * @param path 资源路径
		 * @param isDelete 获取之后是否删除引用
		 * @return 资源数据。根据传入的资源类型，可能为显示对象、文本、字节流这4种类型
		 * 
		 */		
		public function getFromPool(path:String,isDelete:Boolean=false):*
		{
			var object:*;
			if(_pool[path])
			{
				object = _pool[path];
			}
			if(isDelete)
			{
				deleteFromPool(path);
			}
			return object;
		}
		
		/** 按队列加载多个资源 */
		public function unloadResources():void
		{
			if(_isLoading)
			{
				try
				{
					_loader.close();
					_urlLoader.close();
				}
				catch(e:Error)
				{
					
				}
			}
			_isLoading = false;
			if(items)
			{
				items.length = 0;
			}
			deleteAll();
		}
		/**
		 * 销毁资源加载工具 
		 * 
		 */		
		public function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoading);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaded);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS,onLoading);
			_urlLoader.removeEventListener(Event.COMPLETE,onLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			if(_isLoading)
			{
				try
				{
					_loader.close();
					_urlLoader.close();
				}
				catch(e:Error)
				{
					
				}
			}
			_urlLoader = null;
			_urlRequest = null;
			_loader.unloadAndStop(true);
			_loader = null;
			_context = null;
			deleteAll();
			_pool = null;
			_items = null;
		}
	}
}