package org.tinytlf.behaviors
{
	import flash.events.Event;

	public interface IBehavior
	{
		function execute(events:Vector.<Event>):void;
	}
}