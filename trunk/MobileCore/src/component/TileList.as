package component
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * 带横向和纵向的列表 
	 * @author 袁浩
	 * 
	 */
	public class TileList extends List
	{
		private var _hgap:int;
		private var _vgap:int;
		public function TileList($bg:DisplayObjectContainer, $data:Array, $ItemClass:Class,$hgap:int = 80, $vgap:int=80,$top:int=0,$left:int=0,$whellNum:uint=20)
		{
			_vgap = $vgap;
			_hgap = $hgap;
			super($bg, $data, $ItemClass, 0,$top,$left,$whellNum);
		}
		/** 更新列表 */
		public override function update($data:Array=null,$isRemove:Boolean=true):void
		{
			if($data)
				data=$data;
			if($isRemove)
				removeAllItems();
			var item:ListItem;
			var h:int=0;
			var w:int=0;
			var a:int=0;
			for(var i:int=0;i<data.length;i++)
			{
				if($isRemove)
				{
					item=createItem(i);
					items.push(item);
					item.addParent(_ctn);
					item.addEventListener(MouseEvent.CLICK,onClick);
				}
				else
				{
					item = items[i];
				}
				w = item.getProp("width")*a+_hgap*a+_left;
				if(w+item.getProp("width") > viewUI.width)
				{
					w = _left;
					a = 0;
					h++;
				}
				item.setProp("x",w);
				item.setProp("y",item.getProp("height")*h+_vgap*h+_top);
				a++;
				item.data = data[i];
			}
			if(items.length>0)
			{
				selectItem = items[0];
			}
//			if(_ctn.height>_height)
//			{
//				_scrollBar.setProp("visible",true&&showScrollBar);
//				_scrollBar.onScroll();
//			}
//			else
//			{
//				_scrollBar.setProp("visible",false&&showScrollBar);
//			}
		}
	}
}