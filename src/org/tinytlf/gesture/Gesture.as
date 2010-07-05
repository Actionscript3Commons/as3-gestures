package org.tinytlf.gesture
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import org.tinytlf.gesture.util.Type;
    
    public class Gesture implements IGesture
    {
        public function Gesture(target:IEventDispatcher = null)
        {
            this.target = target;
        }
        
        private var _target:IEventDispatcher;
        
        public function get target():IEventDispatcher
        {
            return _target;
        }
        
        public function set target(value:IEventDispatcher):void
        {
            if(value === _target)
                return;
            
            if(_target)
                removeListeners(_target);
            
            _target = value;
            
            if(_target)
                addListeners(_target);
            
            resetStates();
        }

        public function hasEventListener(type:String):Boolean
        {
            return listeners[type];
        }
        
        private var listeners:Object = {};
        
        protected function addListeners(target:IEventDispatcher):void
        {
            var events:XMLList = Type.describeType(this).factory.metadata.(@name == 'Event');
            var type:String;
            for each(var event:XML in events)
            {
                type = event.arg.@value.toString();
                target.addEventListener(type, execute, false, 0, true);
                listeners[type] = true;
            }
        }
        
        protected function removeListeners(target:IEventDispatcher):void
        {
            var events:XMLList = Type.describeType(this).factory.metadata.(@name == 'Event');
            var type:String;
            for each(var event:XML in events)
            {
                type = event.arg.@value.toString();
                target.removeEventListener(type, execute);
                listeners[type] = false;
            }
        }
        
        protected var hsm:XML = <_/>;
        protected var states:XMLList = <>{hsm}</>;
        
        protected var behaviors:Vector.<IEventDispatcher> = new Vector.<IEventDispatcher>();
        
        public function addBehavior(behavior:IEventDispatcher):void
        {
            if(behaviors.indexOf(behavior) == -1)
                behaviors.push(behavior);
        }
        
        public function removeBehavior(behavior:IEventDispatcher):void
        {
            var i:int = behaviors.indexOf(behavior);
            if(i != -1)
                behaviors.splice(i, 1);
        }
        
        public function execute(event:Event):void
        {
            var childStates:XMLList = getChildStates();
            
            resetStates();
            
            var func:Function;
            var result:Boolean = false;
            
            for each(var childState:XML in childStates)
            {
                if(states.contains(childState) || !childState.localName())
                    continue;
                
                if(!(childState.localName() in this) && (this[childState.localName()] is Function))
                    throw new Error('Gesture ' + this['constructor'].toString() + ' with state "' + childState.localName() + '" is missing matching filter method.');
                
                func = (this[childState.localName()] as Function);
                
                try
                {
                    result = func(event);
                }
                catch(e:Error)
                {
                    result = false;
                }
                
                if(!result)
                    continue;
                
                if(testNotifiable(childState))
                    notifyBehaviors(event);
                
                states += childState;
            }
        }
        
        protected function resetStates():void
        {
            states = <>{hsm}</>;
        }
        
        protected function getChildStates():XMLList
        {
            var childStates:XMLList = states.*.(nodeKind() != 'text');
            var namedStates:XMLList = hsm..*.(attribute('id').length());
            for each(var childStateID:String in states.@idrefs.toXMLString().split(/\s+/))
                if(childStateID)
                    childStates += namedStates.(@id == childStateID);
            
            return childStates;
        }
        
        protected function testNotifiable(state:XML):Boolean
        {
            return (state.@idrefs.toString() == "" || state.@idrefs == "*") && (state.*.length() == 0);
        }
        
        protected function notifyBehaviors(event:Event):void
        {
            for each(var behavior:IEventDispatcher in behaviors)
            {
                behavior.dispatchEvent(GestureEvent.getEvent(event));
            }
        }
    }
}