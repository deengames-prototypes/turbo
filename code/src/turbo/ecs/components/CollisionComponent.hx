package turbo.ecs.components;

import flixel.FlxSprite;

class CollisionComponent extends AbstractComponent
{
    public var immovable:Bool = false;
    public var collideWithTags(default, null):Array<String>;
    public var myTag(default, null):String;

    public function new(myTag:String, collideWithTags:Array<String>, immovable:Bool = false)
    {
        super();
        this.myTag = myTag;
        this.collideWithTags = collideWithTags;
        this.immovable = immovable;
    }
}