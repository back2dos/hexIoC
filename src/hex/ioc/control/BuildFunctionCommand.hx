package hex.ioc.control;

import hex.event.IEvent;
import hex.error.Exception;
import hex.ioc.vo.ConstructorVO;
import hex.util.ObjectUtil;

/**
 * ...
 * @author Francis Bourre
 */
class BuildFunctionCommand extends AbstractBuildCommand
{
	override public function execute( ?e : IEvent ) : Void
	{
		var constructorVO : ConstructorVO = this._buildHelperVO.constructorVO;

		var method : Dynamic;
		var msg : String;

		var args : Array<String> = constructorVO.arguments[ 0 ].split(".");
		var targetID : String = args[ 0 ];
		var path : String = args.slice( 1 ).join( "." );

		if ( !this._buildHelperVO.coreFactory.isRegisteredWithKey( targetID ) )
		{
			this._buildHelperVO.builderFactory.getConstructorVOLocator().buildObject( targetID );
		}

		var target : Dynamic = this._buildHelperVO.coreFactory.locate( targetID );

		try
		{
			method = ObjectUtil.fastEvalFromTarget( target, path, this._buildHelperVO.coreFactory );

		} catch ( error : Dynamic )
		{
			msg = " " + this + ".execute() failed on " + target + " with id '" + targetID + "'. ";
			msg += path + " method can't be found.";
			throw new Exception( msg );
		}

		constructorVO.result = method;
	}
}