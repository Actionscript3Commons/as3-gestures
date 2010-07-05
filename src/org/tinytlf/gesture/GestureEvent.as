package org.tinytlf.gesture
{
    import flash.events.Event;
    
    public class GestureEvent extends Event
    {
        private var _event:Event;
        public function GestureEvent(type:String, relatedEvent:Event)
        {
            super(type, false, false);
            _event = relatedEvent;
        }
        
        public function get relatedEvent():Event
        {
            return _event;
        }
        
        public static function getType(type:String):String
        {
            return type + 'GestureEvent';
        }
        
        public static function getEvent(relatedEvent:Event):GestureEvent
        {
            return new GestureEvent(getType(relatedEvent.type), relatedEvent);
        }
        
        override public function clone():Event
        {
            return new GestureEvent(type, relatedEvent);
        }
    }
}