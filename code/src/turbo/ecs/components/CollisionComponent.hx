package turbo.ecs.components;

import flixel.FlxSprite;

class CollisionComponent extends AbstractComponent
{
    public var immovable:Bool = false;
    public var collideWithTags(default, null):Array<String>;

    public function new(collideWithTags:Array<String>, immovable:Bool = false)
    {
        super();
        this.collideWithTags = collideWithTags;
        this.immovable = immovable;
    }
}