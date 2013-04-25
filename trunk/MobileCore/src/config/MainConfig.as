package config
{
	

	/**
	 * 主配置表 
	 * @author 袁浩
	 * 
	 */
	public class MainConfig extends BaseConfig
	{
		public function MainConfig($name:String)
		{
			super($name);
		}
		
		protected override function init():void
		{
			nullDataString();
		}
	}
}