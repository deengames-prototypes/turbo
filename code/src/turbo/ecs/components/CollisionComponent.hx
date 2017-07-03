package turbo.ecs.components;

import flixel.FlxSprite;

class CollisionComponent extends AbstractComponent
{
    public var immovable:Bool = false;

    public function new(immovable:Bool)
    {
        super();
        this.immovable = immovable;
    }
}