package com.destroytoday.component.button
{
	import flash.display.InteractiveObject;
	
	import org.osflash.signals.ISignal;

	public interface IButtonAdapter
	{
		function get clicked():ISignal;
		function get stateChanged():ISignal;
		
		function get target():InteractiveObject;
		function set target(value:InteractiveObject):void;
		
		function get state():IButtonState;
		function set state(value:IButtonState):void;
		
		function get isEnabled():Boolean;
		function set isEnabled(value:Boolean):void;
		
		function get clickThreshold():Number;
		function set clickThreshold(value:Number):void;
	}
}