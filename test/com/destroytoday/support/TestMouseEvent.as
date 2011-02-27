package com.destroytoday.support
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	public class TestMouseEvent extends MouseEvent
	{
		protected var _stageX:Number;
		
		protected var _stageY:Number;
		
		public function TestMouseEvent(type:String, stageMouseX:Number, stageMouseY:Number, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0, commandKey:Boolean=false, controlKey:Boolean=false, clickCount:int=0)
		{
			_stageX = stageMouseX;
			_stageY = stageMouseY;
			
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey, clickCount);
		}
		
		override public function get stageX():Number
		{
			return _stageX;
		}
		
		override public function get stageY():Number
		{
			return _stageY;
		}
	}
}