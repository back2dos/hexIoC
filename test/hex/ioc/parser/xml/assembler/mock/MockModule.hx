package hex.ioc.parser.xml.assembler.mock;

import hex.module.Module;
import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencies;
import hex.state.State;

/**
 * ...
 * @author Francis Bourre
 */
class MockModule extends Module
{
	public var callbackCount : Int = 0;
	public var stateCallback : State = null;
	
	public function new() 
	{
		super();
	}
	
	#if debug
	override function _getRuntimeDependencies() : IRuntimeDependencies 
	{
		return new RuntimeDependencies();
	}
	#end
	
	public function callback( state : State ) : Void
	{
		this.callbackCount++;
		this.stateCallback = state;
	}
}