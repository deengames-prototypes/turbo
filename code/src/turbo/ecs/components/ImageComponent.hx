package turbo.ecs.components;

import flixel.FlxSprite;

class ImageComponent extends SpriteComponent
{
    public var image:String = "";
    
    // internals
    public var isRepeating:Bool;

    // sets alpha. true to show, false to hide, null to do nothing.
    public var show:Null<Bool> = null;

    public function new(fileName:String, isRepeating:Bool = false)
    {
        super();
        this.image = fileName;
        this.isRepeating = isRepeating;
    }
}