package turbo.ecs;

import flixel.FlxSprite;
import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.HealthComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.TextComponent;
import turbo.ecs.Container;

class Entity
{
    public var container(default, default):Container;
    private var components:Map<String, AbstractComponent>; // Can change AbstractComponent to Any

    // Can't write tags because we put entities in a hashmap based on tags, 
    // and use that to determinte collisions. Erm, we have to reprocess
    // the entity if its tags change.
    public var tags(default, null):Array<String>;

    // Arbitrary key/value pairs
    private var data = new Map<String, Any>();

    private var everyFrame:Void->Void;
    // Seconds from now => event to call
    private var afterEvents = new Array<AfterEvent>();
    
    public function new(tags:Array<String> = null)
    {
        this.container = Container.instance;
        this.components = new Map<String, AbstractComponent>();

        if (tags == null)
        {
            this.tags = [];
        }
        else
        {
            this.tags = tags;
        }
    }
    
    // You can only have one of each component by type
    public function add(component:AbstractComponent):Entity
    {
        var name = Type.getClassName(Type.getClass(component));
        this.components.set(name, component);
        this.container.entityChanged(this);
        return this;
    }
    
    /**
    Remove a component from this entity. (eg. e.remove(SpriteComponent))
    Does nothing if the component doesn't have that entity.
    */
    public function remove(clazz:Class<AbstractComponent>):Entity
    {
        var name = Type.getClassName(clazz);
        this.components.remove(name);
        this.container.entityChanged(this);
        return this;
    }
    
    // c is a Class<AbstractComponent> eg. SpriteComponent
    public function get<T>(c:Class<T>):T
    {
        var name:String = Type.getClassName(c);
        var toReturn:AbstractComponent = this.components.get(name);
        
        if (toReturn == null)
        {
            // Don't have the exact type. Maybe we have a subtype?
            // eg. asked for SpriteComponent when we have ImageComponent
            for (component in this.components)
            {
                if (Std.is(component, c))
                {
                    return cast(component);
                }
            }
        }
        
        return cast(toReturn);
    }
    
    public function has(c:Class<AbstractComponent>):Bool
    {
        return this.get(c) != null;
    }

    public function update(elapsedSeconds:Float):Void
    {
        for (afterEvent in this.afterEvents)
        {
            afterEvent.seconds -= elapsedSeconds;
            if (afterEvent.seconds <= 0)
            {
                afterEvent.callback();
                this.afterEvents.remove(afterEvent);
            }
        }

        if (this.everyFrame != null)
        {
            this.everyFrame();
        }
    }

    // data: generic key/value pairs

    public function getData(key:String):Any
    {
        return this.data.get(key);
    }

    public function setData(key:String, data:Any):Void
    {
        this.data.set(key, data);
    }
        
    ////////////////////// Start fluent API //////////////////////
    
    // Please sort alphabetically
    
    public function after(seconds:Float, callback:Void->Void):Entity
    {
        this.afterEvents.push(new AfterEvent(seconds, callback));
        return this;
    }

    public function clearAfterEvents():Entity
    {
        this.afterEvents = new Array<AfterEvent>();
        return this;
    }

    public function collideWith(tag:String):Entity
    {
        if (this.tags == null || this.tags.length == 0)
        {
            throw 'Cannot collide an entity (${this}) without tags!';
        }

        for (myTag in this.tags)
        {
            // I don't like this use of singleton-ish states.
            TurboState.currentState.trackCollision(myTag, tag);
        }
        return this;
    }

    // Calling colour without calling size (or vice-versa) should give sensible results
    // The default is a 32x32 red square
    public function colour(red:Int, green:Int, blue:Int):Entity
    {
        if (!this.has(ColourComponent))
        {
            this.add(new ColourComponent(red, green, blue, 32, 32)); // default size
        }
        else
        {        
            var c = this.get(ColourComponent);
            this.add(new ColourComponent(red, green, blue, c.width, c.height));
        }

        if (!this.has(PositionComponent))
        {
            this.add(new PositionComponent(0, 0));
        }

        return this;
    }
    
    public function health(maximumHealth:Int):Entity
    {
        this.add(new HealthComponent(maximumHealth));
        return this;
    }

    public function hide():Entity
    {
        var img = this.get(ImageComponent);
        if (img != null)
        {
            img.show = false;
        }

        var text = this.get(TextComponent);
        if (text != null)
        {
            text.show = false;
        }
        return this;
    }
    
    public function image(image:String, repeat:Bool = false):Entity
    {
        if (this.has(ImageComponent))
        {
            this.remove(ImageComponent);
        }

        this.add(new ImageComponent(image, repeat));
        
        if (!this.has(PositionComponent))
        {
            this.move(0, 0);
        }
        return this;
    }

    // Don't move when resolving collisions
    public function immovable():Entity
    {
        if (this.has(ColourComponent))
        {
            this.get(ColourComponent).sprite.immovable = true;
        }
        else if (this.has(ImageComponent))
        {
            this.get(ImageComponent).sprite.immovable = true;
        }

        return this;
    }
    
    public function move(x:Float, y:Float):Entity
    {
        this.add(new PositionComponent(x, y));
        // Make things move immediately, even if we didn't add the entity
        // to the current state.
        this.update(0);
        return this;
    } 
    
    // MoveSpeed is in pixels per second
    public function moveWithKeyboard(moveSpeed:Int):Entity
    {
        this.add(new KeyboardInputComponent(moveSpeed));
        return this;
    }
    
    public function onClick(callback:FlxSprite->Void, isPixelPerfect:Bool = true):Entity
    {
        var mc:MouseClickComponent = new MouseClickComponent(callback, isPixelPerfect);
        this.add(mc);
        return this;
    }

    public function onEveryFrame(callback:Void->Void):Entity
    {
        this.everyFrame = callback;
        return this;
    }
    
    public function rotate(angleInDegrees:Int):Entity
    {
        var img = this.get(ImageComponent);
        if (img != null)
        {
            img.sprite.angle = angleInDegrees;
        }
        var colour = this.get(ColourComponent);
        if (colour != null)
        {
            colour.sprite.angle = angleInDegrees;
        }
        return this;
    }

    public function show():Entity
    {
        var img = this.get(ImageComponent);
        if (img != null)
        {
            img.sprite.alpha = 1;
        }

        var text = this.get(TextComponent);
        if (text != null)
        {
            text.textField.alpha = 1;
        }
        return this;
    }
    
    public function size(width:Int, height:Int):Entity
    {
        if (!this.has(ColourComponent))
        {
            this.add(new ColourComponent(255, 0, 0, width, height)); // default colour
        }
        else
        {
            var c = this.get(ColourComponent);
            this.remove(ColourComponent);
            this.add(new ColourComponent(c.red, c.green, c.blue, width, height));   
        }        

        if (!this.has(PositionComponent))
        {
            this.add(new PositionComponent(0, 0));
        }

        return this;
    }

    public function text(message:String, fontSize:Int = 36):Entity
    {
        this.add(new TextComponent(message, fontSize));
        return this;
    }

    public function trackWithCamera():Entity
    {
        this.add(new CameraComponent());
        return this;
    }

    /////////////////////// End fluent API ///////////////////////
}

private class AfterEvent
{
    public var seconds(default, default):Float;
    public var callback(default, null):Void->Void;

    public function new(seconds:Float, callback:Void->Void)
    {
        this.seconds = seconds;
        this.callback = callback;
    }
}