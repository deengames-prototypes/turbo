package turbo.ecs.systems;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.Entity;

class MouseClickSystem extends AbstractSystem
{
    public function new()
    {
        super([MouseClickComponent, SpriteComponent]);
        FlxG.plugins.add(new FlxMouseEventManager());
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var mouseClickComponent:MouseClickComponent = entity.get(MouseClickComponent);
            if (!mouseClickComponent.isInitialized)
            {
                var sprite = entity.get(SpriteComponent);
                FlxMouseEventManager.add(sprite.sprite, mouseClickComponent.mouseDownCallback, null, null, null, false, true, mouseClickComponent.isPixelPerfect);
                mouseClickComponent.isInitialized = true;
            }
        }
    }
}