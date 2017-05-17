package turbo.ecs.components;

import flixel.text.FlxText;
import turbo.ecs.components.AbstractComponent;

class TextComponent extends AbstractComponent
{
    public var text:String;
    public var fontSize:Int;

    // internals
    public var textField:FlxText;
    public var show:Bool = true;

    public function new(text:String, fontSize:Int)
    {
        super();
        this.text = text;
        this.fontSize = fontSize;
    }
}