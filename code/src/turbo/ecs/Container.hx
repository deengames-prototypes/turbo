package turbo.ecs;

import turbo.ecs.TurboState;
import turbo.ecs.components.AbstractComponent;
import turbo.ecs.systems.AbstractSystem;
import turbo.ecs.systems.CollisionSetupSystem;
import turbo.ecs.systems.DrawColourSystem;
import turbo.ecs.systems.DrawImageSystem;
import turbo.ecs.systems.DrawTextSystem;
import turbo.ecs.systems.KeyboardInputMovementSystem;
import turbo.ecs.systems.KeyboardInputSystem;
import turbo.ecs.systems.FollowCameraSystem;
import turbo.ecs.systems.MouseClickSystem;
import turbo.ecs.systems.MoveSystem;
import turbo.ecs.systems.VelocitySystem;

// The main class that glues everything together. In Ash, this is called "engine."
// A collection of components and systems. Use this per screen or whatever.
class Container
{
    public static var instance(get, null):Container;
    public var entities:Array<Entity>;
    public var systems:Array<AbstractSystem>;
    
    public function new()
    {
        instance = this;
        this.entities = new Array<Entity>();
        this.systems = new Array<AbstractSystem>();
    }
    
    public function update(elapsed:Float):Void
    {
        for (system in systems)
        {
            system.update(elapsed);
        }
    }
    
    public function addSystem(system:AbstractSystem):Container
    {
        this.systems.push(system);
        system.create();
        return this;
    }
    
    public function addEntity(entity:Entity):Void
    {
        entity.container = this;
        this.entities.push(entity);
        for (system in systems)
        {
            this.entityChanged(entity);
        }
    }
    
    public function entityChanged(entity:Entity):Void
    {
        for (system in this.systems)
        {
            system.entityChanged(entity);
        }
    }

    public function removeEntity(entity:Entity):Void
    {
        this.entities.remove(entity);

        for (system in this.systems)
        {
            system.removeEntity(entity);
        }
    }
    
    public function addDefaultSystems():Void
    {
        var state:TurboState = TurboState.currentState;

        this.addSystem(new KeyboardInputMovementSystem())
            .addSystem(new KeyboardInputSystem())
            .addSystem(new FollowCameraSystem())
            .addSystem(new MouseClickSystem())
            .addSystem(new MoveSystem())
            .addSystem(new VelocitySystem())
            // These are always last so we guarantee consistency
            .addSystem(new DrawImageSystem(state))
            .addSystem(new DrawColourSystem(state))
            .addSystem(new DrawTextSystem(state))
            // Done last because it requires initialized sprites
            .addSystem(new CollisionSetupSystem());            
    }

    public static function get_instance():Container
    {
        if (Container.instance == null)
        {
            new Container(); // sets instance
        }

        return Container.instance;
    }
}