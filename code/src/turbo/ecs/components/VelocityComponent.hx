package turbo.ecs.components;

import flixel.math.FlxPoint;

class VelocityComponent extends AbstractComponent
{
    // Keep a list of velocities to apply. Eg. a turtle may have a base movement
    // speed (velocity), plus it responds to keyboard events (adds velocity).
    // Velocity is key to collision detection and resolution!!!
    private var velocities = new Map<String, FlxPoint>();
    public var velocity(default, null):FlxPoint = new FlxPoint();

    public function new(vx:Float, vy:Float)
    {
        super();
        this.set("Base Velocity", vx, vy);
    }

    public function set(name:String, vx:Float, vy:Float):Void
    {
        this.velocities.set(name, new FlxPoint(vx, vy));
        
        // Recalculate final velocity
        var vx:Float = 0;
        var vy:Float = 0;

        for (v in this.velocities)
        {
            vx += v.x;
            vy += v.y;
        }

        this.velocity = new FlxPoint(vx, vy);
    }
}