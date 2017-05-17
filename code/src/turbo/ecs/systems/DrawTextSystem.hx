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
            text.textField.setPosition(position.x,position.y);
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
                text.textField = new FlxText(text.text, text.fontSize);
                this.state.add(text.textField);
            }

            if (text.text != text.textField.text)
            {
                text.textField.text = text.text;
            }

            if (text.fontSize != text.textField.size)
            {
                text.textField.size = text.fontSize;
            }
            
            var position:PositionComponent = entity.get(PositionComponent);
            text.textField.x = position.x;
            text.textField.y = position.y;
        }
    }
}