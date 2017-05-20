package turbo.ecs.components;

import flixel.FlxSprite;

class PositionComponent extends AbstractComponent
{
    public var x:Float = 0;
    public var y:Float = 0;

    // internal; for one-off moves
    public var moveToX:Null<Float> = null;
    public var moveToY:Null<Float> = null;
    
    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
    }
}