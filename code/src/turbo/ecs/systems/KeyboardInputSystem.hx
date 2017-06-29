package turbo.ecs.systems;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxKeyManager;

import turbo.ecs.Entity;
import turbo.ecs.components.KeyboardInputComponent;

// Looks for KeyboardInputComponents and triggers events
class KeyboardInputMovementSystem extends AbstractSystem
{
    public function new()
    {
        super([KeyboardInputComponent]);
    }
        
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.keys.getIsDown().length > 0)
        for (entity in this.entities)
        {
            var component:KeyboardInputComponent = entity.get(KeyboardInputComponent);
            entity.trigger("KeyDown");
        }
    }
}