package nebula.ecs.component;

import flixel.FlxSprite;

class ColourComponent extends SpriteComponent
{
    public var red:Int = 0;
    public var green:Int = 0;
    public var blue:Int = 0;
    public var width:Int = 0;
    public var height:Int = 0;    
    
    public function new(red:Int, green:Int, blue:Int, width:Int, height:Int)
    {
        super();
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.width = width;
        this.height = height;
        // TODO: throw if any of these are negative, or w/h = 0, or if RGB > 255
    }
}