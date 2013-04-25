package component
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**
	 * 公告按钮文字 袁浩
	 * 
	 */
	public class NoticeText extends BaseComponent
	{
		private var _filer:DropShadowFilter;
		private var _msg:String;
		private const _height:Number = 25;
		/** 移动位置偏移量 **/
		private const _displacementY:uint = 20;
		/** 移动特效毫秒数 **/
		private const _duration:Number = 0.3;
		/** 公告持续显示毫秒数 **/
		private var _time:uint;
		private var _y:Number;
		private var _type:uint;
		/**
		 * 
		 * @param $msg 消息内容
		 * @param $type 消息类型，0错误提示，红色 1成功提示，绿色
		 * @param $filer 滤镜
		 * @param $time 消息持续时间
		 * 
		 */		
		public function NoticeText($msg:String,$type:uint=0,$filer:DropShadowFilter=null,$time:uint=1500)
		{
			viewUI = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.font = "微软雅黑";
			viewUI.defaultTextFormat = tf;
			viewUI.mouseEnabled = false;
			viewUI.text = $msg+"";
			_filer = $filer;
			_time = $time;
			_type = $type;
			setDefaultFilter();
			setDefaultFormat();
			viewUI.mouseEnabled = false;
			super(viewUI);
			init();
		}
		
		protected function init():void
		{
			viewUI.filters = [_filer];
		}
		/** 设置默认滤镜 **/
		protected function setDefaultFilter():void
		{
			if(!_filer)
			{
				_filer = new DropShadowFilter();
				_filer.blurX = 2;
				_filer.blurY = 2;
				_filer.color = 0;
				_filer.distance = 0;
				_filer.strength = 100;
			}
		}
		/** 设置默认字体样式 **/
		protected function setDefaultFormat():void
		{
			var tf:TextFormat = new TextFormat();
			if(_type==1)
			{
				tf.color = 0x00FF00;
			}
			else
			{
				tf.color = 0xFF0000;
			}
			tf.font = "黑体";
			tf.size = 16;
			tf.align = TextFormatAlign.CENTER;
			viewUI.setTextFormat(tf);
		}
		/** 添加到父元素 */
		public override function addParent($parent:DisplayObjectContainer):void
		{
			throw(new Error("此方法禁用"));
		}
		/** 添加到父元素 */
		public override function removeParent($parent:DisplayObjectContainer):void
		{
			throw(new Error("此方法禁用"));
		}
		private var _timeID:uint;
		private static var noticeContainer:DisplayObjectContainer;
		/** 显示公告 */
		public function show():void
		{
			viewUI.width = noticeContainer.stage.stageWidth;
			viewUI.height = _height;
			noticeContainer.addChild(viewUI);
			viewUI.x=(noticeContainer.stage.stageWidth-viewUI.width)/2;
			_y = viewUI.y=(noticeContainer.stage.stageHeight-viewUI.height)/2;
			noticeContainer.addChild(viewUI);
			viewUI.y = _y + _displacementY;
			TweenLite.to(viewUI,_duration,{y:_y});
			_timeID = setTimeout(dispose,_time);
		}
		public static function initContainer(container:DisplayObjectContainer):void
		{
			noticeContainer = container;
			noticeContainer.mouseChildren = false;
			noticeContainer.mouseEnabled = false;
		}
		/** 将公告往上移动_height像素 **/
		public function up():void
		{
			TweenLite.killTweensOf(viewUI);
			TweenLite.to(viewUI,_duration,{y:_y-_height});
			_y -= _height;
		}
		/** 销毁 */
		public override function dispose():void
		{
			noticeList.splice(noticeList.indexOf(this),1);
			clearTimeout(_timeID);
			noticeContainer.removeChild(viewUI);
			super.dispose();
		}
		
		/** 公告列表 **/
		public static var noticeList:Array = [];
		/**
		 *  
		 * @param $stage 舞台
		 * @param $msg 消息内容
		 * @param $type 消息类型，0错误提示，红色 1成功提示，绿色
		 * @param $filer 滤镜
		 * @param $time 消息持续时间
		 * 
		 */		
		public static function createNotice(msg:String,type:uint=0,filer:DropShadowFilter=null,time:uint=1500):void
		{
			updateNoticeY();
			var notice:NoticeText = new NoticeText(msg,type,filer,time);
			notice.show();
			noticeList.push(notice);
		}
		/** 更新公告位置 **/
		private static function updateNoticeY():void
		{
			for(var i:uint;i<noticeList.length;i++)
			{
				noticeList[i].up();
			}
		}
	}
}