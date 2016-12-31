package hex.ioc.vo;

#if macro
import haxe.macro.Expr;
#end

import hex.ioc.core.IContextFactory;
import hex.core.ICoreFactory;
import hex.ioc.locator.ModuleLocator;

/**
 * ...
 * @author Francis Bourre
 */
class FactoryVO
{
	public var type 					: String;
	public var contextFactory 			: IContextFactory;
	public var coreFactory				: ICoreFactory;
	public var constructorVO 			: ConstructorVO;
	public var moduleLocator			: ModuleLocator;
	
	#if macro
	public var expressions 				: Array<Expr>;
	#end

	public function new() 
	{
		
	}
}