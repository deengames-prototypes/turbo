package turbo.ecs;

import turbo.ecs.Container;
import turbo.ecs.AfterEvent;
import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.PositionComponent;

class Entity
{
    public var container(default, default):Container;

    // Convenience methods
    public var x(get, null):Float;
    public var y(get, null):Float;
    public var width(get, null):Int;
    public var height(get, null):Int;

    private var components:Map<String, AbstractComponent>; // Can change AbstractComponent to Any

    // Can't write tags because we put entities in a hashmap based on tags, 
    // and use that to determinte collisions. Erm, we have to reprocess
    // the entity if its tags change.
    public var tags(default, null):Array<String>;

    // internal: Seconds from now => event to call
    public var afterEvents(default, null):Array<AfterEvent> = new Array<AfterEvent>();

    // Arbitrary key/value pairs
    private var data = new Map<String, Any>();

    // Event handlers: key => callback
    // TODO: if we need multiple handlers, change value to Array<Void->Void>
    private var eventHandlers = new Map<String, Void->Void>();
    
    public function new(tag:String = null)
    {
        this.container = Container.instance;
        this.components = new Map<String, AbstractComponent>();

        if (tag == null)
        {
            this.tags = [];
        }
        else
        {
            this.tags = [tag];
        }
        
        // Can't auto-add entity to state because that makes collision
        // initialization really screwy (sprites are not initialized yet).
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

        this.trigger("Tick");
    }

    // Bind/trigger events
    public function bind(eventName:String, callback:Void->Void):Entity
    {
        if (this.eventHandlers.exists(eventName))
        {
            // If you reach this, add an unbind method of some sort too.
            throw 'Entity already has an event handler for ${eventName}; please support multiple event-handlers!';
        }

        this.eventHandlers.set(eventName, callback);
        return this;
    }

    public function trigger(eventName:String):Entity
    {
        if (this.eventHandlers.exists(eventName))
        {
            this.eventHandlers.get(eventName)();
        }
        return this;
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

    // convenience methods

    public function get_x():Float
    {
        return this.get(PositionComponent).x;
    }

    public function get_y():Float
    {
        return this.get(PositionComponent).y;
    }

    public function get_width():Int
    {
        return Std.int(this.get(SpriteComponent).sprite.width);
    }

    public function get_height():Int
    {
        return Std.int(this.get(SpriteComponent).sprite.height);
    }
}