package dtSound
{
	import flash.events.Event;

	public class EffectSound extends Music
	{
		public function EffectSound()
		{
			super();
		}
		/** 声音播放完成事件 **/
		override protected function soundComplete(event:Event):void
		{
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
				
			}
			soundChannel = null;
		}
	}
}