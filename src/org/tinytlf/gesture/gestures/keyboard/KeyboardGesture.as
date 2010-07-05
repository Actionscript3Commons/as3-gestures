package org.tinytlf.gesture.gestures.keyboard
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.KeyboardEvent;
    
    import org.tinytlf.gesture.Gesture;
    import org.tinytlf.gesture.GestureEvent;
    
    [Event("keyDown")]
    
    public class KeyboardGesture extends Gesture
    {
        public function KeyboardGesture(target:IEventDispatcher = null)
        {
            super(target);
            
            hsm.appendChild(<t/>);
        }
        
        public function t(event:Event):Boolean
        {
            event = GestureEvent(event).relatedEvent;
            
            if(!(event is KeyboardEvent))
                return false;
            
            var k:KeyboardEvent = KeyboardEvent(event);
            var str:String = String.fromCharCode(k.charCode).toLowerCase();
            return str == 't' && k.ctrlKey && k.shiftKey;
        }
        
        override protected function notifyBehaviors(event:Event):void
        {
            trace("ctrl shift t");
        }
    }
}