package turbo.ecs.components;

import flixel.text.FlxText;
import turbo.ecs.components.AbstractComponent;

class TextComponent extends AbstractComponent
{
    public var text:String;
    public var fontSize:Int;

    // internal
    public var textField:FlxText;

    public function new(text:String, fontSize:Int)
    {
        super();
        this.text = text;
        this.fontSize = fontSize;
    }
}