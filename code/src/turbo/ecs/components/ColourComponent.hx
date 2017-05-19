package turbo.ecs.components;

import flixel.FlxSprite;

class ColourComponent extends SpriteComponent
{
    public var red:Int = 0;
    public var green:Int = 0;
    public var blue:Int = 0;
    public var width:Int = 0;
    public var height:Int = 0;    

    // internal
     // sets alpha. true to show, false to hide, null to do nothing.
    public var show:Null<Bool> = null;
    
    public function new(red:Int, green:Int, blue:Int, width:Int, height:Int)
    {
        super();
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.width = width;
        this.height = height;
    }
}