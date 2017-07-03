package turbo.ecs;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

import turbo.ecs.Entity;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.TextComponent;

// A sad but necessary class
class TurboState extends FlxState
{
    public var width(get, null):Int;
    public var height(get, null):Int;
    private var container:Container;

    public static var currentState(default, null):TurboState;

    public function new()
    {
        super();        
        TurboState.currentState = this;
    }

    override public function create():Void
    {
        super.create();
        this.container = new Container();
        container.addDefaultSystems();
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        container.update(elapsedSeconds);
    }

    public function addEntity(e:Entity):Void
    {
        container.addEntity(e);
    }

    public function get_width():Int
    {
        return FlxG.stage.stageWidth;
    }

    public function get_height():Int
    {
        return FlxG.stage.stageHeight;
    }
}