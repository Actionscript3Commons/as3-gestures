package org.tinytlf.behaviors
{
	import flash.events.Event;

	public interface IBehavior
	{
		/**
		 * Called when a Gesture has failed to execute based on a rogue Event.
		 */
		function fail(event:Event):void;
		
		/**
		 * Called each time an event satisfies a state in the Gesture's HSM.
		 */
		function execute(event:Event):void;
		
		/**
		 * Called when the gesture is entirely activated.
		 */
		function activate(events:Vector.<Event>):void;
	}
}