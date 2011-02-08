package org.tinytlf.gestures
{
	import flash.events.*;
	import flash.utils.*;
	
	import org.tinytlf.behaviors.IBehavior;
	import org.tinytlf.utils.*;
	
	/**
	 * The base Gesture implementation is a hierarchical-state-machine. Gestures
	 * are meant to listen to multiple events, and fire when the events have
	 * occurred in the proper sequence. 
	 * 
	 * To do this, the Gesture Author writes a series of Boolean functions that
	 * each accept a single flash.events.Event instance, returning true or false
	 * if the event meets the Gesture's criteria at that time.
	 * 
	 * The function names should be appended to the Gesture's <code>hsm</code> 
	 * member as XML nodes, which defines the stateful hierarchy for the 
	 * Gesture. 
	 * 
	 * When the Gesture receives an Event input, it increments an iterator to 
	 * the iterator's most recent XML node (or the root if there is no previous
	 * node). The Gesture calls the function with the name at the iterator's 
	 * current location.
	 * 
	 * When the filter function returns true, the event is cached, behaviors are
	 * notified of the successful filter, and the iterator moves into that
	 * node's child list.
	 * 
	 * When the filter function returns false, the Gesture moves on, testing 
	 * sibling nodes until one returns true. If no siblings match the supplied
	 * event, the event cache is cleared, the behaviors are notified of the 
	 * failure, and the iterator returns to the HSM root state.
	 */
	public class Gesture extends EventDispatcher implements IGesture
	{
		public function addSource(target:IEventDispatcher):void
		{
			var events:XMLList = reflect(this).factory.metadata.(@name == 'Event');
			var type:String;
			for each(var event:XML in events)
			{
				type = event.arg.@value.toString();
				target.addEventListener(type, execute);
			}
			resetStates();
		}
		
		public function removeSource(target:IEventDispatcher):void
		{
			var events:XMLList = reflect(this).factory.metadata.(@name == 'Event');
			var type:String;
			for each(var event:XML in events)
			{
				type = event.arg.@value.toString();
				target.removeEventListener(type, execute);
			}
			resetStates();
		}
		
		protected var behaviors:Vector.<IBehavior> = new Vector.<IBehavior>();
		
		public function addBehavior(behavior:IBehavior):void
		{
			if(behaviors.indexOf(behavior) == -1)
				behaviors.push(behavior);
		}
		
		public function removeBehavior(behavior:IBehavior):void
		{
			var i:int = behaviors.indexOf(behavior);
			if(i != -1)
				behaviors.splice(i, 1);
		}
		
		protected var hsm:XML = <_/>;
		protected var states:XMLList = <>{hsm}</>;
		protected var events:Vector.<Event> = new <Event>[];
		
		/**
		 * The filter function for this Gesture's HSM.
		 */
		protected function execute(event:Event):void
		{
			// Don't bother to filter if no behaviors are attached.
			// Edit: What if a behavior is added in the middle of this gesture's
			// activation sequence? We still want to track events, yes?
//			if(behaviors.length <= 0)
//				return;
			
			var childStates:XMLList = getChildStates();
			
			resetStates();
			
			var func:Function;
			var result:Boolean = false;
			var name:String;
			
			var anySuccess:Boolean = false;
			
			for each(var childState:XML in childStates)
			{
				name = childState.localName();
				
				if(states.contains(childState) || !name)
					continue;
				
				if(!(name in this) || !(this[name] is Function))
				{
					throw new Error('Gesture ' + this['constructor'].toString() +
									' with state "' + name + '"' +
									' is missing the matching filter method.');
				}
				
				func = (this[name] as Function);
				
				try{
					result = func(event);
				}catch(e:Error){
					result = false;
				}
				
				if(!result)
				{
					//Not a successful series of events, clear the cache and move on.
					continue;
				}
				
				anySuccess = true;
				
				//Notify behaviors that we've moved successfully down the ladder.
				executeBehaviors(event);
				
				//Hang onto this event (until we notify the behaviors).
				if(events.indexOf(event) == -1)
					events.push(event);
				
				if(testNotifiable(childState))
				{
					//Tell the behaviors we're finally activated.
					activateBehaviors(events);
					//Clear out the events list (don't want memory leaks!)
					events.length = 0;
					resetStates();
				}
				
				states += childState;
			}
			
			//If there were no successful states, reset and notify behaviors.
			if(anySuccess == false)
			{
				events.length = 0;
				failBehaviors(event);
			}
		}
		
		protected function resetStates():void
		{
			states = <>{hsm}</>;
		}
		
		protected function getChildStates():XMLList
		{
			return states.*.(nodeKind() != 'text');
		}
		
		protected function testNotifiable(state:XML):Boolean
		{
			return (state.*.length() == 0);
		}
		
		protected function failBehaviors(event:Event):void
		{
			for each(var behavior:IBehavior in behaviors)
			{
				behavior.fail(event);
			}
		}
		
		protected function executeBehaviors(event:Event):void
		{
			for each(var behavior:IBehavior in behaviors)
			{
				behavior.execute(event);
			}
		}
		
		protected function activateBehaviors(events:Vector.<Event>):void
		{
			for each(var behavior:IBehavior in behaviors)
			{
				behavior.activate(events.concat());
			}
		}
	}
}