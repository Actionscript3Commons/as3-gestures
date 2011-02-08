package org.tinytlf.gestures
{
	import flash.events.*;
	import flash.utils.*;
	import org.tinytlf.utils.*;
	
	import org.tinytlf.behaviors.IBehavior;
	
	public class Gesture extends EventDispatcher implements IGesture
	{
		public function addSource(target:IEventDispatcher):void
		{
			var events:XMLList = reflect(this).factory.metadata.(@name == 'Event');
			var type:String;
			for each(var event:XML in events)
			{
				type = event.arg.@value.toString();
				target.addEventListener(type, execute, false, 0, true);
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
		
		protected function execute(event:Event):void
		{
			// Don't bother to filter if nobody will respond to us.
			// Edit: What if a behavior is added in the middle of this gesture's
			// activation sequence? We still want to track events, yes?
//			if(behaviors.length <= 0)
//				return;
			
			var childStates:XMLList = getChildStates();
			
			resetStates();
			
			var func:Function;
			var result:Boolean = false;
			var name:String;
			
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
					events.length = 0;
					continue;
				}
				
				//Hang onto this event (until we notify the behaviors).
				events.push(event);
				
				if(testNotifiable(childState))
				{
					notifyBehaviors(events);
					//Clear out the events list (don't want memory leaks!)
					events.length = 0;
				}
				
				states += childState;
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
		
		protected function notifyBehaviors(events:Vector.<Event>):void
		{
			for each(var behavior:IBehavior in behaviors)
			{
				behavior.execute(events);
			}
		}
	}
}