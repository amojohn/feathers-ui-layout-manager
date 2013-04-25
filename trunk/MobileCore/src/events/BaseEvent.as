package events
{
	import flash.events.Event;
	
	/**
	 * 自定义事件基类 
	 * @author 袁浩
	 * 
	 */
	public class BaseEvent extends Event
	{
		/** 事件数据 */
		public var data:*;
		
		public function BaseEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data=$data;
		}
	}
}