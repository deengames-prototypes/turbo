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

    private var entities = new Array<Entity>();

    // FlxGroups for collisions, by tag
    private var collisionGroups = new Map<String, FlxGroup>();
    // Pairs of collisions to check, eg. ["player", "walls"] + ["bullet", "player"]
    private var collisionChecks = new Array<Array<String>>();

    public static var currentState(default, null):TurboState;

    override public function create():Void
    {
        super.create();        
        TurboState.currentState = this;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);

        for (e in this.entities)
        {
            e.update(elapsedSeconds);
        }

        for (collisionCheck in this.collisionChecks)
        {
            var g1 = this.collisionGroups.get(collisionCheck[0]);
            var g2 = this.collisionGroups.get(collisionCheck[1]);
            var rVal = FlxG.collide(g1, g2);
        }
    }

    public function addEntity(e:Entity):Void
    {
        this.entities.push(e);

        // Add one FlxGroup per tag so we can collide groups later
        for (tag in e.tags)
        {
            if (!this.collisionGroups.exists(tag))
            {
                this.collisionGroups.set(tag, new FlxGroup());
            }

            var sprite:FlxSprite = null;
            if (e.has(ColourComponent))
            {
                sprite = e.get(ColourComponent).sprite;
            }
            else if (e.has(ImageComponent))
            {
                sprite = e.get(ImageComponent).sprite;
            }
            else
            {
                throw 'Not sure how to process for collisions; entity has no tags: ${e}';
            }
            if (sprite != null)
            {
                trace('Hey, an entity with tags: ${tag}');
                this.collisionGroups.get(tag).add(sprite);
            }
        }
    }

    public function get_width():Int
    {
        return FlxG.stage.stageWidth;
    }

    public function get_height():Int
    {
        return FlxG.stage.stageHeight;
    }

    public function trackCollision(tag1:String, tag2:String):Void
    {
        if (!this.collisionGroups.exists(tag1))
        {
            throw 'Cannot collide with non-existent group ${tag1}; please add entities with this tag first. (Or: please add the entity first, then use .collideWith)';
        }

        if (!this.collisionGroups.exists(tag2))
        {
            throw 'Cannot collide with non-existent group ${tag2}; please add entities with this tag first. (Or: please add the entity first, then use .collideWith)';
        }

        // Check for collisions with these two during update()        
        this.collisionChecks.push([tag1, tag2]);
    }
}