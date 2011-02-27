package
{
	import com.destroytoday.DestroyComponentSuite;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	
	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.flexunit.runner.notification.async.XMLListener;
	
	public class DestroyComponentRunner extends Sprite
	{
		public var core:FlexUnitCore;
		
		public function DestroyComponentRunner()
		{
			core = new FlexUnitCore();
			
            core.addListener(new TraceListener());
            core.addListener(new CIListener());
            core.addListener(new XMLListener());
			
            core.run(DestroyComponentSuite);
			
			core.addEventListener(FlexUnitCore.TESTS_COMPLETE, completeHandler);
		}
		
		protected function completeHandler(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
	}
}