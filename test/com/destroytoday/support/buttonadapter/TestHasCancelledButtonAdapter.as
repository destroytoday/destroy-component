package com.destroytoday.support.buttonadapter
{
	import com.destroytoday.component.button.ButtonAdapter;
	
	import flash.display.InteractiveObject;
	
	public class TestHasCancelledButtonAdapter extends ButtonAdapter
	{
		public var hasCancelledClick:Boolean;
		
		public function TestHasCancelledButtonAdapter(target:InteractiveObject)
		{
			super(target);
		}
		
		override public function cancelClick():void
		{
			hasCancelledClick = true;
			
			super.cancelClick();
		}
	}
}