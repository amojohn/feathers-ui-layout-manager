package component
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import load.LoadTool;
	
	/**
	 * 用于加载图标 
	 * @author 袁浩
	 * 
	 */
	public class ImageLoader extends Sprite
	{
		/** 加载用的Loader类 */
		public var _loader:Loader;
		/** 图片的URL */
		private var _url:String;
		/** 图片的宽度 */
		private var _width:int;
		/** 图片的高度 */
		private var _height:int;
		
		/**
		 * 构造函数 
		 * @param $url 图片位置
		 * @param $width 载入后的宽度，0为实际宽度
		 * @param $height 高度，同上
		 * 
		 */
		public function ImageLoader($url:String=null,$width:int=0,$height:int=0)
		{
			super();
			_loader=new Loader();
			_loader.doubleClickEnabled = true;
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoading);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			addChild(_loader);
			if($url)
				load($url,$width,$height);
		}
		private function onIOError(event:IOErrorEvent):void
		{
			//dispatchEvent(event);
		}
		/**
		 * 加载图片 
		 * @param $url 图片位置
		 * @param $width 载入后的宽度，0为实际宽度
		 * @param $height 高度，同上
		 * 
		 */
		public function load($url:String="",$width:int=0,$height:int=0):void
		{
			if(_url!=$url)
			{
				_url=$url;
				_width=$width;
				_height=$height;
				_loader.unload();
				if(_url && _url.length > 0)
				{
					_loader.load(new URLRequest(_url+"?v="+LoadTool.VERSION));
				}
			}
		}
		
		
		private function onLoading(event:ProgressEvent):void
		{
			//dispatchEvent(new LoadingEvent(LoadingEvent.LOADING,{bytesLoaded:event.bytesLoaded,bytesTotal:event.bytesTotal}));
			dispatchEvent(event);
		}
		
		private function onLoaded(event:Event):void
		{
			if(_width>0 && _height>0)
			{
				_loader.width=_width;
				_loader.height=_height;
			}
			if(_loader.content is Bitmap)
			{
				Bitmap(_loader.content).smoothing = true;
			}
			dispatchEvent(event);
		}
		
		public function dispose(isDel:Boolean=true):void
		{
			if(isDel && parent)
				parent.removeChild(this);
			removeAllChildren();
			removeAllListener();
			nullAllReference();
		}
		
		public function removeAllChildren():void
		{
			_loader.unload();
			removeChild(_loader);
			_url = null;
		}
		
		public function removeAllListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoading);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaded);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		public function nullAllReference():void
		{
			_loader=null;
		}
	}
}