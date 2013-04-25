package manager
{
	import dtSound.Music;

	public class SoundManager extends BaseManager
	{
		private var _music:Music;
		private var _effectVolume:Number = 1;
		public function SoundManager()
		{
			super();
		}

		public function get effectVolume():Number
		{
			return _effectVolume;
		}

		public function set effectVolume(value:Number):void
		{
			_effectVolume = value;
		}

		public function get music():Music
		{
			return _music;
		}

		/**
		 * 初始化音乐播放器。
		 * @param stage 要添加到的舞台。
		 * 
		 */		
		public function initMusic(music:Music):void
		{
			_music = music;
		}
		public static function getInstance():SoundManager
		{
			return SoundManager(BaseManager.getInstance("manager::SoundManager"));
		}
		public function playMusic(source:String):void
		{
			music.play(source);
		}
		public function stop():void
		{
			music.stop();
		}
		public function set musicVolume(value:Number):void
		{
			music.volume = value;
		}
		public function get musicVolume():Number
		{
			return music.volume;
		}
		public function playEffect(source:String):void
		{
//			var soundEffect:EffectSound = new EffectSound();
//			soundEffect.volume = effectVolume;
//			soundEffect.play(source);
		}
		public function playButtonEffect():void
		{
//			var soundEffect:EffectSound = new EffectSound();
//			soundEffect.volume = effectVolume;
//			soundEffect.play('assets/sounds/button.mp3');
		}
	}
}