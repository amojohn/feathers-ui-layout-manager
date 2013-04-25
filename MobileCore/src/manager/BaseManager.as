package manager
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * 登记式单例类的父类，可继承的单例类s
	 * @author 袁浩
	 */
	public class BaseManager extends EventDispatcher
	{
		private static var _instance:BaseManager;
		private static var _dictionary:Dictionary = new Dictionary();
		/** 
		 * 是否是严格限定，如果严格限定，那么只有BaseManager的子类才能使用getInstance方法
		 * 如果此项为真，getInstance会逐个检查要实例的对象的父类，建议BaseManager的子类不被继承
		 *  **/
		public static const strict:Boolean = true;
		public function BaseManager()
		{
			if(_dictionary[getQualifiedClassName(this)])
			{
				throw(new Error("只允许实例化一次"));
			}
			else
			{
				_dictionary[getQualifiedClassName(this)] = this;
			}
		}
		/**
		 * 获取类的实例。如果为限定模式，该函数只能获取其子类的实例
		 * @pram name 完全限定的基类名称
		 * @return BaseManager
		 * **/
		public static function getInstance(name:String=null):BaseManager
		{
			if(name == null || name == "")
			{
				name = "manager::BaseManager";
			}
			if(_dictionary[name] == null)
			{
				var Manager:Class = getDefinitionByName(name) as Class;
				var mger:* = new Manager();
				var BM:Class = Manager;
				if(strict)
				{
					while(BM != Object)
					{
						BM = getDefinitionByName(getQualifiedSuperclassName(BM)) as Class; 
						if(BM == BaseManager)
						{
							break;
						}
					}
					if(BM == Object)
					{
						throw(new Error("限定模式的BaseManager.getInstance只能获取BaseManager子类的实例"));
						return null;
					}
				}
				_dictionary[name] = mger;
			}
			return _dictionary[name];
		}
	}
}