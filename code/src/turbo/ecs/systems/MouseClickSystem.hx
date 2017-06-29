package turbo.ecs.systems;

import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.TextComponent;
import turbo.ecs.Entity;

class MouseClickSystem extends AbstractSystem
{
    public function new()
    {
        // Only MouseClickComponent because it works with sprites or text
        // This keeps code DRY but we're not sure what entities we have
        super([MouseClickComponent]);
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
                if (entity.has(SpriteComponent))
                {
                    var sprite = entity.get(SpriteComponent);
                    FlxMouseEventManager.add(sprite.sprite, function(sprite) { entity.trigger("MouseDown"); }, null, null, null, false, true, mouseClickComponent.isPixelPerfect);
                    mouseClickComponent.isInitialized = true;
                }
                else if (entity.has(TextComponent))
                {
                    var text = entity.get(TextComponent);
                    FlxMouseEventManager.add(text.textField, function(sprite) { entity.trigger("MouseDown"); }, null, null, null, false, true, mouseClickComponent.isPixelPerfect);
                    mouseClickComponent.isInitialized = true;
                }
                else
                {
                    trace("Warning: mouse-click component on entity without a sprite or text.");
                }
            }
        }
    }
}