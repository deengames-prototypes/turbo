package turbo.ecs.components;

import flixel.text.FlxText;
import turbo.ecs.components.AbstractComponent;

class TextComponent extends AbstractComponent
{
     // Used to auto-add to the current state
    public static var onAdd:TextComponent->Void;
    public static var onRemove:TextComponent->Void;    
    public var text(default, null):FlxText;

    public function new(message:String, fontSize:Int, parent:Entity)
    {
        super(parent);
        
        this.text = new FlxText(0, 0, 0, message, fontSize);

        if (TextComponent.onAdd != null)
        {
            TextComponent.onAdd(this);
        }
    }

    public function setText(message:String):Void
    {
        this.text.text = message;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        var position = this.parent.get(PositionComponent);
        if (position != null)
        {
            this.text.x = position.x;
            this.text.y = position.y;        
        }
    }
}