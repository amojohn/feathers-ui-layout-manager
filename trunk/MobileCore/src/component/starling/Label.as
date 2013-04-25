package component.starling
{
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	
	import starling.filters.BlurFilter;
	
	public class Label extends feathers.controls.Label
	{
		protected var textFormat:TextFormat = new TextFormat();
		private var _filterColor:uint = 0xFFFFFF;
		private var _filterType:String;
		public function Label()
		{
			super();
		}

		public function get filterType():String
		{
			return _filterType;
		}

		public function get filterColor():uint
		{
			return _filterColor;
		}

		public function set filterColor(value:uint):void
		{
			_filterColor = value;
			filterType = filterType;
		}

		public function set filterType(value:String):void
		{
			_filterType = value;
			if(value == 'glow')
			{
				filter = BlurFilter.createGlow(_filterColor);
			}
			if(value == 'shadow')
			{
				filter = BlurFilter.createDropShadow(4,0.785,_filterColor);
			}
			if(value == 'null')
			{
				filter = null;
			}
		}
		override protected function initialize():void
		{
			textRendererProperties.textFormat = textFormat;
		}
		public function set color(value:Object):void
		{
			textFormat.color = value;
		}
		public function get color():Object
		{
			return textFormat.color;
		}
		
		public function set align(value:String ):void
		{
			textFormat.align = value;
		}
		public function get align():String 
		{
			return textFormat.align;
		}
		
		public function set blockIndent(value:Object):void
		{
			textFormat.blockIndent = value;
		}
		public function get blockIndent():Object
		{
			return textFormat.blockIndent;
		}
		
		public function set bold(value:Object):void
		{
			textFormat.bold = value;
		}
		public function get bold():Object
		{
			return textFormat.bold;
		}
		
		public function set bullet(value:Object):void
		{
			textFormat.bullet = value;
		}
		public function get bullet():Object
		{
			return textFormat.bullet;
		}
		
		public function set font(value:String ):void
		{
			textFormat.font = value;
		}
		public function get font():String 
		{
			return textFormat.font;
		}
		
		public function set indent(value:Object):void
		{
			textFormat.indent = value;
		}
		public function get indent():Object
		{
			return textFormat.indent;
		}
		
		public function set italic(value:Object):void
		{
			textFormat.italic = value;
		}
		public function get italic():Object
		{
			return textFormat.italic;
		}
		
		public function set kerning(value:Object):void
		{
			textFormat.kerning = value;
		}
		public function get kerning():Object
		{
			return textFormat.kerning;
		}
		
		public function set leading(value:Object):void
		{
			textFormat.leading = value;
		}
		public function get leading():Object
		{
			return textFormat.leading;
		}
		
		public function set leftMargin(value:Object):void
		{
			textFormat.leftMargin = value;
		}
		public function get leftMargin():Object
		{
			return textFormat.leftMargin;
		}
		
		public function set letterSpacing(value:Object):void
		{
			textFormat.letterSpacing = value;
		}
		public function get letterSpacing():Object
		{
			return textFormat.letterSpacing;
		}
		
		public function set rightMargin(value:Object):void
		{
			textFormat.rightMargin = value;
		}
		public function get rightMargin():Object
		{
			return textFormat.rightMargin;
		}
		
		public function set size(value:Object):void
		{
			textFormat.size = value;
		}
		public function get size():Object
		{
			return textFormat.size;
		}
		
		public function set underline(value:Object):void
		{
			textFormat.underline = value;
		}
		public function get underline():Object
		{
			return textFormat.underline;
		}
	}
}