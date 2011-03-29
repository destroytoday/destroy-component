/*
Copyright (c) 2011 Jonnie Hallman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.destroytoday.component.button
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ButtonAdapter implements IButtonAdapter
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		protected var _clicked:Signal;
		
		public function get clicked():ISignal
		{
			return _clicked ||= new Signal(IButtonAdapter);
		}
		
		public function set clicked(value:ISignal):void
		{
			if (value == _clicked)
				return;
			
			if (_clicked)
				_clicked.removeAll();
			
			_clicked = value as Signal;
		}
		
		protected var _stateChanged:Signal;
		
		public function get stateChanged():ISignal
		{
			return _stateChanged ||= new Signal(IButtonAdapter);
		}
		
		public function set stateChanged(value:ISignal):void
		{
			if (value == _stateChanged)
				return;
			
			if (_stateChanged)
				_stateChanged.removeAll();
			
			_stateChanged = value as Signal;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:InteractiveObject;
		
		protected var _state:IButtonState = ButtonState.UP;
		
		protected var _clickThreshold:Number = 10.0;
		
		//--------------------------------------
		// points 
		//--------------------------------------
		
		protected var pointerDownPosition:Point = new Point();
		
		protected var pointerMovePosition:Point = new Point();
		
		//--------------------------------------
		// flags 
		//--------------------------------------

		protected var isPointerOver:Boolean;
		
		protected var isPointerDown:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ButtonAdapter(target:InteractiveObject)
		{
			this.target = target;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get target():InteractiveObject
		{
			return _target;
		}
		
		public function set target(value:InteractiveObject):void
		{
			if (value == _target)
				return;
			
			if (_target)
				removeInteractionListeners();
			
			_target = value;
			
			if (_target)
				addInteractionListeners();
		}
		
		public function get state():IButtonState
		{
			return _state;
		}
		
		public function set state(value:IButtonState):void
		{
			if (value == _state)
				return;
			
			_state = value;
			
			if (_stateChanged)
				_stateChanged.dispatch(this);
		}
		
		public function get isEnabled():Boolean
		{
			return _target.mouseEnabled;
		}
		
		public function set isEnabled(value:Boolean):void
		{
			if (value == _target.mouseEnabled)
				return;
			
			if (value)
			{
				state = ButtonState.UP;
			}
			else
			{
				cancelClick();
				
				isPointerDown = false;
				
				state = ButtonState.DISABLED;
			}
			
			_target.mouseEnabled = value;
		}
		
		public function get clickThreshold():Number
		{
			return _clickThreshold;
		}
		
		public function set clickThreshold(value:Number):void
		{
			_clickThreshold = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		
		protected function addInteractionListeners():void
		{
			_target.addEventListener(MouseEvent.MOUSE_DOWN, target_mouseDownHandler);
			_target.addEventListener(MouseEvent.ROLL_OVER, target_rollOverHandler);
			_target.addEventListener(MouseEvent.ROLL_OUT, target_rollOutHandler);
		}
		
		protected function removeInteractionListeners():void
		{
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, target_mouseDownHandler);
			_target.removeEventListener(MouseEvent.ROLL_OVER, target_rollOverHandler);
			_target.removeEventListener(MouseEvent.ROLL_OUT, target_rollOutHandler);
		}
		
		protected function startClick(mouseX:Number, mouseY:Number):void
		{
			isPointerOver = true;
			
			pointerDownPosition.x = mouseX;
			pointerDownPosition.y = mouseY;
			
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function stopClick():void
		{
			isPointerDown = false;
			
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function getClickingDistance(mouseX:Number, mouseY:Number):Number
		{
			pointerMovePosition.x = mouseX;
			pointerMovePosition.y = mouseY;
			
			var dx:Number = pointerMovePosition.x - pointerDownPosition.x;
			var dy:Number = pointerMovePosition.y - pointerDownPosition.y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function cancelClick():void
		{
			stopClick();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function target_mouseDownHandler(event:MouseEvent):void
		{
			isPointerDown = true;
			
			state = ButtonState.DOWN;
			
			startClick(event.stageX, event.stageY);
		}
		
		protected function target_rollOverHandler(event:MouseEvent):void
		{
			if (_target.mouseEnabled)
				state = (isPointerDown) ? ButtonState.DOWN : ButtonState.OVER;
		}
		
		protected function target_rollOutHandler(event:MouseEvent):void
		{
			isPointerOver = false;
			
			if (_target.mouseEnabled)
				state = ButtonState.UP;
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if (getClickingDistance(event.stageX, event.stageY) > _clickThreshold)
			{
				cancelClick();
				
				if (isPointerOver)
					state = ButtonState.OVER;
			}
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stopClick();
			
			state = (isPointerOver) ? ButtonState.OVER : ButtonState.UP;
			
			if (_clicked)
				_clicked.dispatch(this);
		}
	}
}