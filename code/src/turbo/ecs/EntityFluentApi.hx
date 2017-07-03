package turbo.ecs;

import flixel.FlxSprite;
import flixel.text.FlxText;

import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.HealthComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.TextComponent;
import turbo.ecs.components.VelocityComponent;

import turbo.ecs.systems.CollisionSetupSystem;

// "Fluent" extensions on the Entity class
class EntityFluentApi
{
        // Please sort alphabetically
    
    public static function after(entity:Entity, seconds:Float, callback:Void->Void):Entity
    {
        entity.afterEvents.push(new AfterEvent(seconds, callback));
        return entity;
    }

    public static function clearAfterEvents(entity:Entity):Entity
    {
        entity.afterEvents.splice(0, entity.afterEvents.length); // clear
        return entity;
    }

    // Delegates to HaxeFlixel for collision resolution; both objects move.
    // If you want one to be static, call .immovable() on it.
    public static function collideWith(entity:Entity, tag:String):Entity
    {
        if (entity.tags == null || entity.tags.length == 0)
        {
            throw 'Cannot collide an entity without tags! (Target tag: ${tag})';
        }

        for (myTag in entity.tags)
        {
            // I don't like this use of singleton-ish states. Null in tests.
            if (Container.instance != null)
            {
                // Find the collision system
                var collisionSystem:CollisionSetupSystem = null;
                for (system in Container.instance.systems)
                {
                    if (Std.is(system, CollisionSetupSystem))
                    {
                        collisionSystem = cast system;
                        break;
                    }
                }
                collisionSystem.trackCollision(myTag, tag);
            }
        }
        return entity;
    }

    // Calling colour without calling size (or vice-versa) should give sensible results
    // The default is a 32x32 red square
    public static function colour(entity:Entity, red:Int, green:Int, blue:Int):Entity
    {
        if (!entity.has(ColourComponent))
        {
            entity.add(new ColourComponent(red, green, blue, 32, 32)); // default size
        }
        else
        {        
            var c = entity.get(ColourComponent);
            entity.remove(ColourComponent);
            // I don't like this use of singleton-ish states. Null in tests.
            if (TurboState.currentState != null)
            {
                TurboState.currentState.remove(c.sprite);
            }
            entity.add(new ColourComponent(red, green, blue, c.width, c.height));
        }

        if (!entity.has(PositionComponent))
        {
            entity.add(new PositionComponent(0, 0));
        }

        return entity;
    }
    
    public static function health(entity:Entity, maximumHealth:Int):Entity
    {
        entity.add(new HealthComponent(maximumHealth));
        return entity;
    }

    public static function hide(entity:Entity):Entity
    {
        var img = entity.get(ImageComponent);
        if (img != null)
        {
            img.show = false;
        }

        var text = entity.get(TextComponent);
        if (text != null)
        {
            text.show = false;
        }
        return entity;
    }
    
    public static function image(entity:Entity, image:String, isRepeating:Bool = false):Entity
    {
        if (entity.has(ImageComponent))
        {
            var i:ImageComponent = entity.get(ImageComponent);
            i.image = image;
            i.isRepeating = isRepeating;
        }
        else
        {
            entity.add(new ImageComponent(image, isRepeating));
        }
        
        if (!entity.has(PositionComponent))
        {
            // For some reason, entity.move(0, 0) gives a "no such method" compiler error.
            // It's not because .move is defined later in this file, after .image, either
            EntityFluentApi.move(entity, 0, 0);
        }
        return entity;
    }

    // Don't move when resolving collisions
    public static function immovable(entity:Entity):Entity
    {
        if (entity.has(ColourComponent))
        {
            entity.get(ColourComponent).sprite.immovable = true;
        }
        else if (entity.has(ImageComponent))
        {
            entity.get(ImageComponent).sprite.immovable = true;
        }

        return entity;
    }
    
    public static function move(entity:Entity, x:Float, y:Float):Entity
    {
        if (!entity.has(SpriteComponent) && !entity.has(TextComponent))
        {
            throw "Can't move something without a sprite/text component!";
        }

        if (!entity.has(PositionComponent))
        {
            entity.add(new PositionComponent(x, y));
        } 
        
        var p:PositionComponent = entity.get(PositionComponent);
        p.x = x;
        p.y = y;
        p.moveToX = x;
        p.moveToY = y;

        return entity;
    } 
    
    // MoveSpeed is in pixels per second
    public static function moveWithKeyboard(entity:Entity, moveSpeed:Int):Entity
    {
        entity.add(new KeyboardInputComponent(moveSpeed));
        if (!entity.has(VelocityComponent))
        {
            entity.add(new VelocityComponent(0, 0));
        }
        return entity;
    }
    
    public static function onClick(entity:Entity, callback:Void->Void, isPixelPerfect:Bool = true):Entity
    {
        var mc:MouseClickComponent = new MouseClickComponent(isPixelPerfect);
        entity.add(mc);
        entity.bind("MouseDown", callback);
        return entity;
    }

    public static function onEveryFrame(entity:Entity, callback:Void->Void):Entity
    {
        entity.bind("Tick", callback);
        return entity;
    }
    
    public static function rotate(entity:Entity, angleInDegrees:Int):Entity
    {
        var img = entity.get(ImageComponent);
        if (img != null)
        {
            img.sprite.angle = angleInDegrees;
        }
        var colour = entity.get(ColourComponent);
        if (colour != null)
        {
            colour.sprite.angle = angleInDegrees;
        }
        return entity;
    }

    public static function show(entity:Entity):Entity
    {
        var img = entity.get(ImageComponent);
        if (img != null)
        {
            img.show = true;
        }

        var text = entity.get(TextComponent);
        if (text != null)
        {
            text.show = true;
        }
        return entity;
    }
    
    public static function size(entity:Entity, width:Int, height:Int):Entity
    {
        if (!entity.has(ColourComponent))
        {
            entity.add(new ColourComponent(255, 255, 255, width, height)); // default colour
        }
        else
        {
            var c = entity.get(ColourComponent);
            entity.remove(ColourComponent);
            entity.add(new ColourComponent(c.red, c.green, c.blue, width, height));   
        }        

        if (!entity.has(PositionComponent))
        {
            entity.add(new PositionComponent(0, 0));
        }

        return entity;
    }
    
    public static function text(entity:Entity, text:String, fontSize:Int = 36):Entity
    {
        if (entity.has(TextComponent))
        {
            var t:TextComponent = entity.get(TextComponent);
            t.text = text;
            t.fontSize = fontSize;
        }
        else 
        {
            entity.add(new TextComponent(text, fontSize));
        }
        return entity;
    }

    public static function trackWithCamera(entity:Entity):Entity
    {
        entity.add(new CameraComponent());
        return entity;
    }

    public static function velocity(entity:Entity, vx:Float, vy:Float):Entity
    {
        entity.add(new VelocityComponent(vx, vy));
        return entity;
    }
}