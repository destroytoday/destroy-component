package com.destroytoday.support
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class TestSpriteWithStage extends Sprite
	{
		public function TestSpriteWithStage()
		{
		}
		
		override public function get stage():Stage
		{
			return NativeApplication.nativeApplication.activeWindow.stage;
		}
	}
}