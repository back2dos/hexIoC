package hex.ioc.control;

import hex.error.Exception;
import hex.error.PrivateConstructorException;
import hex.ioc.vo.FactoryVO;

/**
 * ...
 * @author Francis Bourre
 */
class FunctionFactory
{
	/** @private */
    function new()
    {
        throw new PrivateConstructorException();
    }

	static public function build( factoryVO : FactoryVO ) : Dynamic
	{
		var result : Dynamic 	= null;
		var constructorVO 		= factoryVO.constructorVO;
		var args 				= constructorVO.arguments[ 0 ].split(".");
		var targetID 			= args[ 0 ];
		var path 				= args.slice( 1 ).join( "." );
		
		var coreFactory			= factoryVO.contextFactory.getCoreFactory();

		if ( !coreFactory.isRegisteredWithKey( targetID ) )
		{
			factoryVO.contextFactory.buildObject( targetID );
		}

		var target = coreFactory.locate( targetID );

		try
		{
			result = coreFactory.fastEvalFromTarget( target, path );

		} catch ( error : Dynamic )
		{
			// bugfix: Should safe cast target to prevent that var target is typed as String on Flash target
			var msg = "FunctionFactory.build() failed on " + cast(target, String) + " with id '" + targetID + "'. ";
			msg += path + " method can't be found.";
			throw new Exception( msg );
		}

		return result;
	}
}