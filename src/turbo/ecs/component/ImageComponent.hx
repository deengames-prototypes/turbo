package nebula.ecs.component;

import flixel.FlxSprite;

class ImageComponent extends SpriteComponent
{
    public var image:String = "";
    
    // internal
    public var isRepeating:Bool;

    public function new(fileName:String,isRepeating:Bool = false)
    {
        super();
        this.image = fileName;
        this.isRepeating = isRepeating;
    }
}