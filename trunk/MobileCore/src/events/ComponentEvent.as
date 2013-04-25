package events
{
	
	import flash.events.Event;

	/**
	 * 组件事件 
	 * @author 袁浩
	 * 
	 */
	public class ComponentEvent extends BaseEvent
	{
		/** Item点击 **/
		public static const ITEM_CLICK:String="itemclick";
		/** 组件索引改变事件 **/
		public static const CHANGE:String="change";
		/**
		 *Item双击事件 
		 */
		public static const ITEM_DOUBLIEClICK:String="itemdoublieclick";
		
		public function ComponentEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, $data, bubbles, cancelable);
		}
	}
}