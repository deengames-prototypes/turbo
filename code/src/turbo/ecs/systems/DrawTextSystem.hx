package turbo.ecs.systems;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.TextComponent;
import turbo.ecs.Entity;
import turbo.ecs.TurboState;

import flixel.text.FlxText;

// Looks for and initializes TextComponent instances
class DrawTextSystem extends AbstractSystem
{
    private var state:TurboState;
    
    public function new(state:TurboState)
    {
        super([TextComponent, PositionComponent]);
        this.state = state;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var text:TextComponent = entity.get(TextComponent);
            var position:PositionComponent = entity.get(PositionComponent);

            text.textField.text = text.text;
            text.textField.size = text.fontSize;

            if (text.show == true)
            {
                text.textField.alpha = 1;
                text.show = null;
            }
            else if (text.show == false)
            {
                text.textField.alpha = 0;
                text.show = null;
            }
            // Else if null, do nothing
        }
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        for (entity in this.entities)
        {
            var text:TextComponent = entity.get(TextComponent);          
            if (text.textField == null)
            {
                text.textField = new FlxText(0, 0, 0, text.text, text.fontSize);
                this.state.add(text.textField);
            }
        }
    }
}