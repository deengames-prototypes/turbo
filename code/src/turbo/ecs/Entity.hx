package turbo.ecs;

import turbo.ecs.Container;
import turbo.ecs.AfterEvent;
import turbo.ecs.components.AbstractComponent;

/////////// TODO: add bind/trigger methods
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

    // internal
    public var everyFrame(default, default):Void->Void;
    // Seconds from now => event to call
    public var afterEvents(default, null):Array<AfterEvent> = new Array<AfterEvent>();
    
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
}