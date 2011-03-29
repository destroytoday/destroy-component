package com.destroytoday.component.button
{
	import com.destroytoday.support.TestMouseEvent;
	import com.destroytoday.support.TestSpriteWithStage;
	import com.destroytoday.support.buttonadapter.TestHasCancelledButtonAdapter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.osflash.signals.Signal;

	public class ButtonAdapterTest
	{		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var adapter:ButtonAdapter;
		
		//--------------------------------------------------------------------------
		//
		//  Prep
		//
		//--------------------------------------------------------------------------
		
		[Before(async, timeout=5000)]
		public function setUp():void
		{
			Async.proceedOnEvent(this, prepare(Signal), Event.COMPLETE);
		}
		
		[After]
		public function tearDown():void
		{
			adapter = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Tests
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function adapter_implements_interface():void
		{
			adapter = new ButtonAdapter(new Sprite());
			
			assertThat(adapter is IButtonAdapter);
		}
		
		//--------------------------------------
		//  signals
		//--------------------------------------
		
		[Test]
		public function clicked_signal_removes_all_listeners_when_replaced():void
		{
			adapter = new ButtonAdapter(new Sprite());
			var mockClicked:Signal = nice(Signal);
			
			adapter.clicked = mockClicked;
			adapter.clicked = new Signal(IButtonAdapter);
			
			assertThat(mockClicked, received().method('removeAll').once());
		}
		
		[Test]
		public function state_changed_signal_removes_all_listeners_when_replaced():void
		{
			adapter = new ButtonAdapter(new Sprite());
			var mockStateChanged:Signal = nice(Signal);
			
			adapter.stateChanged = mockStateChanged;
			adapter.stateChanged = new Signal(IButtonAdapter);
			
			assertThat(mockStateChanged, received().method('removeAll').once());
		}
		
		//--------------------------------------
		//  state
		//--------------------------------------
		
		[Test]
		public function state_is_initially_up():void
		{
			adapter = new ButtonAdapter(new Sprite());
			
			assertThat(adapter.state, equalTo(ButtonState.UP));
		}
		
		[Test]
		public function state_notifies_when_changed():void
		{
			adapter = new ButtonAdapter(new Sprite());
			adapter.stateChanged = nice(Signal);

			adapter.state = ButtonState.OVER;
			
			assertThat(adapter.stateChanged, received().method('dispatch').once());
		}
		
		//--------------------------------------
		//  click threshold
		//--------------------------------------
		
		[Test]
		public function click_threshold_is_10_by_default():void
		{
			adapter = new ButtonAdapter(new Sprite());
			
			assertThat(adapter.clickThreshold, equalTo(10.0));
		}
		
		//--------------------------------------
		//  isEnabled
		//--------------------------------------
		
		[Test]
		public function disabling_adapter_changes_target_mouse_enabled_to_false():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.isEnabled = false;
			
			assertThat(!adapter.target.mouseEnabled);
		}
		
		[Test]
		public function disabling_adapter_cancels_click():void
		{
			var adapter:TestHasCancelledButtonAdapter = new TestHasCancelledButtonAdapter(new TestSpriteWithStage());
			
			adapter.isEnabled = false;
			
			assertThat(adapter.hasCancelledClick);
		}
		
		[Test]
		public function disabling_adapter_changes_state_to_disabled():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.isEnabled = false;
			
			assertThat(adapter.state, equalTo(ButtonState.DISABLED));
		}
		
		[Test]
		public function enabling_adapter_changes_state_to_up():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.isEnabled = false;
			adapter.isEnabled = true;
			
			assertThat(adapter.state, equalTo(ButtonState.UP));
		}
		
		//--------------------------------------
		//  cancelClick
		//--------------------------------------
		
		[Test]
		public function cancelling_click_prevents_clicked_from_dispatching():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			adapter.clicked = nice(Signal);
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.cancelClick();
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
			assertThat(adapter.clicked, received().method('dispatch').never());
		}
		
		//--------------------------------------
		//  interaction
		//--------------------------------------
		
		[Test]
		public function rolling_over_target_changes_state_to_over():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			assertThat(adapter.state, equalTo(ButtonState.OVER));
		}
		
		[Test]
		public function rolling_over_then_out_of_target_changes_state_to_up():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			
			assertThat(adapter.state, equalTo(ButtonState.UP));
		}
		
		[Test]
		public function mousing_down_on_target_changes_state_to_down():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			
			assertThat(adapter.state, equalTo(ButtonState.DOWN));
		}
		
		[Test]
		public function mousing_down_on_target_then_rolling_out_changes_state_to_up():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			
			assertThat(adapter.state, equalTo(ButtonState.UP));
		}
		
		[Test]
		public function mousing_down_on_target_then_rolling_out_then_rolling_over_changes_state_to_down():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			assertThat(adapter.state, equalTo(ButtonState.DOWN));
		}
		
		[Test]
		public function mousing_down_then_up_on_target_changes_state_to_over():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
			assertThat(adapter.state, equalTo(ButtonState.OVER));
		}
		
		[Test]
		public function mousing_down_then_up_on_target_within_threshold_dispatches_clicked_signal():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			adapter.clicked = nice(Signal);
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
			assertThat(adapter.clicked, received().method('dispatch').once());
		}
		
		[Test]
		public function mousing_down_on_target_then_up_off_target_changes_state_to_up():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
			assertThat(adapter.state, equalTo(ButtonState.UP));
		}
		
		[Test]
		public function mousing_down_on_target_then_moving_beyond_threshold_changes_state_to_over():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_DOWN, 0.0, 0.0));
			adapter.target.stage.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_MOVE, 11.0, 0.0));

			assertThat(adapter.state, equalTo(ButtonState.OVER));
		}
		
		[Test]
		public function mousing_down_on_target_then_moving_within_threshold_then_mousing_up_on_target_dispatches_clicked_signal():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			adapter.clicked = nice(Signal);
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_DOWN, 0.0, 0.0));
			adapter.target.stage.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_MOVE, 9.0, 0.0));
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));

			assertThat(adapter.clicked, received().method('dispatch').once());
		}
		
		[Test]
		public function mousing_down_on_target_then_moving_beyond_threshold_cancels_click():void
		{
			var adapter:TestHasCancelledButtonAdapter = new TestHasCancelledButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_DOWN, 0.0, 0.0));
			adapter.target.stage.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_MOVE, 11.0, 0.0));

			assertThat(adapter.hasCancelledClick);
		}
		
		[Test]
		public function rolling_over_target_then_disabling_target_changes_state_to_disabled():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			adapter.isEnabled = false;
			
			assertThat(adapter.state, equalTo(ButtonState.DISABLED));
		}
		
		[Test]
		public function rolling_over_then_mousing_down_on_target_then_disabling_target_changes_state_to_disabled():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			
			adapter.isEnabled = false;
			
			assertThat(adapter.state, equalTo(ButtonState.DISABLED));
		}
		
		[Test]
		public function mousing_down_on_target_then_rolling_out_then_disabling_adapter_then_enabling_adapter_then_rolling_over_target_changes_state_to_over():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			
			adapter.isEnabled = false;
			
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
			adapter.isEnabled = true;

			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			assertThat(adapter.state, equalTo(ButtonState.OVER));
		}
		
		[Test]
		public function should_have_up_state_after_tapping_up_then_down_then_rolling_out_then_over():void
		{
			adapter = new ButtonAdapter(new TestSpriteWithStage());
			adapter.clicked = nice(Signal);
			
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			adapter.target.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_DOWN, 0.0, 0.0));
			adapter.target.stage.dispatchEvent(new TestMouseEvent(MouseEvent.MOUSE_MOVE, 11.0, 0.0));
			adapter.target.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			adapter.target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			assertThat(adapter.state, equalTo(ButtonState.OVER));
		}
	}
}