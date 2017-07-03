package turbo.ecs.components;

import flixel.math.FlxPoint;

class VelocityComponent extends AbstractComponent
{
    // Keep a list of velocities to apply. Eg. a turtle may have a base movement
    // speed (velocity), plus it responds to keyboard events (adds velocity).
    // Velocity is key to collision detection and resolution!!!
    private var velocities = new Map<String, FlxPoint>();

    public function new(vx:Float, vy:Float)
    {
        super();
        this.velocities.set("Base Velocity", new FlxPoint(vx, vy));
    }

    public function set(name:String, vx:Float, vy:Float):Void
    {
        this.velocities.set(name, new FlxPoint(vx, vy));
    }

    public function getVelocity():FlxPoint
    {
        var toReturn = new FlxPoint();
        for (v in this.velocities)
        {
            toReturn.x += v.x;
            toReturn.y += v.y;
        }
        trace(toReturn);
        return toReturn;
    }
}