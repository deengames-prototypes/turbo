package turbo.ecs.components;

import flixel.text.FlxText;
import turbo.ecs.components.AbstractComponent;

class TextComponent extends AbstractComponent
{
    public var text:String;
    public var fontSize:Int;

    // internals
    public var textField:FlxText;
    // sets alpha. true to show, false to hide, null to do nothing.
    public var show:Null<Bool> = null;

    public function new(text:String, fontSize:Int)
    {
        super();
        this.text = text;
        this.fontSize = fontSize;
    }
}