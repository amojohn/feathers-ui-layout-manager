package dtSound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class Music
	{
		private var _volume:Number = 0;
		private var _sound:Sound = new Sound();
		protected var soundChannel:SoundChannel;
		private var urlRequest:URLRequest = new URLRequest();
		public function Music()
		{
			super();
		}
		
		/** 游戏背景音乐声音大小 **/
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * @private
		 */
		public function set volume(value:Number):void
		{
			_volume = value;
			if(soundChannel)
			{
				var st:SoundTransform=new SoundTransform();
				st.volume = volume;
				soundChannel.soundTransform = st;
			}
		}

		public function get sound():Sound
		{
			return _sound;
		}
		
		public function set sound(value:Sound):void
		{
			_sound = value;
		}
		public function play(source:String):void
		{
			if(urlRequest.url == source)
			{
				return;
			}
			if(soundChannel)
			{
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
			}
			try
			{
				sound.close();
			}
			catch(e:Error)
			{
				trace('声音流关闭失败');
			}
			urlRequest.url = source;
			_sound = new Sound(urlRequest);
			soundChannel = _sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
			var st:SoundTransform=new SoundTransform();
			st.volume = volume;
			soundChannel.soundTransform = st;
		}
		/** 声音播放完成事件 **/
		protected function soundComplete(event:Event):void
		{
			soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
			soundChannel = _sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
			var st:SoundTransform=new SoundTransform();
			st.volume = volume;
			soundChannel.soundTransform = st;
		}
		/** 暂停 **/
		public function stop():void
		{
			if(!soundChannel)
			{
				throw(new Error("声音未开始播放"));
			}
			soundChannel.stop();
		}
	}
}