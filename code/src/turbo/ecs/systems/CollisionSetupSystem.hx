package turbo.ecs.systems;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.Entity;

// Sets up tags and such for collisions. Doesn't do any actual resolution.
// That part, HaxeFlixel handles.
class CollisionSetupSystem extends AbstractSystem
{
    // Entities to process later; they don't have an initialized sprite yet
    private var entitiesToProcess = new Array<Entity>();

    // FlxGroups for collisions, by tag
    private var collisionGroups = new Map<String, FlxGroup>();
    // Pairs of collisions to check, eg. ["player", "walls"] + ["bullet", "player"]
    private var collisionChecks = new Array<Array<String>>();

    public function new()
    {
        // Anything with tags is game
        super([]);
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        this.setupCollisionFor(entity, true);
    }

    override public function update(elapsedSeconds:Float):Void
    {
        for (e in this.entitiesToProcess)
        {
            this.setupCollisionFor(e, false);
        }

        super.update(elapsedSeconds);
        for (collisionCheck in this.collisionChecks)
        {
            var g1 = this.collisionGroups.get(collisionCheck[0]);
            var g2 = this.collisionGroups.get(collisionCheck[1]);
            var rVal = FlxG.collide(g1, g2);
        }
    }

    public function trackCollision(tag1:String, tag2:String):Void
    {
        if (!this.collisionGroups.exists(tag1))
        {
            this.collisionGroups.set(tag1, new FlxGroup());
        }

        if (!this.collisionGroups.exists(tag2))
        {
            this.collisionGroups.set(tag2, new FlxGroup());
        }

        // Check for collisions with these two during update()        
        this.collisionChecks.push([tag1, tag2]);
    }

    private function setupCollisionFor(entity:Entity, retryIfFail:Bool):Void
    {
        // Add one FlxGroup per tag so we can collide groups later
        for (tag in entity.tags)
        {
            if (!this.collisionGroups.exists(tag))
            {
                this.collisionGroups.set(tag, new FlxGroup());
            }
            
            var sprite:FlxSprite = null;
            if (entity.has(ColourComponent))
            {
                sprite = entity.get(ColourComponent).sprite;
            }
            else if (entity.has(ImageComponent))
            {
                sprite = entity.get(ImageComponent).sprite;
            }
            else
            {
                if (retryIfFail)
                {
                    // Process later if it doesn't have a sprite yet
                    this.entitiesToProcess.remove(entity); // No dupes plzkthx
                    this.entitiesToProcess.push(entity);
                }
            }
            if (sprite != null)
            {
                this.collisionGroups.get(tag).add(sprite);
            }
        }
    }
}