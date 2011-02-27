package com.destroytoday.component.button
{
	public class ButtonState implements IButtonState
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		public static const UP:ButtonState = new ButtonState("up");
		
		public static const OVER:ButtonState = new ButtonState("over");
		
		public static const DOWN:ButtonState = new ButtonState("down");
		
		public static const DISABLED:ButtonState = new ButtonState("disabled");
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var name:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ButtonState(name:String)
		{
			this.name = name;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String
		{
			return name;
		}
	}
}