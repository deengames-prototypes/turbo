package turbo.ecs;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.HealthComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.VelocityComponent;

class Entity
{
    private var components:Map<String, AbstractComponent>;
    private var tags(default, null):Array<String>;
    private var data = new Map<String, Any>();
    private var everyFrame:Void->Void;

    public function new()
    {
        this.components = new Map<String, AbstractComponent>();
        this.tags = [];
    }
        
    ////////////////////// Start fluent API //////////////////////
    // Please sort alphabetically
    
    // Calling colour without calling size (or vice-versa) should give sensible results
    // The default is a 32x32 red square
    public function colour(red:Int, green:Int, blue:Int):Entity
    {
        if (!this.has(ColourComponent))
        {
            this.add(new ColourComponent(red, green, blue, 32, 32, this)); // default size
        }
        else
        {        
            var c = this.get(ColourComponent);
            this.add(new ColourComponent(red, green, blue, c.width, c.height, this));
        }

        if (!this.has(PositionComponent))
        {
            this.add(new PositionComponent(0, 0, this));
        }

        return this;
    }
    
    public function health(maximumHealth:Int):Entity
    {
        this.add(new HealthComponent(maximumHealth, this));
        return this;
    }

    public function hide():Entity
    {
        var img = this.get(ImageComponent);
        if (img != null)
        {
            img.sprite.alpha = 0;
        }
        return this;
    }
    
    public function image(image:String, repeat:Bool = false):Entity
    {
        this.add(new ImageComponent(image, repeat, this));
        if (!this.has(PositionComponent))
        {
            this.move(0, 0);
        }
        return this;
    }
    
    public function move(x:Float, y:Float):Entity
    {
        this.add(new PositionComponent(x, y, this));
        return this;
    } 
    
    // MoveSpeed is in pixels per second
    public function moveWithKeyboard(moveSpeed:Int):Entity
    {
        this.add(new KeyboardInputComponent(moveSpeed, this));
        return this;
    }
    
    public function onClick(callback:Float->Float->Void):Entity
    {
        var mouseComponent:MouseClickComponent = new MouseClickComponent(callback, null, this);
        this.add(mouseComponent);
        return this;
    }

    public function onEveryFrame(callback:Void->Void):Entity
    {
        this.everyFrame = callback;
        return this;
    }

    public function show():Entity
    {
        var img = this.get(ImageComponent);
        if (img != null)
        {
            img.sprite.alpha = 1;
        }
        return this;
    }
    
    public function size(width:Int, height:Int):Entity
    {
        if (!this.has(ColourComponent))
        {
            this.add(new ColourComponent(255, 0, 0, width, height, this)); // default colour
        }
        else
        {
            var c = this.get(ColourComponent);
            var clr = c.colour;
            
            this.remove(ColourComponent);
            ColourComponent.onRemove(c);
            
            this.add(new ColourComponent(clr.red, clr.green, clr.blue, width, height, this));   
        }        

        if (!this.has(PositionComponent))
        {
            this.add(new PositionComponent(0, 0, this));
        }

        return this;
    }

    public function trackWithCamera():Entity
    {
        this.add(new CameraComponent(this));
        return this;
    }

    public function velocity(vx:Float, vy:Float):Entity
    {
        this.add(new VelocityComponent(vx, vy, this));
        return this;
    }
    
    /////////////////////// End fluent API ///////////////////////
    
    // You can only have one of each component by type
    public function add(component:AbstractComponent):Entity
    {
        var clazz = Type.getClass(component);
        var name = Type.getClassName(clazz);
        if (this.has(clazz))
        {
            this.remove(clazz);
        }
        this.components.set(name, component);
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
        return this;
    }
    
    // c is a Class<AbstractComponent> eg. SpriteComponent
    public function get<T>(clazz:Class<T>):T
    {
        var name:String = Type.getClassName(clazz);
        var toReturn:AbstractComponent = this.components.get(name);
        
        if (toReturn == null)
        {
            // Don't have the exact type. Maybe we have a subtype?
            // eg. asked for SpriteComponent when we have ImageComponent
            for (component in this.components)
            {
                if (Std.is(component, clazz))
                {
                    return cast(component);
                }                
            }
        }
        
        return cast(toReturn);
    }
    
    public function has(clazz:Class<AbstractComponent>):Bool
    {
        return this.get(clazz) != null;
    }

    public function onEvent(event:String):Void
    {
        for (component in this.components)
        {
            component.onEvent(event);
        }
    }

    public function update(elapsedSeconds:Float):Void
    {
        for (component in this.components)
        {
            component.update(elapsedSeconds);
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
}