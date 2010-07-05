package org.tinytlf.gesture.behaviors
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    
    import org.tinytlf.TextDispatcherBase;
    import org.tinytlf.gesture.GestureEvent;
    
    public class Behavior extends TextDispatcherBase
    {
        public function Behavior()
        {
            addListeners(this);
        }
        
        private var listeners:Dictionary = new Dictionary(true);
        
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            listeners[type] = listener;
        }
        
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
        {
            super.removeEventListener(type, listener, useCapture);
            if(type in listeners)
                delete listeners[type];
        }
        
        protected function proxy(event:GestureEvent):void
        {
            var relatedEvent:Event = event.relatedEvent;
            
            if(hasEventListener(relatedEvent.type))
                listeners[relatedEvent.type](relatedEvent);
        }
        
        override public function addListeners(target:IEventDispatcher):void
        {
            super.addListeners(target);
            
            target.addEventListener(GestureEvent.getType(MouseEvent.ROLL_OVER), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.ROLL_OUT), proxy, false, 0, true);
            
            target.addEventListener(GestureEvent.getType(MouseEvent.MOUSE_OVER), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.MOUSE_OUT), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.MOUSE_MOVE), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.MOUSE_DOWN), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.MOUSE_UP), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.CLICK), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(MouseEvent.DOUBLE_CLICK), proxy, false, 0, true);
            
            target.addEventListener(GestureEvent.getType(KeyboardEvent.KEY_DOWN), proxy, false, 0, true);
            target.addEventListener(GestureEvent.getType(KeyboardEvent.KEY_UP), proxy, false, 0, true);
        }
        
        override public function removeListeners(target:IEventDispatcher):void
        {
            super.removeListeners(target);
            
            target.removeEventListener(GestureEvent.getType(MouseEvent.ROLL_OVER), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.ROLL_OUT), proxy);
            
            target.removeEventListener(GestureEvent.getType(MouseEvent.MOUSE_OVER), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.MOUSE_OUT), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.MOUSE_MOVE), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.MOUSE_DOWN), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.MOUSE_UP), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.CLICK), proxy);
            target.removeEventListener(GestureEvent.getType(MouseEvent.DOUBLE_CLICK), proxy);
            
            target.removeEventListener(GestureEvent.getType(KeyboardEvent.KEY_DOWN), proxy);
            target.removeEventListener(GestureEvent.getType(KeyboardEvent.KEY_UP), proxy);
        }
    
    }
}