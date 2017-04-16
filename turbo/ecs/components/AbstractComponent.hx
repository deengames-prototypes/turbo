package turbo.ecs.components;

import turbo.ecs.Entity;

import flixel.FlxSprite;

// Abstract class. Don't instantiate. Subclasses should just be dummies
// with data, they shouldn't have any logic in them. There's nothing in
// here yet; it just saves us from using Dynamic.
class AbstractComponent
{
    private var parent:Entity;

    public function new(parent:Entity)
    {
        this.parent = parent;
    }

    public function trigger(event:String):Void
    {
        this.parent.onEvent(event);
    }

    // Events that come in from other components, to the parent, 
    // then down to us.
    public function onEvent(event:String):Void
    {
        // Override.
    }

    public function update(elapsedSeconds:Float):Void
    {
        // Override please. Here to avoid checking for
        // specific component types that have .update
        // in Entity.update
    }
}