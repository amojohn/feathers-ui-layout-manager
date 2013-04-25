package component.starling
{
	
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Alert extends Canvas
	{
		private var tilteLabel:Label;
		private var infoLabel:Label;
		private var btnBox:HBox;
		public static var instance:Alert;
		/** 确定按钮 */
		private var btnOK:Button;
		/** 取消按钮 */
		private var btnCancel:Button;
		public static var okLabel:String = '确认';
		public static var cancelLabel:String = '取消';
		/** 确定的回调函数 */
		public var funOK:Function;
		/** 取消的回调函数 */
		public var funCancel:Function;
		[Embed(source="/image/alertBg.png")]
		private var Bg:Class;
		[Embed(source="/image/alertBottom.png")]
		private var Bottom:Class;
		[Embed(source="/image/button-default-skin.png")]
		private var BottomDefaultSkin:Class;
		[Embed(source="/image/button-down-skin.png")]
		private var BottomDownSkin:Class;
		private static var container:DisplayObjectContainer;
		public function Alert()
		{
			super();
			width = 404;
			height = 204;
			var bottom:starling.display.Image = new starling.display.Image(Texture.fromBitmap(new Bottom()));
			bottom.x = 4;
			bottom.y = 140;
			addChild(bottom);
			var bg:starling.display.Image = new starling.display.Image(Texture.fromBitmap(new Bg()));
			bg.alpha = 0.9;
			addChild(bg);
			
			tilteLabel = new Label();
			tilteLabel.width = 362;
			tilteLabel.text = '提示信息';
			tilteLabel.size = 30;
			tilteLabel.color = 0xffffff;
			tilteLabel.font = '微软雅黑';
			tilteLabel.x = tilteLabel.y = 20;
			addChild(tilteLabel);
			
			infoLabel = new Label();
			infoLabel.width = 350;
			infoLabel.x = 30;
			infoLabel.y = 65;
			infoLabel.height = 50;
			infoLabel.size = 20;
			infoLabel.color = 0xffffff;
			infoLabel.font = '微软雅黑';
			addChild(infoLabel);
			
			btnBox = new HBox();
			btnBox.width = 396;
			btnBox.height = 60;
			btnBox.x = 4;
			btnBox.y = 150;
			btnBox.horizontalAlign = 'center';
			btnBox.gap = 30;
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 20;
			txtFormat.font = '微软雅黑';
			btnOK = new Button();
			btnOK.defaultLabelProperties.textFormat = txtFormat;
			btnOK.defaultSkin = new starling.display.Image(Texture.fromBitmap(new BottomDefaultSkin()));
			btnOK.downSkin = new starling.display.Image(Texture.fromBitmap(new BottomDownSkin()));
			btnCancel = new Button();
			btnCancel.defaultLabelProperties.textFormat = txtFormat;
			btnCancel.defaultSkin = new starling.display.Image(Texture.fromBitmap(new BottomDefaultSkin()));
			btnCancel.downSkin = new starling.display.Image(Texture.fromBitmap(new BottomDownSkin()));
			btnBox.addChild(btnOK);
			btnBox.addChild(btnCancel);
			addChild(btnBox);
			btnOK.addEventListener(Event.TRIGGERED,onOK);
			btnCancel.addEventListener(Event.TRIGGERED,onCancel);
		}
		private function onOK(event:Event):void
		{
			if(funOK!=null)
			{
				funOK();
			}
			close();
		}
		private function onCancel(event:Event):void
		{
			if(funCancel!=null)
			{
				funCancel();
			}
			close();
		}
		/** 初始化对话框 */
		public static function initAlert(container:DisplayObjectContainer):void
		{
			instance = new Alert();
			container.visible = false;
			Alert.container = container;
		}
		private function close():void
		{
			container.visible = false;
			container.removeChild(instance);
		}
		public static function show(info:String,title:String='提示信息',type:int=0,funOK:Function=null,funCancel:Function=null):void
		{
			instance.infoLabel.text = info;
			instance.tilteLabel.text = title;
			instance.btnBox.removeChildren();
			instance.layout(type);
			instance.funOK=funOK;
			instance.funCancel=funCancel;
			container.addChild(instance);
			container.visible = true;
			scaleAuto(container,instance);
			instance.x = container.width/2 - instance.scaleX * instance.width/2;
			instance.y = container.height/2 - instance.scaleY * instance.height/2;
		}
		
		private static function scaleAuto(parent:DisplayObject,child:DisplayObject):Point
		{
			child.scaleY += parent.width/(child.width + child.width/4) - child.scaleX;
			child.scaleX = parent.width/(child.width + child.width/4);
			return new Point(child.scaleX,child.scaleY);
		}
		private function layout(type:int):void
		{
			btnOK.label = okLabel;
			btnCancel.label = cancelLabel;
			switch(type)
			{
				case AlertType.OK:
					instance.btnBox.addChild(btnOK);
					break;
				case AlertType.YES_NO:
					instance.btnBox.addChild(btnOK);
					instance.btnBox.addChild(btnCancel);
					break;
			}
		}
		/** 设置按钮文字 */
		public static function setButtonText(okText:String,cancelText:String=""):void
		{
			if(okText!="")
			{
				instance.btnOK.label = okText;
			}
			if(cancelText!="")
			{
				instance.btnCancel.label = cancelText;
			}
		}
	}
}