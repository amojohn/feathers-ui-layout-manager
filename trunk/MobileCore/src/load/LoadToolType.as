package load
{
	import flash.net.URLLoaderDataFormat;
	/**
	 * 资源类型
	 * @author 袁浩
	 * 
	 */
	public final class LoadToolType
	{
		/**
		 * 字节流 
		 */		
		public static const BINARY:String = URLLoaderDataFormat.BINARY;
		/**
		 * 文本 
		 */		
		public static const TEXT:String = URLLoaderDataFormat.TEXT;
		/**
		 * 显示对象 
		 */		
		public static const DISPLAYOBJECT:String = "displayobject";
	}
}