/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.getTimer;
    
    public class TextDispatcherBase extends EventDispatcher
    {
        public function TextDispatcherBase(target:IEventDispatcher = null)
        {
            super(target);
            
            addListeners(this);
        }
        
        public static const UP:uint = 0x0001;
        public static const OVER:uint = 0x0002;
        public static const DOWN:uint = 0x0004;
        
        protected static var mouseState:uint = UP; // | DOWN;
        protected static var mouseCoords:Point;
        
        protected function onClick(event:MouseEvent):void
        {
            mouseState &= ~DOWN;
            mouseState |= UP;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onDoubleClick(event:MouseEvent):void
        {
            mouseState &= ~DOWN;
            mouseState |= UP;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onRollOver(event:MouseEvent):void
        {
            mouseState |= OVER;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onRollOut(event:MouseEvent):void
        {
            mouseState &= ~OVER;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onMouseMove(event:MouseEvent):void
        {
            mouseState |= OVER;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onMouseDown(event:MouseEvent):void
        {
            mouseState |= DOWN;
            mouseState &= ~UP;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onMouseUp(event:MouseEvent):void
        {
            mouseState &= ~DOWN;
            mouseState |= UP;
            mouseCoords = new Point(event.stageX, event.stageY);
        }
        
        protected function onKeyDown(event:KeyboardEvent):void
        {
        }
        
        protected function onKeyUp(event:KeyboardEvent):void
        {
        }
        
        public function addListeners(target:IEventDispatcher):void
        {
            target.addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 0, true);
            target.addEventListener(MouseEvent.MOUSE_OUT, onRollOut, false, 0, true);
            
            target.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
            target.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
            
            target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
            target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
            target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
            target.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            target.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
            
            target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
            target.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
        }
        
        public function removeListeners(target:IEventDispatcher):void
        {
            target.removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
            target.removeEventListener(MouseEvent.MOUSE_OUT, onRollOut);
            
            target.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
            target.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
            
            target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            target.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            target.removeEventListener(MouseEvent.CLICK, onClick);
            target.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
            
            target.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            target.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
        
        protected static var eventTime:int = 0;
        
        protected static function get allowEvent():Boolean
        {
            var time:int = getTimer();
            var ret:Boolean = (time - eventTime) > 100;
            eventTime = time;
            return ret;
        }
        
        protected static function get allowFastEvent():Boolean
        {
            var time:int = getTimer();
            var ret:Boolean = (time - eventTime) > 10;
            eventTime = time;
            return ret;
        }
    }
}

