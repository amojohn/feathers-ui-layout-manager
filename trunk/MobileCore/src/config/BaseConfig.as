package config
{
	import flash.utils.Dictionary;
	
	import manager.SourceManager;
	
	import utils.StringUtil;
	
	
	/**
	 * 配置表基类 
	 * @author 袁浩
	 * 
	 */
	public class BaseConfig
	{
		protected var _dataString:String;
		public var data:*;
		public function BaseConfig($name:String)
		{
			_dataString = SourceManager.getInstance().getDataByName($name);
			init();
		}
		
		protected function init():void
		{
			nullDataString();
		}
		/** 将xml数据转换成字典类型 **/
		protected function setXMLDataToDictionary(itemName:String = "item",idName:String='id'):Dictionary
		{
			var data:Dictionary = new Dictionary();
			var list:XMLList = new XML(_dataString).elements(itemName);
			for(var i:int=0;i<list.length();i++)
			{
				var obj:Object = {};
				for(var a:int=0;a<list[i].attributes().length();a++)
				{
					obj[list[i].attributes()[a].name().localName.toString()] = list[i].attributes()[a].toString();
				}
				data[obj[idName]] = obj;
			}
			nullDataString();
			return data;
		}
		/** 将xml数据转换成数组类型 **/
		protected function setXMLDataToArray(itemName:String = "item"):Array
		{
			var data:Array = [];
			var list:XMLList=new XML(_dataString).elements(itemName);
			for(var i:int=0;i<list.length();i++)
			{
				var obj:Object = {};
				for(var a:int=0;a<list[i].attributes().length();a++)
				{
					obj[list[i].attributes()[a].name().localName.toString()] = list[i].attributes()[a].toString();
				}
				data.push(obj);
			}
			nullDataString();
			return data;
		}
		public function getConfig(name:String):BaseConfig
		{
			return SourceManager.getInstance().getConfig(name);
		}
		/**
		 * 将csv数据转换成字典类型
		 * @param idName 主id字段名称
		 * @return 
		 * 
		 */
		protected function setCSVLDataToDictionary(idName:String="id"):Dictionary
		{
			return decodeCSV(0,idName);
		}
		/** 将csv数据转换成数组类型 **/
		protected function setCSVLDataToArray():Array
		{
			return decodeCSV(1);
		}
		/**  解析CSV并填入数据 
		 * @param dataType 解析返回的数据类型，0为字典，1为数组
		 * @param idName 主id字段名称
		 * @return 
		 * 
		 */
//		protected function decodeCSV(dataType:uint,idName:String="id"):*
//		{
//			var data:*;
//			if(dataType == 0)
//			{
//				data = new Dictionary();
//			}
//			else if(dataType == 1)
//			{
//				data = [];
//			}
//			var lines:Array = _xml.toString().split("\n");
//			var propertys:Array = [];
//			var headIndex:uint;
//			for(var i:uint=0;i<lines.length;i++)
//			{
//				if(lines[i].search("//") != -1 && lines[i].search("//as") == -1)
//				{
//					headIndex++;
//					continue;
//				}
//				var tables:Array = lines[i].split("\t");
//				var obj:Object = {};
//				for(var j:uint=0;j<tables.length;j++)
//				{
//					if(i == headIndex)//如果是表头
//					{
//						propertys.push(StringUtil.trim(tables[j]));
//						continue;
//					}
//					if(StringUtil.trim(tables[j]) == "" || StringUtil.trim(tables[j]) == null)
//					{
//						continue;
//					}
//					else
//					{
//						if(propertys[j].search("//as") == -1)
//						{
//							obj[propertys[j]] = StringUtil.trim(tables[j]);//设置元素属性和值
//						}
//						else
//						{
//							obj[propertys[j].substring(4)] = StringUtil.trim(tables[j]);//设置元素属性和值
//						}
//					}
//				}
//				if(i == headIndex)//如果是表头
//				{
//					continue;
//				}
//				if(dataType == 0)
//				{
//					data[obj[idName]] = obj;
//				}
//				else if(dataType == 1)
//				{
//					data.push(obj);
//				}
//			}
//			return data;
//		}
		protected function decodeCSV(dataType:uint,idName:String="id"):*
		{
			var data:*;
			if(dataType == 0)
			{
				data = new Dictionary();
			}
			else if(dataType == 1)
			{
				data = [];
			}
			var lines:Array = _dataString.split("\n");
			var propertys:Array = [];
			for(var i:uint=0;i<lines.length;i++)
			{
				if(lines[i].search("//") != -1 && lines[i].search("//as") == -1)
				{
					continue;
				}
				var isHeader:Boolean;
				isHeader = (lines[i].search("//as") >= 0);
				var tables:Array = lines[i].split("\t");
				var obj:Object = {};
				for(var j:uint=0;j<tables.length;j++)
				{
					if(isHeader)//如果是表头
					{
						propertys.push(StringUtil.trim(tables[j]));
					}
					if(StringUtil.trim(tables[j]) == "" || StringUtil.trim(tables[j]) == null || tables[j].search("//as") != -1)
					{
						continue;
					}
					else
					{
						if(propertys[j].search("//as") != -1)
						{
							obj[propertys[j].substring(4)] = StringUtil.trim(tables[j]);//设置元素属性和值
						}
						else
						{
							obj[propertys[j]] = StringUtil.trim(tables[j]);//设置元素属性和值
						}
					}
				}
				if(obj[idName])
				{
					if(dataType == 0)
					{
						data[obj[idName]] = obj;
					}
					else if(dataType == 1)
					{
						data.push(obj);
					}
				}
			}
			return data;
		}
		/** 删除数据 */
		protected function nullDataString():void
		{
			_dataString=null;
		}

		/** 对应的数据 */
		public function get dataString():String
		{
			return _dataString;
		}

	}
}