package component.starling
{
	/**
	 * 加载场景的基类，在加载完成函数里面调用loadComplete即可切换到预显示的场景，加载进度获取请重写onProgress函数
	 * @author 袁浩
	 * 
	 */	
	public class BaseLoadScreen extends BaseScreen
	{
		public var nextID:String;
		public function BaseLoadScreen()
		{
			super();
		}
		private function loadComplete():void
		{
			dispatchEventWith('complete');
		}
		public function onProgress(ratio:Number):void
		{
			
		}
		public function onComplete():void
		{
			loadComplete();
		}
	}
}