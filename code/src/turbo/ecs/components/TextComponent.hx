package turbo.ecs.components;

import flixel.text.FlxText;
import turbo.ecs.components.AbstractComponent;

class TextComponent extends AbstractComponent
{
    public var message:String;
    public var fontSize:Int;

    // internal
    public var textField:FlxText;

    public function new(message:String, fontSize:Int)
    {
        super();
        this.message = message;
        this.fontSize = fontSize;
    }
}