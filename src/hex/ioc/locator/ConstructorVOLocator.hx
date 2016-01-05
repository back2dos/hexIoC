package hex.ioc.locator;

import hex.collection.Locator;
import hex.collection.LocatorEvent;
import hex.ioc.core.BuilderFactory;
import hex.ioc.vo.ConstructorVO;

/**
 * ...
 * @author Francis Bourre
 */
class ConstructorVOLocator extends Locator<String, ConstructorVO, LocatorEvent<String, ConstructorVO>>
{
	private var _builderFactory : BuilderFactory;

	public function new( builderFactory : BuilderFactory )
	{
		super();
		this._builderFactory = builderFactory;
	}

	public function buildObject( id : String ) : Void
	{
		if ( this.isRegisteredWithKey( id ) )
		{
			var cons : ConstructorVO = this.locate( id );
			if ( cons.arguments != null )
			{
				cons.arguments = this._builderFactory.getPropertyVOLocator().deserializeArguments( cons.arguments );
			}

			this._builderFactory.build( cons, id );
			this.unregister( id );
		}
	}

	public function buildAllObjects() : Void
	{
		var keys : Array<String> = this.keys();
		for ( key in keys )
		{
			this.buildObject( key );
		}
	}
	
	override function _dispatchRegisterEvent( key : String, element : ConstructorVO ) : Void 
	{
		this._dispatcher.dispatchEvent( new LocatorEvent( LocatorEvent.REGISTER, this, key, element ) );
	}
	
	override function _dispatchUnregisterEvent( key : String ) : Void 
	{
		this._dispatcher.dispatchEvent( new LocatorEvent( LocatorEvent.UNREGISTER, this, key ) );
	}
}