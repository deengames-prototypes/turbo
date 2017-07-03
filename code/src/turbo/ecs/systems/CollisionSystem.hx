package turbo.ecs.systems;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import turbo.ecs.components.CollisionComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.Entity;

// Sets up tags and such for collisions. Delegates actual resolution to HaxeFlixel.
// On update, calls FlxG.collide, which resolves collisions.
class CollisionSystem extends AbstractSystem
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
        if (this.entities.indexOf(entity) == -1)
        {
            trace('Setup for ${entity}');
            this.setupCollisionFor(entity);
        }

        super.entityChanged(entity);        
    }

    override public function update(elapsedSeconds:Float):Void
    {
        for (e in this.entitiesToProcess)
        {
            this.setupCollisionFor(e);
        }

        // If sprites change, make sure immovable entities are still immovable
        for (e in this.entities)
        {
            var cc = e.get(CollisionComponent);

            if (cc != null)
            {
                if (e.has(ColourComponent))
                {
                    e.get(ColourComponent).sprite.immovable = cc.immovable;
                }
                else if (e.has(ImageComponent))
                {
                    e.get(ImageComponent).sprite.immovable = cc.immovable;
                }
                else
                {
                    throw 'Cant make ${e} immovable; it has no sprite yet.';
                }
            }
        }

        super.update(elapsedSeconds);
        for (collisionCheck in this.collisionChecks)
        {
            var g1 = this.collisionGroups.get(collisionCheck[0]);
            var g2 = this.collisionGroups.get(collisionCheck[1]);
            var result = FlxG.collide(g1, g2);
            trace('${collisionCheck}: ${result}. g1=${g1.members} g2=${g2}');
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

    private function setupCollisionFor(entity:Entity):Void
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
                entitiesToProcess.remove(entity);
                trace('set up collision for e=${entity}: ${entitiesToProcess.length}');
            }
            else if (entity.has(ImageComponent))
            {
                sprite = entity.get(ImageComponent).sprite;
                entitiesToProcess.remove(entity);
                trace('set up collision for e=${entity}: ${entitiesToProcess.length}');                
            }
            
            if (sprite != null &&
                // Not already in the group
                this.collisionGroups.get(tag).members.indexOf(sprite) == -1)
            {
                trace('Adding ${sprite} to ${tag}!!!');
                this.collisionGroups.get(tag).add(sprite);
            }
            else
            {
                trace('Cant set up collisions for ${entity}; no sprite yet.');
                if (entitiesToProcess.indexOf(entity) == -1)
                {
                    this.entitiesToProcess.push(entity);
                }
            }
        }
    }
}