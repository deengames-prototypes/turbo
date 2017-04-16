package turbo.ecs.components;

import turbo.ecs.components.AbstractComponent;

class VelocityComponent extends AbstractComponent
{
    public var vx:Float = 0;
    public var vy:Float = 0;
    
    // pixels per second
    public function new(vx:Float, vy:Float, parent:Entity)
    {
        super(parent);
        this.vx = vx;
        this.vy = vy;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        var pos = this.parent.get(PositionComponent);
        
        if (pos == null) {
            throw "Entity has velocity but no position";
        }

        var deltaX:Float = elapsedSeconds * this.vx;
        var deltaY:Float = elapsedSeconds * this.vy;

        pos.x += deltaX;
        pos.y += deltaY;
    }
}