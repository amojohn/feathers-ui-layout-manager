package load
{
	import flash.events.Event;
	/**
	 * 资源事件
	 * @author 袁浩
	 * 
	 */	
	public class LoadToolEvent extends Event
	{
		/**
		 * 资源对象
		 */		
		public var loadToolItem:LoadToolItem;
		/**
		 * 加载完成事件 
		 */		
		public static const LOAD_COMPLETE:String = "load_complete";
		/**
		 * 加载进度事件 
		 */		
		public static const LOAD_PROGRESS:String = "load_grogress";
		/**
		 * 单挑加载完成事件
		 */		
		public static const LOADONE_COMPLETE:String = "loadone_grogress";
		/**
		 * 当错误导致输入或输出操作失败时调度。如果您没有为对象添加此事件则会抛出异常。
		 */		
		public static const LOAD_IO_ERROR:String = "load_io_error";
		/**
		 * 创建一个资源事件对象 
		 * @param type 事件类型
		 * @param resourceItem 资源对象
		 * @param bubbles 确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false 
		 * @param cancelable 确定是否可以取消 Event 对象。默认值为 false。 
		 * 
		 */		
		public function LoadToolEvent(type:String,resourceItem:LoadToolItem=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.loadToolItem = resourceItem;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var event:LoadToolEvent = new LoadToolEvent(type,loadToolItem,bubbles,cancelable);
			return event;
		}
		
		
	}
}