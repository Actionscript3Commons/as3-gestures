package org.tinytlf.gestures
{
	import flash.events.IEventDispatcher;
	
	import org.tinytlf.behaviors.IBehavior;
	
	public interface IGesture
	{
		function addSource(dispatcher:IEventDispatcher):void;
		function removeSource(dispatcher:IEventDispatcher):void;
		
		function addBehavior(behavior:IBehavior):void;
		function removeBehavior(behavior:IBehavior):void;
	}
}