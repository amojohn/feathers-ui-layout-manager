package manager
{
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import component.starling.BaseLoadScreen;
	import component.starling.Button;
	import component.starling.Canvas;
	import component.starling.HBox;
	import component.starling.Image;
	import component.starling.Label;
	import component.starling.ProgressBar;
	import component.starling.Space;
	import component.starling.VBox;
	
	import events.UpLoadEvent;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.events.FeathersEventType;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	import utils.tool;

	public class UIManager extends BaseManager
	{
		private var childs:Dictionary = new Dictionary();
		public function UIManager()
		{
			Image;
			Canvas;
			HBox;
			VBox;
			Label;
			Space;
			Button;
			ProgressBar;
		}

		public function get uiConfig():XML
		{
			return _uiConfig;
		}

		public function get assets():AssetManager
		{
			return _assets;
		}

		public static function getInstance():UIManager
		{
			return UIManager(BaseManager.getInstance("manager::UIManager"));
		}
		private var _assets:AssetManager;
		private var _uiConfig:XML;
		
		public function addClass(...args):void{};
		private var texturePaths:Dictionary = new Dictionary();
		private var textures:Dictionary = new Dictionary();
		public function getTextureNames(name:String):Array
		{
			return textures[name];
		}
		/**
		 * 初始化资源 
		 * 
		 */		
		public function initAssets(assets:AssetManager,uiConfig:XML):void
		{
			_assets = assets;
			_uiConfig = uiConfig;
			assets.loadQueue(function(ratio:Number):void
			{
				dispatchEvent(new UpLoadEvent(UpLoadEvent.PROGRESS,ratio));
				if (ratio == 1)
				{
					dispatchEvent(new UpLoadEvent(UpLoadEvent.COMPLETE));
				}
			});
			var xmlList:XMLList = uiConfig.textures.texture;
			for (var i:int = 0; i < xmlList.length(); i++) 
			{
				var path:String = xmlList[i].@path.toString();
				var sources:Array = xmlList[i].@source.toString().split(',');
				var texturePathArray:Array = [];
				for (var j:int = 0; j < sources.length; j++) 
				{
					texturePathArray.push(path+sources[j]);
				}
				texturePaths[xmlList[i].@screenName.toString()] = texturePathArray;
				var textureNames:Array = [];
				for (var k:int = 0; k < sources.length; k++) 
				{
					var textureName:String = sources[k].substring(0,sources[k].lastIndexOf('.'));
					if(textureName.length)
					{
						textureNames.push(textureName);
					}
				}
				textures[xmlList[i].@screenName.toString()] = textureNames;
			}
		}
		/**
		 * 获取样式纹理图集 
		 * @return 
		 * 
		 */		
		public function getStyleAtlas(styleName:String):TextureAtlas
		{
			return assets.getTextureAtlas(styleName);
		}
		/**
		 * 获取纹理图集 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getTextureAtlas(name:String):TextureAtlas
		{
			return assets.getTextureAtlas(name);
		}
		/**
		 * 获取纹理 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getTexture(name:String):Texture
		{
			return assets.getTexture(name);
		}
		/**
		 * 根据名称回去控件实例
		 * @param name 控件名称
		 * @param parent 控件的顶级类（就是xml的ui标签的name所指定的类）
		 * @return 控件实例
		 * 
		 */
		public function getChildByName(name:String,parent:*):DisplayObject
		{
			return childs[getQualifiedClassName(parent)][name];
		}
		public function removeChildByName(parent:DisplayObjectContainer):void
		{
			childs[getQualifiedClassName(parent)] = null;
			delete childs[getQualifiedClassName(parent)];
		}
		/**
		 * 根据名称获取类型 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getClassByName(name:String):Class
		{
			var xmlList:XMLList = uiConfig.elements();
			for (var i:int = 0; i < xmlList.length(); i++) 
			{
				if(xmlList[i].@name == name)
				{
					var qn:QName = xmlList[i].name();
					var UIType:Class = getDefinitionByName(qn.toString()) as Class;
					return UIType;
				}
			}
			return null;
		}
		public function createUIByName(name:String):*
		{
			var xmlList:XMLList = uiConfig.elements();
			for (var i:int = 0; i < xmlList.length(); i++) 
			{
				if(xmlList[i].@name == name)
				{
					var qn:QName = xmlList[i].name();
					var UIType:Class = getDefinitionByName(qn.toString()) as Class;
					return new UIType();
				}
			}
			return null;
		}
		public function addChildByUIName(parent:DisplayObjectContainer):void
		{
			var type:String = getQualifiedClassName(parent);
			var uiXML:XMLList = getUIByName(type);
			for (var j:int = 0; j < uiXML.attributes().length(); j++) 
			{
				parent[uiXML.attributes()[j].name().localName.toString()] = uiXML.attributes()[j].toString();
			}
			addChildByUIXML(uiXML.children(),parent,type);
		}
		public function addChildByUIXML(xmllist:XMLList,parent:DisplayObjectContainer,type:String):void
		{
			for (var i:int = 0; i < xmllist.length(); i++) 
			{
				//var Child:Class = childMap[xmllist[i].name().localName.toString()];
				var qname:QName = new QName(xmllist[i].name());
				var Child:Class = getDefinitionByName(qname.toString()) as Class;
				var child:* = new Child();
				if(xmllist[i].@name.toString().length)
				{
					child.name = xmllist[i].@name;
					if(childs[type] == null)
					{
						childs[type] = new Dictionary();
					}
					childs[type][xmllist[i].@name.toString()] = child;
				}
				addChildByUIXML(xmllist[i].children(),child,type);
				for (var j:int = 0; j < xmllist[i].attributes().length(); j++) 
				{
					var attributeName:String = xmllist[i].attributes()[j].toString();
					if(attributeName.charAt(0) == '{' && attributeName.charAt(attributeName.length-1) == '}')
					{
						var value:* = getClassByName(attributeName.substr(1,attributeName.length-2));
						child[xmllist[i].attributes()[j].name().localName.toString()] = value;
					}
					else
					{
						if(xmllist[i].attributes()[j].toString() == 'false')
						{
							child[xmllist[i].attributes()[j].name().localName.toString()] = false;
						}
						else if(xmllist[i].attributes()[j].toString() == 'true')
						{
							child[xmllist[i].attributes()[j].name().localName.toString()] = true;
						}
						else
						{
							child[xmllist[i].attributes()[j].name().localName.toString()] = xmllist[i].attributes()[j].toString();
						}
					}
				}
				parent.addChild(child);
			}
		}
		public function getUIByName(name:String):XMLList
		{
			var nameSpace:String = name.substr(0,name.indexOf('::'));
			var className:String = name.substr(name.indexOf('::')+2,name.length)
			var qn:QName = new QName(nameSpace,className);
			return uiConfig.elements(qn);
		}
		
		
		private var navigator:ScreenNavigator;
		private var loadScreenItem:ScreenNavigatorItem;
		protected var nextID:String;
		private var loadName:String;
		/**
		 * 初始化场景导航器 
		 * @param nativeWidth 导航宽度
		 * @param nativeHeight 导航高度
		 * @param parent 导航的容器
		 * @param loadName 加载页面的名称（uiconfig.xml里面的name值）
		 * @param indexName 首页的名称（uiconfig.xml里面的name值）
		 * @param ChangeEffectClass 导航页面之间切换的特效
		 * @param names 导航剩余页面的名称（uiconfig.xml里面的name值）
		 * @return 
		 * 
		 */		
		public function initSceneNavigator(nativeWidth:Number,nativeHeight,parent:DisplayObjectContainer,loadName:String,indexName:String,ChangeEffectClass:Class=null,effectDuration:Number=0.4,... names):ScreenNavigator
		{
			this.loadName = loadName;
			navigator = new ScreenNavigator();
			navigator.width = nativeWidth;
			navigator.height = nativeHeight;
			parent.addChild(navigator);
			tool.scaleModeAuto(stage2D,navigator);
			loadScreenItem = new ScreenNavigatorItem(UIManager.getInstance().getClassByName(loadName),
				{
					complete: nextID
				},
				{
					nextID: nextID
				});
			navigator.addScreen(loadName,loadScreenItem);
			navigator.addScreen(indexName,new ScreenNavigatorItem(UIManager.getInstance().getClassByName(indexName)));
			navigator.addEventListener(FeathersEventType.TRANSITION_START,onTransitionStart);
			navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE,onTransitionComplete);
			for (var i:int = 0; i < names.length; i++) 
			{
				navigator.addScreen(names[i],new ScreenNavigatorItem(UIManager.getInstance().getClassByName(names[i])));
			}
			nextID = indexName;
			showScreen(indexName);
			if(ChangeEffectClass)
			{
				var efect:* = new ChangeEffectClass(navigator);
				efect.duration = effectDuration;
			}
			return navigator;
		}
		private var transitionComplete:Boolean = true;
		private function onTransitionStart():void
		{
			transitionComplete = false;
		}
		private function onTransitionComplete():void
		{
			transitionComplete = true;
		}
		public function showScreen(screenID:String):void
		{
			if(!transitionComplete)
			{
				return;
			}
			var texturePath:Array = texturePaths[screenID];
			var textureNames:Array = textures[screenID];
			if(textureNames.length == 0)
			{
				navigator.showScreen(screenID);
				return;
			}
			nextID = screenID;
			loadScreenItem.events.complete = nextID;
			navigator.showScreen(loadName);
			
			for (var i:int = 0; i < texturePath.length; i++) 
			{
				_assets.enqueue(texturePath[i]);
			}
			_assets.loadQueue(function(ratio:Number):void
			{
					var loadScreen:BaseLoadScreen = navigator.activeScreen as BaseLoadScreen;
					loadScreen.onProgress(ratio);
					if (ratio == 1)
					{
						BaseLoadScreen(navigator.activeScreen).onComplete();
					}
			});
		}
		public function get stage2D():Stage
		{
			return Starling.current.nativeStage;
		}
	}
}