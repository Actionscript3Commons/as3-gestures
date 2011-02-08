package org.tinytlf.gestures
{
	import flash.events.IEventDispatcher;
	
	import org.tinytlf.behaviors.IBehavior;
	
	public interface IGesture
	{
		/**
		 * Instructs the Gesture to add its event listeners to the target
		 * dispatcher.
		 */
		function addSource(dispatcher:IEventDispatcher):void;
		/**
		 * Instructs the Gesture to remove its event listeners from the target
		 * dispatcher.
		 */
		function removeSource(dispatcher:IEventDispatcher):void;
		
		/**
		 * Adds the behavior to this Gesture's notify sequence.
		 */
		function addBehavior(behavior:IBehavior):void;
		/**
		 * Removes the behavior from this Gesture's notify sequence.
		 */
		function removeBehavior(behavior:IBehavior):void;
	}
}