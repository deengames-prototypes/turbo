package turbo.ecs.systems;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import turbo.ecs.components.CollisionComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.Entity;

// Sets up tags and such for collisions. Delegates actual resolution to HaxeFlixel.
// On update, calls FlxG.collide, which resolves collisions.
class CollisionSystem extends AbstractSystem
{
    // FlxGroups for collisions. Tag => sprites with that tag
    private var collisionGroups = new Map<String, FlxGroup>();
    // Pairs of collisions to check, eg. ["player", "walls"], ["bullet", "player"]
    private var collisionChecks = new Array<Array<String>>();

    public function new()
    {
        super([CollisionComponent, SpriteComponent]);
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);

        // Make sure we track all entities' tags so we have groups when we need them.
        // (the user can ask for a collision after creating new entities).
        // Add one FlxGroup per tag so we can collide groups later.
        var tag:String = entity.tag;
        if (tag != null && tag != "" && !this.collisionGroups.exists(tag))
        {
            this.collisionGroups.set(tag, new FlxGroup());
        }

        if (entity.has(SpriteComponent) && entity.has(CollisionComponent))
        {
            trace('Setup for ${entity}');            
            this.setupCollisionFor(entity); 
        }
    }

    override public function update(elapsedSeconds:Float):Void
    {
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
            trace('${collisionCheck}: ${g1.members} vs. ${g2.members} => ${result}');            
            if (result == true) {
                trace('${collisionCheck}: ${result}. g1=${g1.members} g2=${g2.members}');
            }
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
        // If we had a previous sprite, we don't know it, and can't remove it
        // For now, that's okay, just track the new sprite.
        var sprite:FlxSprite = null;
        if (entity.has(ColourComponent))
        {
            sprite = entity.get(ColourComponent).sprite;
        }
        else if (entity.has(ImageComponent))
        {
            sprite = entity.get(ImageComponent).sprite;
        }
        
        if (sprite != null)            
        {
            // Not already in the group
            if (this.collisionGroups.get(entity.tag).members.indexOf(sprite) == -1)
            {
                trace('Collision for ${entity} is based on ${sprite}');
                this.collisionGroups.get(entity.tag).add(sprite);
            }
        }
        else
        {
            throw 'Cant set up collisions for ${entity}; no sprite yet.';
        }
    }
}