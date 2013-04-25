package manager
{
	import config.BaseConfig;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import load.LoadTool;
	import load.LoadToolEvent;
	import load.LoadToolItem;
	import load.LoadToolType;

	public class SourceManager extends BaseManager
	{
		private var loadTool:LoadTool = new LoadTool();
		/**
		 * 没自动加载的数据 
		 */		
		private var noLoadDatas:Dictionary = new Dictionary();
		/** 每个表对应的xml */
		private var obj:Dictionary = new Dictionary();
		private var configs:Dictionary = new Dictionary();
		public function SourceManager()
		{
			loadTool.addEventListener(LoadToolEvent.LOADONE_COMPLETE,loadOneComplete);
			loadTool.addEventListener(LoadToolEvent.LOAD_PROGRESS,loadProgress);
			loadTool.addEventListener(LoadToolEvent.LOAD_COMPLETE,loadComplete);
			super();
		}
		public static function getInstance():SourceManager
		{
			return SourceManager(BaseManager.getInstance("manager::SourceManager"));
		}
		public function addClass(...args):void{};
		/** 加载主配置表 */
		public function loadConfig(path:String):void
		{
			var ul:URLLoader=new URLLoader();
			ul.load(new URLRequest(path + "?v=" + LoadTool.VERSION));
			ul.addEventListener(Event.COMPLETE,onMainConfig);
			ul.addEventListener(IOErrorEvent.IO_ERROR,onIOErr_MainXML);
			ul.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErr);
		}
		private function onMainConfig(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,onMainConfig);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onIOErr_MainXML);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErr);
			var xml:XML = new XML(event.target.data);
			var fileList:XMLList = xml.filelist.file;
			var sourceList:XMLList = xml.sourcelist.source;
			var index:uint;
			for (var i:int = 0; i < sourceList.length(); i++) 
			{
				if(sourceList[i].@autoLoad == "true")
				{
					index++;
					var sLoadToolItem:LoadToolItem = new LoadToolItem();
					sLoadToolItem.info = sourceList[i].@info;
					sLoadToolItem.path = sourceList[i].@path;
					sLoadToolItem.index = index;
					sLoadToolItem.data = sourceList[i];
					loadTool.addResource(sLoadToolItem);
				}
				else
				{
					noLoadDatas[sourceList[i].@name.toString()] = sourceList[i];
				}
			}
			for (var j:int = 0; j < fileList.length(); j++) 
			{
				if(fileList[j].@autoLoad == "true")
				{
					index++;
					var fLoadToolItem:LoadToolItem = new LoadToolItem();
					fLoadToolItem.info = fileList[j].@info;
					fLoadToolItem.path = fileList[j].@path;
					fLoadToolItem.index = index;
					fLoadToolItem.type = LoadToolType.BINARY;
					fLoadToolItem.data = fileList[j];
					loadTool.addResource(fLoadToolItem);
				}
				else
				{
					noLoadDatas[fileList[j].@name.toString()] = fileList[j];
				}
			}
			loadTool.loadResources();
		}
		/**
		 * 根据名称加载 
		 * @param name
		 * 
		 */		
		public function loadByName(sourceNames:Array,configNames:Array):void
		{
			var index:uint;
			if(sourceNames)
			{
				for (var i:int = 0; i < sourceNames.length; i++) 
				{
					index++;
					var sLoadToolItem:LoadToolItem = new LoadToolItem();
					sLoadToolItem.info = noLoadDatas[sourceNames[i]].@info;
					sLoadToolItem.path = noLoadDatas[sourceNames[i]].@path;
					sLoadToolItem.index = i;
					sLoadToolItem.type = LoadToolType.DISPLAYOBJECT;
					sLoadToolItem.data = noLoadDatas[sourceNames[i]];
					loadTool.addResource(sLoadToolItem);				
				}
			}
			if(configNames)
			{
				for (var j:int = 0; j < configNames.length; j++) 
				{
					index++;
					var fLoadToolItem:LoadToolItem = new LoadToolItem();
					fLoadToolItem.info = noLoadDatas[configNames[j]].@info;
					fLoadToolItem.path = noLoadDatas[configNames[j]].@path;
					fLoadToolItem.index = j;
					fLoadToolItem.type = LoadToolType.BINARY;
					fLoadToolItem.data = noLoadDatas[configNames[j]];
					loadTool.addResource(fLoadToolItem);	
				}
			}			
			loadTool.loadResources();
			
		}
		/** 根据名称获取配置类，如果配置未加载则为空 */
		public function getConfig(name:String):BaseConfig
		{
			return configs[name];
		}
		/** 获取指定的XML配置 */
		public function getDataByName(name:String):String
		{
			return obj[name];
		}
		private function loadOneComplete(event:LoadToolEvent):void
		{
			if(event.loadToolItem.type == LoadToolType.BINARY)
			{
				var data:String;
				var bytes:ByteArray = ByteArray(loadTool.getFromPool(event.loadToolItem.path));
				if(event.loadToolItem.data.@type == "csv")
				{
					data = bytes.readMultiByte(bytes.bytesAvailable,"cn-gb");//.readMultiByte(ul.bytesAvailable,"cn-gb");
				}
				else
				{
					data = bytes.readMultiByte(bytes.bytesAvailable,"utf-8");
				}
				obj[event.loadToolItem.data.@name.toString()] = data;
				var SourceClass:Class=getDefinitionByName(event.loadToolItem.data.@className) as Class;
				configs[event.loadToolItem.data.@name.toString()] = new SourceClass(event.loadToolItem.data.@name);				
			}
			dispatchEvent(event);
		}
		private function loadProgress(event:LoadToolEvent):void
		{
			dispatchEvent(event);
		}
		private function loadComplete(event:LoadToolEvent):void
		{
			loadTool.deleteAll();
			dispatchEvent(event);
		}
		private function onIOErr_MainXML(event:IOErrorEvent):void
		{
			throw(new Error("未找到主配置文件。"));
		}
		private function onSecurityErr(event:SecurityErrorEvent):void
		{
			throw(new Error("加载配置文件出现安全沙箱错误。"));
		}
	}
}