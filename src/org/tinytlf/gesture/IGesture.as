package org.tinytlf.gesture
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;

  public interface IGesture
  {
    function get target():IEventDispatcher;
    function set target(value:IEventDispatcher):void;
    
    function addBehavior(behavior:IEventDispatcher):void;
    function removeBehavior(behavior:IEventDispatcher):void;
    
    function hasEventListener(type:String):Boolean;
    
    function execute(event:Event):void;
  }
}