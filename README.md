# Turbo
Turbo is a batteries-included extension for HaxeFlixel. It includes an entity-component framework (and pre-built system), and others.

The entity-component system is inspired by the [Ash framework](http://ashframework.org/)'s design philosophy:
- Components are pure data (no code)
- Entities are just bags of components
- Systems are thin and operate on just what they need

Unlike Ash, Turbo doesn't use nodes (which seem like boilerplate code), with the trade-off that systems operate directly on entities.

Ash is also a framework; Turbo includes a set of systems for writing HaxeFlixel games. See the [list of systems](tree/master/turbo/ecs/system) in code.
  
Small example of a state with a orange square that responds to keyboard movement:

```
class PlayState extends TurboState
{
	override public function create():Void
	{
		super.create();
    new Entity().colour(255, 128, 0).size(48, 48).moveWithKeyboard(100);
	}
}
```

Example of a system that initializes and draws sprites:

```
class DrawImageSystem extends AbstractSystem
{
    private var state:FlxState;
    
    public function new()
    {
        // Get all entities that have both an image and a position
        super([ImageComponent, PositionComponent]);
    }
    
    override public function update(elapsed:Float):Void
    {
        for (entity in this.entities)
        {
            var component:ImageComponent = entity.get(ImageComponent);            
            if (component.sprite == null)
            {
                var s:FlxSprite = new FlxSprite();
                s.loadGraphic(component.image);
                component.sprite =  s;
                this.state.add(s);
            }
            
            // Synch sprite's position with position-component's position
            var pos:PositionComponent = entity.get(PositionComponent);
            component.sprite.x = pos.x;
            component.sprite.y = pos.y;
        }
    }
}
```

# Events

Turbo draws heavy inspiration from CraftyJS, which uses classes for entities (eg. `Monster`) and where developers register callbacks to event handlers to implement custom logic. Below is a list of components and the events that their systems trigger.

- **Entity**: `Tick`: triggered at the end of every frame.
- **KeyboardInputComponent:** `KeyDown` is triggered whenever a key is held down. For now, use `FlxG.keys.checkStatus(keyCode, FlxInputState.PRESSED)` to check for individual key states.
- **MouseClickComponent:** `MouseDown`: triggered when the user clicks the mouse (before the user releases the mouse).
