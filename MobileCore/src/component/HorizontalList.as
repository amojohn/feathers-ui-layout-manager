package component
{
	import events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 横向的列表 
	 * @author 袁浩
	 * 
	 */
	public class HorizontalList extends List
	{
		public function HorizontalList($bg:MovieClip, $data:Array, $ItemClass:Class, $gap:int=0, $top:int=0, $left:int=0, $whellNum:uint=20)
		{
			super($bg, $data, $ItemClass, $gap, $top, $left, $whellNum);
		}
		/** 更新列表 */
		public override function update($data:Array=null,$isRemove:Boolean=true):void
		{
			if($data)
				data=$data;
			if($isRemove)
				removeAllItems();
			var item:ListItem;
			var w:int=_left;
			for(var i:int=0;i<data.length;i++)
			{
				if($isRemove)
				{
					item=createItem(i);
					items.push(item);
					item.addParent(_ctn);
				}
				else
				{
					item = items[i];
				}
				item.setProp("y",_top);
				item.setProp("x",w);
				w+=item.getProp("width")+_gap;
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