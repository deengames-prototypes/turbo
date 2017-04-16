package turbo.ecs.components;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import turbo.ecs.components.AbstractComponent;

class ColourComponent extends SpriteComponent
{
     // Used to auto-add to the current state
    public static var onAdd:ColourComponent->Void;
    public static var onRemove:ColourComponent->Void;

    public var width(default, null):Int = 0;
    public var height(default, null):Int = 0;
    public var colour(default, null):FlxColor;    
    
    public function new(red:Int, green:Int, blue:Int, width:Int, height:Int, parent:Entity)
    {
        super(parent);
        
        // TODO: throw if any value is negative
        // TODO: throw if dimensions are zero
        // TODO: throw if colours are > 255

        this.width = width;
        this.height = height;
        this.colour = FlxColor.fromRGB(red, green, blue);
        this.sprite = makeSprite();

         if (ColourComponent.onAdd != null)
        {
            ColourComponent.onAdd(this);
        }
    }

    override public function update(elapsedSeconds:Float):Void
    {
        var position = this.parent.get(PositionComponent);
        if (position != null)
        {
            this.sprite.x = position.x;
            this.sprite.y = position.y;        
        }
    }
    
    private function makeSprite():FlxSprite
    {
        var toReturn:FlxSprite = new FlxSprite();
        toReturn.makeGraphic(this.width, this.height, this.colour);      
        return toReturn;
    }
}