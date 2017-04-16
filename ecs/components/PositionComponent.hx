package turbo.ecs.components;

import turbo.ecs.components.AbstractComponent;

class PositionComponent extends AbstractComponent
{
    public var x:Float = 0;
    public var y:Float = 0;
    
    public function new(x:Float, y:Float, parent:Entity)
    {
        super(parent);
        this.x = x;
        this.y = y;
    }
}