package turbo.ecs.system;

import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import IntComponent;
using massive.munit.Assert;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.Entity;
import turbo.ecs.systems.KeyboardInputMovementSystem;

@:access(turbo.ecs.systems.KeyboardInputMovementSystem)
class KeyboardInputMovementSystemTest
{
    private var system:TestableKeyboardInputMovementSystem;
    
    @Before
    public function mockOutSystemInputReceiver()
    {
        system = new TestableKeyboardInputMovementSystem();
    }
    
    @Test
    public function entitiesNeedAPositionSpriteAndKeyboardInput()
    {
        var e = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(e);               
        Assert.areEqual(0, system.entities.length);
        
        var e2 = new Entity()
            .add(new PositionComponent(0, 0))
            .add(new KeyboardInputComponent(1))
            .add(new ImageComponent("images/fake.jpg"));
        system.entityChanged(e2);        
        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(e2, system.entities[0]);
    }
    
    @Test
    public function updateUpdatesVelocityAndMovesSpriteIfArrowKeysPressed()
    {
        var s = new SpriteComponent();
        s.sprite = new FlxSprite();
        
        var e = new Entity().add(s)
            .add(new KeyboardInputComponent(100)) // 100px/s
            .add(new PositionComponent(0 ,0));
            
        system.entityChanged(e);  
              
        system.press(FlxKey.LEFT);
        system.update(0.5); // 0.5s
        Assert.areEqual(-100, s.sprite.velocity.x);
        system.release(FlxKey.LEFT);
        
        system.press(FlxKey.RIGHT);
        system.update(1);       
        Assert.areEqual(100, s.sprite.velocity.x);
        system.release(FlxKey.RIGHT);

        system.press(FlxKey.UP);
        system.update(2);
        Assert.areEqual(-100, s.sprite.velocity.y);
        system.release(FlxKey.UP);
        
        system.press(FlxKey.DOWN);
        system.update(1);       
        Assert.areEqual(100, s.sprite.velocity.y);
        system.release(FlxKey.DOWN);
    }
    
    @Test
    public function updateMovesPositionIfWASDKeysPressed()
    {
        var s = new SpriteComponent();
        s.sprite = new FlxSprite();
        
        var e = new Entity().add(s)
            .add(new KeyboardInputComponent(100)) // 100px/s
            .add(new PositionComponent(0 ,0));
            
        system.entityChanged(e);  
              
        system.press(FlxKey.A);
        system.update(0.5); // 0.5s
        Assert.areEqual(-100, s.sprite.velocity.x);
        system.release(FlxKey.A);
        
        system.press(FlxKey.D);
        system.update(1);       
        Assert.areEqual(100, s.sprite.velocity.x);
        system.release(FlxKey.D);

        system.press(FlxKey.W);
        system.update(2);
        Assert.areEqual(-100, s.sprite.velocity.y);
        system.release(FlxKey.W);
        
        system.press(FlxKey.S);
        system.update(1);       
        Assert.areEqual(100, s.sprite.velocity.y);
        system.release(FlxKey.S);    
    }
    
}

// keyCodes can be retrieved via FlxKey, eg. FlxKey.LEFT
private class TestableKeyboardInputMovementSystem extends KeyboardInputMovementSystem
{
    private var pressed:Array<Int> = [];
    
    public function press(keyCode:Int):Void
    {
        pressed.push(keyCode);
    }
    
    public function release(keyCode:Int):Void
    {
        pressed.remove(keyCode);
    }
    
    override private function isPressed(keyCode:Int):Bool
    {
        return (pressed.indexOf(keyCode) > -1);
    }
}