package manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import view.BaseScene;

	public class SceneManager extends BaseManager
	{
		private var _sceneContainer:Sprite;
		private var _curScene:BaseScene;
		public function SceneManager()
		{
			super();
		}

		public function get sceneContainer():Sprite
		{
			return _sceneContainer;
		}

		public function get curScene():BaseScene
		{
			return _curScene;
		}

		/**
		 * 初始化所有场景的容器。
		 * @param stage 要添加到的舞台。
		 * 
		 */		
		public function initContainer(contain:Sprite):DisplayObjectContainer
		{
			_sceneContainer = new Sprite();
			contain.addChild(_sceneContainer);
			return _sceneContainer;
		}
		public static function getInstance():SceneManager
		{
			return SceneManager(BaseManager.getInstance("manager::SceneManager"));
		}
		public function changeScene(scene:BaseScene):void
		{
			if(_curScene)
			{
				_curScene.dispose();
				_curScene = null;
			}
			if(scene)
			{
				_curScene = scene;
				_sceneContainer.addChild(_curScene);
			}
		}
	}
}