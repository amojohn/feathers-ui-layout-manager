package events
{
	public class UpLoadEvent extends BaseEvent
	{
		public static var PROGRESS:String = 'progress';
		public static var COMPLETE:String = 'complete';
		public function UpLoadEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, $data, bubbles, cancelable);
		}
	}
}