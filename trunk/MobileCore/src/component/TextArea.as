package component
{
	import flash.display.MovieClip;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 文本框 
	 * @author 袁浩
	 * 
	 */
	public class TextArea extends BaseComponent
	{
		/** 内嵌文本 */
		private var _txt:RichTextArea;
		/** 内嵌滚动条 */
		private var _scrollBar:ScrollBar;
		/** 可访问的TextField属性 */
		protected var _txtPropList:Array;
		/** 高度 */
		protected var _height:int;
		/** 字数限制 */
		protected var _limit:int=0;
		
		public function TextArea($bg:MovieClip,$isInput:Boolean=false,$configXML:XML=null,selectable:Boolean = false)
		{
			super($bg);
			_height=viewUI.height;
			_txt=new RichTextArea(viewUI.width,viewUI.height);
			if($configXML)
			{
				_txt.configXML = $configXML;
			}
			_txt.textField.filters = [new DropShadowFilter(0,45,0,1,3,3,1000)];
			_txt.textField.type=$isInput?TextFieldType.INPUT:TextFieldType.DYNAMIC;
			_txt.textField.multiline=true;
			_txt.textField.wordWrap=true;
			_txt.textField.selectable = selectable;
			viewUI.addChild(_txt);
			_scrollBar=new ScrollBar(_txt);
			_scrollBar.addParent(viewUI);
			_scrollBar.setProp("x",viewUI.width-_scrollBar.getProp("width"));
			_scrollBar.setProp("visible",false);
			_txtPropList=["multiline","wordWrap","displayAsPassword","restrict"];
			_txt.addEventListener(TextEvent.TEXT_INPUT,onInput);
		}
		public function set defaultTextFormat($textFormat:TextFormat):void
		{
			_txt.defaultTextFormat = $textFormat;
		}
		public function set filters(filters:Array):void
		{
			_txt.textField.filters = filters;
		}
		public function insertRichText($str:String, $beginIndex:int=-1, $endIndex:int = -1):void
		{
			_txt.insertRichText($str,$beginIndex,$endIndex);
			updateSize();
		}
		public function appendRichText($str:String):void
		{
			_txt.appendRichText($str);
			updateSize();
		}
		public function set limit(value:int):void
		{
			_limit=value;
		}
		public function addTxtEvent(type:String,fun:Function):void
		{
			_txt.addEventListener(type,fun);
		}
		public function removeTxtEvent(type:String,fun:Function):void
		{
			_txt.removeEventListener(type,fun);
		}
		public function appendText(value:String):void
		{
				_txt.appendRichText(value);
		}
		
		private function updateSize():void
		{
			if(_txt.textField.textHeight > _height)
			{
//				_txt.textField.width=_ui.width-_scrollBar.getProp("width");
//				_txt.textField.height = _txt.textField.textHeight+5;
				_txt.resizeTo(viewUI.width-_scrollBar.getProp("width"),_txt.textField.textHeight + 20);
				_scrollBar.setProp("visible",true);
				_scrollBar.onScroll(false);
			}
			else
			{
//				_txt.textField.width=_ui.width;
//				_txt.textField.height = Math.max(_txt.textField.textHeight+5,_height);
				_txt.resizeTo(viewUI.width,Math.max(_txt.textField.textHeight + 20,_height));
				_scrollBar.setProp("visible",false);
			}
		}
		
		private function onInput(event:TextEvent):void
		{
			if(_limit==0)
			{
				return;
			}
			if(_txt.richText.length>_limit)
			{
				_txt.richText=_txt.richText.substr(0,_limit);
			}
		}
		
		/** 获取文本属性 */
		public function getTextProp(prop:String):*
		{
			if(_txtPropList.indexOf(prop)>-1)
				return _txt[prop];
			else
				throw new Error("该属性不存在！");
		}
		/** 设置文本属性 */
		public function setTextProp(prop:String,value:*):void
		{
			if(_txtPropList.indexOf(prop)>-1)
				_txt[prop]=value;
			else
				throw new Error("该属性不存在！");
		}
		
		public override function dispose():void
		{
			_scrollBar.dispose();
			viewUI.removeChild(_txt);
			viewUI=null;
			_txt=null;
			_scrollBar=null;
		}
	}
}