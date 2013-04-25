package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class tool
	{
		public static function scaleModeAuto(parent:*,child:*):Point
		{
			var parentWidth:Number;
			var parentHeight:Number;
			if(parent is Stage)
			{
				parentWidth = parent.stageWidth;
				parentHeight = parent.stageHeight;
			}
			else
			{
				parentWidth = parent.width;
				parentHeight = parent.height;
			}
			if(parentWidth-child.width < parentHeight-child.height)
			{
				child.scaleY += parentWidth/child.width - child.scaleX;
				child.scaleX = parentWidth/child.width;
			}
			else if(parentWidth-child.width > parentHeight-child.height)
			{
				child.scaleX += parentHeight/child.height - child.scaleY;
				child.scaleY = parentHeight/child.height;
			}
			return new Point(child.scaleX,child.scaleY);
		}
		public static function scaleModeFull(parent:*,child:*):Point
		{
			var parentWidth:Number;
			var parentHeight:Number;
			if(parent is Stage)
			{
				parentWidth = parent.fullScreenWidth;
				parentHeight = parent.fullScreenHeight;
			}
			else
			{
				parentWidth = parent.width;
				parentHeight = parent.height;
			}
			child.scaleX = parentWidth/child.width;
			child.scaleY = parentHeight/child.height;
			return new Point(child.scaleX,child.scaleY);
		}
		/**
		 * 运行某个对象或者类中的函数。如果是空对象则不会执行。
		 * 
		 * @param obj 一个对象的实例或者一个构造函数中无参数的类，类会自动实例化。
		 * @param funName 要运行的函数名
		 * @param params 要运行的函数的参数
		 * @return 
		 * 
		 */
		public static function runFun(obj:*,funName:String,...params):*
		{
			if(!obj)
			{
				return;
			}
			var object:*;
			if(obj is Class)
			{
				object = new Object();
			}
			else
			{
				object = obj;
			}
			var fun:Function = obj[funName];
			fun.apply(obj,params);
		}
		/**
		 * 获取操作系统类型 
		 * 如果0为pc，1为手机
		 */		
		public static function getOSType():uint
		{
			if(Capabilities.manufacturer.toLowerCase().indexOf('ios') > -1)
			{
				return 1;
			}
			if(Capabilities.manufacturer.toLowerCase().indexOf("android") > -1)
			{
				return 1;
			}
			return 0;
		}
		/** 关闭浏览器窗口 **/
		public static function closeWebWin():void
		{
			ExternalInterface.call("window.close()");
		}
		/** 加入收藏 **/
		public static function joinCollect(url:String,name:String):void
		{
			var fun:String = "window.external.addFavorite";
			ExternalInterface.call(fun,url,name);
		}
		/** 水平翻转 */
		public static function flipHorizontal(dsp:flash.display.DisplayObject,isCenter:Boolean=true):void
		{
			var matrix:Matrix = dsp.transform.matrix;
			matrix.a*=-1;
			if(!isCenter)
			{
				matrix.tx=dsp.width+dsp.x;
			}
			dsp.transform.matrix=matrix;
		}
		/** 垂直翻转 */
		public static function flipVertical(dsp:flash.display.DisplayObject,isCenter:Boolean=true):void
		{
			var matrix:Matrix = dsp.transform.matrix;
			matrix.d*=-1;
			if(!isCenter)
			{
				matrix.ty=dsp.height+dsp.y;
			}
			dsp.transform.matrix=matrix;
		}
		/**
		 * 实现C语言的printf，用%0,%1...来表示后面的参数，%用%%表示
		 * @param str 要输出的句型
		 * @param args 句型中的变量
		 * @return 格式化后的字符串
		 * 
		 */
		public static function printf(str:String,... args):String
		{
			for(var i:int=0;i<args.length;i++)
			{
				var key:String="%"+i;
				var index:int;
				var ti:int=0;
				do
				{
					index=str.indexOf(key,ti);
					ti=index+1;
					//当%i前面不为%与才执行替换
					if(index>0)
					{
						if(str.charAt(index-1)!="%")
						{
							str=str.substr(0,index)+str.substr(index).replace(key,args[i]);
						}
					}
					else if(index==0)
						str=str.replace(key,args[i]);
				}while(index>-1);
			}
			str=str.replace(/%%/g,"%");
			return str;
		}
		
		/**
		 * 添0补位 
		 * @param format 字符格式，用#号 
		 * @param num 需要加工的数字
		 * @return 加工后的字符
		 * 
		 */
		public static function addZero(format:String,num:Number):String
		{
			var len:int=format.length;
			var tenp:Number=Math.pow(10,len);
			num+=tenp;
			var str:String=num.toString();
			str=str.substr(1);
			return str;
		}
		/** 图片置灰 */
		public static function gray(obj:flash.display.DisplayObject):void
		{
			var ar:Array=[
				0.3086, 0.6094, 0.0820, 0, 0, 
				0.3086, 0.6094, 0.0820, 0, 0, 
				0.3086, 0.6094, 0.0820, 0, 0, 
				0, 0, 0, 1, 0
			];
			obj.filters=[new ColorMatrixFilter(ar)];
		}
		/**
		 * 图片颜色处理 
		 * @param obj 图片
		 * @param colorRGB 饱和度,为0时消失
		 * @param lightRGB 亮度, 为255是过亮, 为-255时过暗
		 * 
		 */		
		public static function colorHandle(obj:flash.display.DisplayObject,colorRGB:Array,lightRGB:Array):void
		{
			//默认值无改变,以上三种都为255则过亮,即变成白色,为-255则过暗,变成黑色
			
			var cR:Number = ((255 - colorRGB[0])/255)*0.33;
			var cG:Number = ((255 - colorRGB[1])/255)*0.33;
			var cB:Number = ((255 - colorRGB[2])/255)*0.33;
			var array:Array = 
				[1 - 2*cR, cG, cB, 0, lightRGB[0],
					cR, 1 - 2*cG, cB, 0, lightRGB[1],
					cR, cG, 1 - 2*cB, 0, lightRGB[2],
					0, 0, 0, 1, 0];
			obj.filters = [new ColorMatrixFilter(array)];
		}
		/**
		 * 拷贝数组 
		 * @param originalArray 原始数组
		 * @param startIndex 开始拷贝的位置。您可以用一个负整数来指定相对于数组结尾的位置（例如，-1 是数组的最后一个元素）。
		 * @param length 一个整数，它指定要拷贝的元素数量。如果参数的值为0，则该方法将拷贝从 startIndex 元素到数组中最后一个元素的所有值。
		 * @return 拷贝后产生的新的数组。
		 * 
		 */		
		public static function copyArray(originalArray:Array,startIndex:int=0,length:uint=0):Array
		{
			var concatArray:Array = originalArray.concat();
			if(length != 0)
			{
				return concatArray.splice(startIndex,length);
			}
			else
			{
				return concatArray.splice(startIndex);
			}
		}
		/**
		 * 将一个数组的值设置到另一个数组 
		 * @param copyArray 待改变值的数组
		 * @param originalArray 设置给别人值的数组
		 * @param copyStartIndex 待改变值的数组的索引位置
		 * @param oriStartIndex 设置给别人值的数组的索引位置
		 * @param length 设置的长度
		 * 
		 */		
		public static function setArray(copyArray:Array,originalArray:Array,copyStartIndex:uint = 0,oriStartIndex:int=0,length:uint=0):void
		{
			for (var i:int = 0; i < length; i++) 
			{
				copyArray[copyStartIndex + i] = originalArray[oriStartIndex + i];
			}
		}
		/** 发光滤镜 */
		public static function whiteGlow(obj:flash.display.DisplayObject):void
		{
			var _filter:GlowFilter = new GlowFilter();
			_filter.blurX = 5;
			_filter.blurY =5;
			_filter.quality = 1;
			_filter.alpha = 1;
			_filter.color=0xFFFFFF;
			obj.filters = [ _filter ];
		}
		/** 清空滤镜 */
		public static function delGlow(obj:flash.display.DisplayObject):void
		{
			obj.filters = null;
		}
		/** 倒影 **/
		public static function createRef(p_source : flash.display.DisplayObject):Bitmap
		{
			//对源显示对象做上下反转处理
			var bd:BitmapData=new BitmapData(p_source.width,p_source.height,true,0);
			var mtx:Matrix=new Matrix();
			mtx.d = -1;
			mtx.ty = bd.height;
			bd.draw(p_source,mtx);
			
			//生成一个渐变遮罩
			var width:int=bd.width;
			var height:int=bd.height;
			mtx=new Matrix();
			mtx.createGradientBox(width,height,0.5 * Math.PI);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0.9, 0.2],[0, 255],mtx)
			shape.graphics.drawRect(0,0,width,height);
			shape.graphics.endFill();
			var mask_bd:BitmapData=new BitmapData(width,height,true,0);
			mask_bd.draw(shape);
			
			//生成最终效果
			bd.copyPixels(bd,bd.rect,new Point(0,0),mask_bd,new Point(0,0),false);
			var ref:Bitmap=new Bitmap(bd);
			return ref;
		}
		
		/** 获得字符串字节数，汉字等字符串字节数不能通过String.length获取就用此方法 **/
		public static function getStringLength(thisString:String,strCharset:String="gb2312"):uint
		{
			var thisStringBytsLength :ByteArray = new ByteArray();
			thisStringBytsLength.writeMultiByte(thisString,strCharset);
			return thisStringBytsLength.length;
		}
		
		/** 字符串编码gb2312转成utf-8 **/
		public static function urlencodeGB2312(str:String):String
		{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"gb2312");
			for(var i:int;i<byte.length;i++)
			{
				result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}
		/**
		 * 读取Long型 
		 * @return 
		 * 
		 */
		public static function readLong(data:ByteArray) : Number
		{
			return  ((data.readByte() & 255)) + 
				((data.readByte() & 255) * 256) +
				((data.readByte() & 255) * 65536) + 
				((data.readByte() & 255) * 16777216) +
				((data.readByte() & 255) * 4294967296) +
				((data.readByte() & 255) * 1099511627776) +
				((data.readByte() & 255) * 281474976710656) +
				((data.readByte() & 255) * 72057594037927936);
		}
		
		/**
		 * 写入Long型 
		 * @param value
		 * 
		 */
		public static function writeLong(data:ByteArray,value:Number) : void
		{
			data.writeInt(value);
			data.writeUnsignedInt(0);
		}

		/** 二进制转换字符串 **/
		public static function traceByteArray(byteArray:ByteArray,length:uint = 0,type:String=""):String
		{
			if(length == 0)
			{
				length = byteArray.length;
			}
			var str:String="";
			for(var i:int=0;i<length;i++)
			{
				str = str.concat(type+"["+i+"] = "+(int(byteArray[i])-256)+"\n");
			}
			trace(str);
			return str;
		}
		/** uint转换成ushort **/
		public static function unitToushort(uintValue:uint):uint
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeShort(uintValue);
			byteArray.position = 0;
			var shortValue:uint = byteArray.readUnsignedShort();
			return shortValue;
		}
		/** 改变鼠标指针-sdk4.0 **/
		/*public static function changeMouseStyle(bitmapData:BitmapData):void
		{
			var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
			cursorData.push(bitmapData);
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			mouseCursorData.data = cursorData;
			Mouse.registerCursor("mymouse",mouseCursorData);
			Mouse.cursor = "mymouse";
		}*/
		/** 还原鼠标指针-sdk4.0 **/
		/*public static function defaultMouseStyle():void
		{
			Mouse.unregisterCursor("mymouse");
		}*/
		/** 格式化时间 [0:0:0],[时,分,秒] **/
		public static function formattTime(time:Array,formatt:Array,zeroHave:Boolean=false):String
		{
			var timeStr:String="";
			if(time[0]!=0&&!zeroHave)
			{
				timeStr += time[0] + formatt[0];
			}
			if(time[1]!=0&&!zeroHave)
			{
				timeStr += time[1] + formatt[1];
			}
			return timeStr + time[2] +formatt[2];
		}
		/** 给出字符串，运算出结果 **/
		private static var re1:RegExp=/\(([^()]*)\)/;
		private static var re2:RegExp=/(-?[.\d]+)([*\/])(-?[.\d]+)/;
		private static var re3:RegExp=/(-?[.\d]+)([+\-])(-?[.\d]+)/;
		public static function compute(str:String):Number
		{
			str="("+str.replace(/[^().+*\-\/\d]+/g,"")+")";
			while(re1.test(str))str=str.replace(re1,repl1);
			return Number(str);
		}
		
		private static function repl1(s:String,a:String,...args):String
		{
			while(re2.test(a))a=a.replace(re2,repl2);
			while(re3.test(a))a=a.replace(re3,repl2);
			return a;
		}
		/** 向字节流中插入数据 **/
		public static function insertBytes(bytes:ByteArray,insert:ByteArray,position:uint):void
		{
			var cachBytes1:ByteArray = new ByteArray();
			var cachBytes2:ByteArray = new ByteArray();
			bytes.position = 0;
			if(position!=0)
			{
				bytes.readBytes(cachBytes1,0,position);
			}
			bytes.readBytes(cachBytes2);
			bytes.position = 0;
			bytes.writeBytes(cachBytes1);
			bytes.writeBytes(insert);
			bytes.writeBytes(cachBytes2);
		}		
		private static function repl2(s:String,a:String,b:String,c:String,...args):String
		{
			if(b=="+")return String(Number(a)+Number(c));
			if(b=="-")return String(Number(a)-Number(c));
			if(b=="*")return String(Number(a)*Number(c));
			return String(Number(a)/Number(c));
		}
		/** 获取浏览器地址中的参数 **/
		public static function getParameterValue(key:String,decode:Boolean=false):String
		{ 
			var value:String;
			var uparam:String = ExternalInterface.call("window.location.search.toString");
			if(decode)
			{
				uparam = decodeURI(ExternalInterface.call("window.location.search.toString"));
			}
			if(uparam==null)
			{
				return null;
			}
			var paramArray:Array = uparam.split('&');
			for(var x:int=0; x<paramArray.length; x++)
			{
				var p:String = paramArray[x];
				if(p.indexOf(key + '=')>-1)
				{
					value = (p.replace((key + '='), '')).replace('?','');
					x=paramArray.length;
				}
			}
			return value;
		}
		/** 随机从数组中取出一个值 **/
		public static function getRandomFromArray(array:Array):*
		{
			return array[int(Math.random()*(array.length))];
		}
		/** 颜色值转字符串 **/
		public static function convertUintToString(color:uint):String
		{
			return "#"+color.toString(16);
		}
		/** 字符串转换成颜色值 **/		
		public static function convertStringToUint(color:String):uint
		{
			return parseInt("0x"+color.substr(1,color.length));
		}
		/** vector转换成array **/
		public static function vectorToArray(vector:*):Array
		{
			var array:Array=new Array();
			var callback:Function = 
			function (item:*, index:int, vector:*):Boolean
			{
				array.push(item);
				return true;
			}
			vector.every(callback);
			return array;
		}
		/** 居中 **/
		public static function centerDisPlayObj(display:flash.display.DisplayObject,parent:DisplayObjectContainer = null):void
		{
			if(!parent)
			{
				parent = display.parent;
			}
			display.x = (parent.width - display.width)/2;
			display.y = (parent.height - display.height)/2;
		}
		/** 两个十六进制转成成字符串再相加 **/
		public static function connectNum16ToString(num1:uint,num2:uint):String
		{
			return num1.toString(16)+num2.toString(16);
		}
		/** 舞台居中 **/
		public static function centerDisPlayObjByStage(display:flash.display.DisplayObject,stage:Stage):void
		{
			display.x = (stage.stageWidth - display.width)/2;
			display.y = (stage.stageHeight - display.height)/2;
		}
		/**从Array转换为vector**/
		public static function arrayToVector(array:Array,vector:*):void
		{
			vector.push.apply(null,array);
		}
		/** 获取property对象名称 **/
		public static function getObjectName(parent:Object,property:Object):String
		{
			var propertyName:String;
			for(var key:String in parent)
			{
				if(parent[key] == property.valueOf())
				{
					propertyName = key;
				}
			}
			return propertyName;
		}
		/** 执行一个函数所需毫秒数 **/
		public static function runFunTime(fun:Function,...pram):int
		{
			var time:int = getTimer();
			fun(pram);
			return getTimer() - time;
		}
		/** 移除显示对象所有子控件 **/
		public static function removeAll(obj:DisplayObjectContainer):void
		{
			if(obj)
			{
				while(obj.numChildren)
				{
					obj.removeChildAt(obj.numChildren-1)
				}
			}
		}
		/** 全屏/取消全屏 **/
		public static function fullScene(stage:Stage):void
		{
			if(stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		/** 将一个动态对象的属性值复制到另一个对象中 **/
		public static function copyAttribute(fromObj:Object,toObject:*):void
		{
			for(var key:String in fromObj)
			{
				toObject[key] = fromObj[key];
			}
		}
		/** 获取两个字符串之间的字符串 **/
		public static function getString(str:String,str1:String,str2:String,type:uint = 0):String
		{
			var startIndex:uint = str.indexOf(str1) + str1.length;
			if(str1 == null || str1.length == 0)
			{
				startIndex = 0;
			}
			var endIndex:uint = str.indexOf(str2);
			if(str2 == null || str2.length == 0)
			{
				endIndex = str.length;
			}
			if(type == 1)
			{
				endIndex = str.lastIndexOf(str2);
			}
			return str.substring(startIndex,endIndex);
		}
		/** 传入页数和数组，返回该页码对应的数据段 
		 *  @param perPageNum 每页显示多少条
		 *  @param pageNum    获取第几页数据
		 * **/
		public static function getDataByPage(arr:Array,perPageNum:int,pageNum:int):Array
		{
			var backArr:Array = new Array();
			var beg:int = (pageNum-1)*perPageNum;
			var end:int = beg+perPageNum;
			var newEnd:int = end>=arr.length ? arr.length : end;
			for(var i:int=beg; i<newEnd; i++)
			{
				backArr.push(arr[i]);
			}
			return backArr;
		}
		/**传入数字mc和数组，将数字转转成mc来表示
		 * args : 第一个是数字的最末端mc (最低位的数字mc) ，最后一个是数字的最前端mc（最高位的数字mc）
		 * */
		public static function opmNumMc(intval:int,...args):void
		{
			for each(var mc:MovieClip in args)
			{
				mc.gotoAndStop(1);
			}
			var intStr:String = intval.toString();
			for(var i:int=0,cnt:int=intStr.length; i<cnt; i++)
			{
				var str:String = intStr.charAt(i);
				args[i].gotoAndStop(parseInt(str)+1);
			}
		}
		/**
		 * 获取当前ApplicationDomain内的类定义		 * 
		 * name类名称
		 * info加载swf的LoadInfo，不指定则从当前域获取
		 * return获取的类定义，如果不存在返回null
		 */
		public static function getClass(name:String, domain:ApplicationDomain = null):Class 
		{
			try 
			{
				if (domain == null) 
				{
					return ApplicationDomain.currentDomain.getDefinition(name) as Class;
				}
				return domain.getDefinition(name) as Class;
			} 
			catch (e:ReferenceError) 
			{
				return null;
			}
			return null;
		}
		/** 获取SWF中的mc实例 **/
		public static function getMovieClip(name:String):MovieClip
		{
			var mcClass:Class = getClass(name);
			var mc:MovieClip;
			if(mcClass)
			{
				mc = (new mcClass()) as MovieClip;
			}
			return mc;
		}
	}
}