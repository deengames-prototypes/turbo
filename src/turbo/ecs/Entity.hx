package nebula.ecs;

import nebula.ecs.component.AbstractComponent;
import nebula.ecs.component.CameraComponent;
import nebula.ecs.component.ColourComponent;
import nebula.ecs.component.KeyboardInputComponent;
import nebula.ecs.component.HealthComponent;
import nebula.ecs.component.ImageComponent;
import nebula.ecs.component.MouseClickComponent;
import nebula.ecs.component.PositionComponent;
import nebula.ecs.Container;

class Entity
{
    public var container(default, default):Container;
    private var components:Map<String, AbstractComponent>;
    private var tags(default, null):Array<String>;
    
    public function new()
    {
        this.container = Container.instance;
        this.components = new Map<String, AbstractComponent>();
        this.tags = [];
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
        
    ////////////////////// Start fluent API //////////////////////
    
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
        return this;
    }
    
    public function health(maximumHealth:Int):Entity
    {
        this.add(new HealthComponent(maximumHealth));
        return this;
    }
    
    public function image(image:String, repeat:Bool = false):Entity
    {
        this.add(new ImageComponent(image, repeat));
        return this;
    }
    
    public function move(x:Int, y:Int):Entity
    {
        this.add(new PositionComponent(x, y));
        return this;
    } 
    
    // MoveSpeed is in pixels per second
    public function moveWithKeyboard(moveSpeed:Int):Entity
    {
        this.add(new KeyboardInputComponent(moveSpeed));
        return this;
    }
    
    public function trackWithCamera():Entity
    {
        this.add(new CameraComponent());
        return this;
    }
    
    public function onClick(callback:Float->Float->Void):Entity
    {
        var mouseComponent:MouseClickComponent = new MouseClickComponent();
        mouseComponent.registerCallBack(callback);
        this.add(mouseComponent);
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
            this.add(new ColourComponent(c.red, c.green, c.blue, width, height));   
        }        
        return this;
    }
    
    /////////////////////// End fluent API ///////////////////////
}