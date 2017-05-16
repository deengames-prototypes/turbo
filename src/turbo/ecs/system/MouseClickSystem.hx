package nebula.ecs.system;

import flixel.FlxG;
import flixel.FlxState;

import nebula.ecs.component.MouseClickComponent;
import nebula.ecs.Entity;

class MouseClickSystem extends AbstractSystem
{
    
    public function new()
    {
        super([MouseClickComponent]);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if(flixel.FlxG.mouse.justPressed)
        {
            for (entity in this.entities)
            {
                var mouseClickComponent:MouseClickComponent = entity.get(MouseClickComponent);
                
                for (i in 0 ... mouseClickComponent.callbacks.length)
                {
                    mouseClickComponent.callbacks[i](FlxG.mouse.x,FlxG.mouse.y);
                }
            }
        }
    }
}