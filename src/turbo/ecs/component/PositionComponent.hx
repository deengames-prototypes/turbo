package nebula.ecs.component;

import flixel.FlxSprite;

class PositionComponent extends AbstractComponent
{
    public var x:Float = 0;
    public var y:Float = 0;
    
    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
    }
}