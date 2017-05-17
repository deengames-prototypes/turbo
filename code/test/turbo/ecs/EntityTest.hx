package turbo.ecs;

using massive.munit.Assert;
import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.MouseClickComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.Container;
import turbo.ecs.Entity;

class EntityTest
{
    @Test
    public function constructorSetsContainerToConstainerInstance()
    {
        var c1 = new Container();
        var c2 = new Container();
        var e = new Entity();
        Assert.areEqual(c2, e.container);
    }
    
    @Test
    public function hasReturnsTrueIfComponentExists()
    {
        var e = new Entity().add(new StringComponent("hi"));
        Assert.isTrue(e.has(StringComponent));
        Assert.isFalse(e.has(IntComponent));
    }
    
    @Test
    public function hasReturnsTrueForSuperTypes()
    {
        var e = new Entity().image("fake.jpg");
        Assert.isTrue(e.has(ImageComponent)); // what we added
        Assert.isTrue(e.has(SpriteComponent)); // super class of image component
    }
    
    @Test
    public function getGetsComponentIfExists()
    {
        var expected = new IntComponent(107);
        var e = new Entity().add(expected);
        Assert.areEqual(expected, e.get(IntComponent));
        Assert.isNull(e.get(StringComponent));
    }
    
    @Test
    public function removeRemovesComponent()
    {
        var s = new StringComponent("named entity");
        var e = new Entity().add(s);
        Assert.areEqual(s, e.get(StringComponent));
        Assert.isTrue(e.has(StringComponent));
        e.remove(StringComponent);
        Assert.isNull(e.get(StringComponent));
        Assert.isFalse(e.has(StringComponent));        
    }
    
    // Fluent API tests below
    
    @Test
    public function moveAddsPositionComponent()
    {
        var e = new Entity().move(27, 31);
        Assert.isTrue(e.has(PositionComponent));
        var p = e.get(PositionComponent);
        Assert.areEqual(27, p.x);
        Assert.areEqual(31, p.y);
    }
    
    
    @Test
    public function imageAddsImageComponent()
    {
        var image:String = "assets/apple.png";
        var e = new Entity().image(image);
        Assert.isTrue(e.has(ImageComponent));
        Assert.areEqual(image, e.get(ImageComponent).image);
    }
    
    @Test
    public function moveWithKeyboardAddsKeyboardInputComponent()
    {
        var speed:Int = 171;
        var e = new Entity().moveWithKeyboard(speed);
        Assert.isTrue(e.has(KeyboardInputComponent));
        Assert.areEqual(speed, e.get(KeyboardInputComponent).moveSpeed);
    }
    
    @Test
    public function onClickAddsMouseClickComponent()
    {
        var clickHandler = function(x:Float, y:Float)
        {
            trace('Clicked on ${x}, ${y}');
        }
        
        var e = new Entity().onClick(clickHandler);
        Assert.isTrue(e.has(MouseClickComponent));
        var actual = e.get(MouseClickComponent);
        Assert.areEqual(1, actual.callbacks.length);
        Assert.areEqual(clickHandler, actual.callbacks[0]);
    }
    
    @Test
    public function colourWithoutSizeAddsColourWithDefaultSize()
    {
        var e = new Entity().colour(0, 128, 255);
        Assert.isTrue(e.has(ColourComponent));
        var actual = e.get(ColourComponent);
        Assert.areEqual(0, actual.red);
        Assert.areEqual(128, actual.green);
        Assert.areEqual(255, actual.blue);
        // As long as it has a size, we're good
        Assert.isTrue(actual.width > 0);
        Assert.isTrue(actual.height > 0);
    }
    
    @Test
    public function colourAfterSizeAddsColourButDoesntChangeSize()
    {
        var e = new Entity().size(128, 27).colour(255, 64, 101);
        Assert.isTrue(e.has(ColourComponent));
        var actual = e.get(ColourComponent);
        
        Assert.areEqual(255, actual.red);
        Assert.areEqual(64, actual.green);
        Assert.areEqual(101, actual.blue);
        // Didn't change size
        Assert.areEqual(128, actual.width);
        Assert.areEqual(27, actual.height);
    }
    
    @Test
    public function sizeWithoutColourAddsSizeWithDefaultColour()
    {
        var e = new Entity().size(8, 8);
        Assert.isTrue(e.has(ColourComponent));
        var actual = e.get(ColourComponent);
        Assert.areEqual(8, actual.width);
        Assert.areEqual(8, actual.height);
        // As long as it has some colour, we're good
        Assert.isTrue(actual.red > 0 || actual.green > 0 || actual.blue > 0);
    }
    
    @Test
    public function sizeAfterColourAddsSizeButDoesntChangeColour()
    {
        var e = new Entity().colour(12, 24, 79).size(18, 17);
        Assert.isTrue(e.has(ColourComponent));
        var actual = e.get(ColourComponent);
        Assert.areEqual(18, actual.width);
        Assert.areEqual(17, actual.height);
        // Didn't change colour
        Assert.areEqual(12, actual.red);
        Assert.areEqual(24, actual.green);
        Assert.areEqual(79, actual.blue);
    }
}