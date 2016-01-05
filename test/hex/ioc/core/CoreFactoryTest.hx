package hex.ioc.core;

import hex.collection.ILocatorListener;
import hex.collection.LocatorEvent;
import hex.error.IllegalArgumentException;
import hex.event.IEvent;
import hex.structures.Point;
import hex.structures.Size;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class CoreFactoryTest
{
	public static inline var STATIC_REF : String = "static_ref";
	
	private var _coreFactory : CoreFactory;

    @setUp
    public function setUp() : Void
    {
        this._coreFactory = new CoreFactory();
    }

    @tearDown
    public function tearDown() : Void
    {
        this._coreFactory = null;
    }
	
	@test( "Test register" )
    public function testRegister() : Void
    {
		var listener : MockCoreFactoryListener = new MockCoreFactoryListener();
		this._coreFactory.addListener( listener );
		
		var value : MockValue = new MockValue();
		Assert.isFalse( this._coreFactory.isRegisteredWithKey( "key" ),  "'isRegisteredWithKey' should return false" );
		Assert.isFalse( this._coreFactory.isInstanceRegistered( value ),  "'isInstanceRegistered' should return false" );
		
		Assert.isTrue( this._coreFactory.register( "key", value ),  "'register' should return true" );
		Assert.equals( 1, listener.registerEventCount, "listener should have received a register event" );
		Assert.equals( "key", listener.lastRegisterEventReceived.key, "event key should be the same" );
		Assert.equals( value, listener.lastRegisterEventReceived.value, "event value should be the same" );
		Assert.equals( 0, listener.unregisterEventCount, "listener should not have received an unregister event" );
		
		Assert.isTrue( this._coreFactory.isRegisteredWithKey( "key" ),  "'isRegisteredWithKey' should return true" );
		Assert.isTrue( this._coreFactory.isInstanceRegistered( value ),  "'isInstanceRegistered' should return true" );
		Assert.methodCallThrows( IllegalArgumentException, this._coreFactory, this._coreFactory.register, [ "key", new MockValue() ],  "'register' should throw IllegalArgumentException when used twice with the same key" );
	}
	
	@test( "Test unregisterWithKey" )
    public function testUnregisterWithKey() : Void
    {
		var listener : MockCoreFactoryListener = new MockCoreFactoryListener();
		this._coreFactory.addListener( listener );
		
		var value : MockValue = new MockValue();
		this._coreFactory.register( "key", value );
		listener.registerEventCount = 0;
		
		Assert.isTrue( this._coreFactory.unregisterWithKey( "key" ), "'unregisterWithKey' should return true" );
		
		Assert.equals( 1, listener.unregisterEventCount, "listener should have received an unregister event" );
		Assert.equals( "key", listener.lastRegisterEventReceived.key, "event key should be the same" );
		Assert.equals( value, listener.lastRegisterEventReceived.value, "event value should be the same" );
		Assert.equals( 0, listener.registerEventCount, "listener should not have received a register event" );
		
		Assert.isFalse( this._coreFactory.isRegisteredWithKey( "key" ),  "'isRegisteredWithKey' should return false" );
		Assert.isFalse( this._coreFactory.isInstanceRegistered( value ),  "'isInstanceRegistered' should return false" );
		Assert.isFalse( this._coreFactory.unregisterWithKey( "key" ), "'unregisterWithKey' should return false" );
	}
	
	@test( "Test unregister" )
    public function testUnregister() : Void
    {
		var listener : MockCoreFactoryListener = new MockCoreFactoryListener();
		this._coreFactory.addListener( listener );
		
		var value : MockValue = new MockValue();
		this._coreFactory.register( "key", value );
		listener.registerEventCount = 0;
		
		Assert.isTrue( this._coreFactory.unregister( value ), "'unregister' should return true" );
		
		Assert.equals( 1, listener.unregisterEventCount, "listener should have received an unregister event" );
		Assert.equals( "key", listener.lastRegisterEventReceived.key, "event key should be the same" );
		Assert.equals( value, listener.lastRegisterEventReceived.value, "event value should be the same" );
		Assert.equals( 0, listener.registerEventCount, "listener should not have received a register event" );
		
		Assert.isFalse( this._coreFactory.isRegisteredWithKey( "key" ),  "'isRegisteredWithKey' should return false" );
		Assert.isFalse( this._coreFactory.isInstanceRegistered( value ),  "'isInstanceRegistered' should return false" );
		Assert.isFalse( this._coreFactory.unregister( value ), "'unregister' should return false" );
	}
	
	@test( "Test getKeyOfInstance" )
    public function testGetKeyOfInstance() : Void
    {
		Assert.isNull( this._coreFactory.getKeyOfInstance( "key" ), "'getKeyOfInstance' should return null" );
		var value : MockValue = new MockValue();
		this._coreFactory.register( "key", value );
		Assert.equals( "key", this._coreFactory.getKeyOfInstance( value ), "'getKeyOfInstance' should return value associated to the key" );
	}
	
	@test( "Test getClassReference" )
    public function testGetClassReference() : Void
    {
		Assert.equals( CoreFactoryTest, this._coreFactory.getClassReference( "hex.ioc.core.CoreFactoryTest" ), "'getClassReference' should return the right class reference" );
		Assert.methodCallThrows( IllegalArgumentException, this._coreFactory, this._coreFactory.getClassReference, ["dummy.unavailable.Class"], "'getClassReference' should throw IllegalArgumentException" );
	}
	
	@test( "Test getStaticReference" )
    public function testGetStaticReference() : Void
    {
		Assert.equals( "static_ref", this._coreFactory.getStaticReference( "hex.ioc.core.CoreFactoryTest.STATIC_REF" ), "'getStaticReference' should return the right static property" );
		Assert.methodCallThrows( IllegalArgumentException, this._coreFactory, this._coreFactory.getStaticReference, ["hex.ioc.core.CoreFactoryTest.UnavailableStaticRef"], "'getStaticReference' should throw IllegalArgumentException" );
	}
	
	@test( "Test buildInstance with arguments" )
    public function testBuildInstanceWithArguments() : Void
    {
		var p : Point = this._coreFactory.buildInstance( "hex.structures.Point", [2, 3] );
		Assert.isNotNull( p, "'p' should not be null" );
		Assert.equals( 2, p.x, "'p.x' should return 2" );
		Assert.equals( 3, p.y, "'p.x' should return 3" );
	}
	
	@test( "Test buildInstance with singleton access" )
    public function testBuildInstanceWithSingletonAccess() : Void
    {
		var instance : MockClassForCoreFactoryTest = this._coreFactory.buildInstance( "hex.ioc.core.MockClassForCoreFactoryTest", null, null, "getInstance" );
		Assert.isInstanceOf( instance, MockClassForCoreFactoryTest, "should be instance of 'MockClassForCoreFactoryTest'" );
	}
	
	@test( "Test buildInstance with factory access" )
    public function testBuildInstanceWithFactoryAccess() : Void
    {
		var size : Size = this._coreFactory.buildInstance( "hex.ioc.core.MockClassForCoreFactoryTest", [20, 30], "getSize", null );
		Assert.isNotNull( size, "'size' should not be null" );
		Assert.equals( 20, size.width, "'size.width' should return 20" );
		Assert.equals( 30, size.height, "'size.height' should return 30" );
	}
	
	@test( "Test buildInstance with factory and singleton access" )
    public function testBuildInstanceWithFactoryAndSingletonAccess() : Void
    {
		var p : Point = this._coreFactory.buildInstance( "hex.ioc.core.MockClassForCoreFactoryTest", [2, 3], "getPoint", "getInstance" );
		Assert.isNotNull( p, "'p' should not be null" );
		Assert.equals( 2, p.x, "'p.x' should return 2" );
		Assert.equals( 3, p.y, "'p.x' should return 3" );
	}
}

private class MockValue
{
	public function new()
	{
		
	}
}

private class MockCoreFactoryListener implements ILocatorListener<LocatorEvent<String, Dynamic>>
{
	public var lastRegisterEventReceived		: LocatorEvent<String, Dynamic>;
	public var registerEventCount				: Int = 0;
	public var lastUnregisterEventReceived		: LocatorEvent<String, Dynamic>;
	public var unregisterEventCount				: Int = 0;
	
	public function new ()
	{
		
	}
	
	public function onRegister( e : LocatorEvent<String, Dynamic> ) : Void 
	{
		this.lastRegisterEventReceived = e;
		this.registerEventCount++;
	}
	
	public function onUnregister( e : LocatorEvent<String, Dynamic> ) : Void 
	{
		this.lastUnregisterEventReceived = e;
		this.unregisterEventCount++;
	}
	
	public function handleEvent( e : IEvent ) : Void 
	{
		
	}
}