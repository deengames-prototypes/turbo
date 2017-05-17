package turbo.ecs.components;

import flixel.FlxSprite;

class ImageComponent extends SpriteComponent
{
    public var image:String = "";
    
    // internals
    public var isRepeating:Bool;
    public var show:Bool = true;

    public function new(fileName:String,isRepeating:Bool = false)
    {
        super();
        this.image = fileName;
        this.isRepeating = isRepeating;
    }
}