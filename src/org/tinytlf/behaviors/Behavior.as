package org.tinytlf.behaviors
{
    import flash.events.Event;

    public class Behavior implements IBehavior
    {
		final public function execute(events:Vector.<Event>):void
		{
			if(events.length <= 0)
				return;
			
			finalEvent = events[events.length - 1];
			
			act(events);
		}
		
		protected var finalEvent:Event;
		
		protected function act(events:Vector.<Event>):void
		{
		}
    }
}