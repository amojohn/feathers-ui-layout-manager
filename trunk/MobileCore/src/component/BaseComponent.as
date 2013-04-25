package component
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	
	/**
	 * 组件基类 
	 * @author Administrator
	 * 
	 */
	public class BaseComponent extends EventDispatcher
	{
		/** 可访问的元素属性 */
		protected var _propList:Array;
		/** UI元素 */
		public var viewUI:*;
		
		public function BaseComponent($bg:InteractiveObject)
		{
			super();
			viewUI=$bg;
			_propList=["x","y","width","height","visible","enabled","alpha"];
		}
		/** 获取元素属性 */
		public function getProp(prop:String):*
		{
			if(_propList.indexOf(prop)>-1)
				return viewUI[prop];
			else
				throw new Error("该属性不存在！");
		}
		/** 设置元素属性 */
		public function setProp(prop:String,value:*,haveEffect:Boolean=false,completeFun:Function=null,duration:Number=0.3,...args):void
		{
			if(_propList.indexOf(prop)>-1)
			{
				if(prop!="width" && prop!="height")
				{
					if(haveEffect)
					{
						if(completeFun != null)
						{							
							TweenLite.to(viewUI,duration,{prop:value,onComplete:completeFun,onCompleteParams:args});
						}
						else
						{
							TweenLite.to(viewUI,duration,{prop:value});
						}
					}
					else
					{
						viewUI[prop]=value;
					}
				}
				else
				{
					viewUI[prop]=value;
				}
			}
			else
			{
				throw new Error("该属性不存在！");
			}
		}
		/** 添加到父元素 */
		public function addParent($parent:DisplayObjectContainer):void
		{
			$parent.addChild(viewUI);
		}
		/** 从父元素移除 */
		public function removeParent($parent:DisplayObjectContainer):void
		{
			$parent.removeChild(viewUI);
		}
		/** 销毁 */
		public function dispose():void
		{
			viewUI = null;
		}
	}
}