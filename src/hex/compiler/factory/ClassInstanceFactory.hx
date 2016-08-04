package hex.compiler.factory;

import haxe.macro.Context;
import haxe.macro.Expr;
import hex.di.IDependencyInjector;
import hex.domain.Domain;
import hex.domain.DomainExpert;
import hex.domain.DomainUtil;
import hex.event.MessageType;
import hex.ioc.vo.ConstructorVO;
import hex.ioc.vo.FactoryVO;
import hex.log.ILogger;
import hex.module.IModule;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInstanceFactory
{
	function new()
	{

	}

	#if macro
	static var _domainExpertClass 	= MacroUtil.getPack( Type.getClassName( DomainExpert )  );
	static var _domainUtilClass 	= MacroUtil.getPack( Type.getClassName( DomainUtil )  );
	static var _domainClass 		= MacroUtil.getPack( Type.getClassName( Domain )  );
					
	static public function build( factoryVO : FactoryVO ) : Dynamic
	{
		var constructorVO : ConstructorVO = factoryVO.constructorVO;
		var e : Expr = null;
		
		if ( constructorVO.ref != null )
		{
			e = ReferenceFactory.build( factoryVO );
		}
		else
		{
			var idVar = constructorVO.ID;
			var tp : Array<String> = MacroUtil.getPack( constructorVO.type, constructorVO.filePosition );
			var typePath : TypePath = MacroUtil.getTypePath( constructorVO.type, constructorVO.filePosition );

			//build instance
			var singleton = constructorVO.singleton;
			var factory = constructorVO.factory;
			if ( factory != null )
			{
				if ( singleton != null )
				{
					e = macro @:pos( constructorVO.filePosition ) { $p { tp }.$singleton().$factory( $a{ constructorVO.constructorArgs } ); };
					factoryVO.expressions.push( macro @:mergeBlock { var $idVar = $e; } );
				}
				else
				{
					e = macro @:pos( constructorVO.filePosition ) { $p { tp }.$factory( $a{ constructorVO.constructorArgs } ); };
					factoryVO.expressions.push( macro @:mergeBlock { var $idVar = $e; } );
				}
			
			}
			else if ( singleton != null )
			{
				e = macro @:pos( constructorVO.filePosition ) { $p { tp }.$singleton(); };
				factoryVO.expressions.push( macro @:mergeBlock { var $idVar = $e; } );
			}
			else
			{
				var classType = MacroUtil.getClassType( constructorVO.type );
				var moduleInterface = MacroUtil.getClassType( Type.getClassName( IModule ) );
				
				if ( MacroUtil.implementsInterface( classType, moduleInterface ) )
				{
					//TODO register to AnnotationProvider
					//AnnotationProvider.registerToDomain( factoryVO.contextFactory.getAnnotationProvider(), DomainUtil.getDomain( constructorVO.ID, Domain ) );

					//TODO register for every instance (from singleton and/or factory)
					//TODO optimize calls to DomainUtil
					factoryVO.expressions.push( macro @:mergeBlock { $p { _domainExpertClass } .getInstance().registerDomain( $p { _domainUtilClass } .getDomain( $v { idVar }, $p { _domainClass } ) ); } );
					factoryVO.moduleLocator.register( constructorVO.ID, new EmptyModule( constructorVO.ID ) );
				}
				
				e = macro @:pos( constructorVO.filePosition ) { new $typePath( $a{ constructorVO.constructorArgs } ); };
				factoryVO.expressions.push( macro @:mergeBlock { var $idVar = $e; } );
				
				var annotationParsableInterface = MacroUtil.getClassType( "hex.core.IAnnotationParsable" );
				if ( MacroUtil.implementsInterface( classType, annotationParsableInterface ) )
				{
					var instanceVar = macro $i { idVar };
					var annotationProviderVar = macro $i { "__annotationProvider" };
					factoryVO.expressions.push( macro @:pos( constructorVO.filePosition ) @:mergeBlock { $annotationProviderVar.parse( $instanceVar ); } );
				}
			}

			if ( constructorVO.mapType != null )
			{
				var instanceVar = macro $i { idVar };
				var classToMap = MacroUtil.getPack( constructorVO.mapType, constructorVO.filePosition );
				factoryVO.expressions.push( macro @:pos( constructorVO.filePosition ) @:mergeBlock { __applicationContextInjector.mapToValue( $p{ classToMap }, $instanceVar, $v { idVar } ); } );
			}
		}

		return e;
	}
	#end
}

private class EmptyModule implements IModule
{
	var _domainName : String;
	
	public function new( domainName : String )
	{
		this._domainName = domainName;
	}
	
	public function initialize() : Void 
	{
		
	}
	
	public var isInitialized( get, null ) : Bool;
	
	function get_isInitialized() : Bool 
	{
		return false;
	}
	
	public function release() : Void 
	{
		
	}
	
	public var isReleased( get, null ) : Bool;
	
	function get_isReleased() : Bool 
	{
		return false;
	}
	
	public function dispatchPublicMessage( messageType : MessageType, ?data : Array<Dynamic> ) : Void 
	{
		
	}
	
	public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		
	}
	
	public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void 
	{
		
	}
	
	public function getDomain() : Domain 
	{
		return DomainUtil.getDomain( this._domainName, Domain );
	}
	
	public function getLogger() : ILogger 
	{
		return null;
	}
	
	public function getInjector() : IDependencyInjector 
	{
		return null;
	}
}