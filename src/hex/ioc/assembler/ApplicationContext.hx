package hex.ioc.assembler;

import hex.core.AbstractApplicationContext;
import hex.core.IApplicationContext;
import hex.di.IBasicInjector;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.domain.ApplicationDomainDispatcher;
import hex.domain.Domain;
import hex.error.IllegalStateException;
import hex.event.IDispatcher;
import hex.event.MessageType;
import hex.ioc.core.CoreFactory;
import hex.log.ILogger;
import hex.log.LogManager;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
class ApplicationContext extends AbstractApplicationContext
{
	
	@:allow( hex.runtime )
	function new( applicationContextName : String )
	{
		//build contextDispatcher
		var domain = Domain.getDomain( applicationContextName );
		
		//build injector
		var injector : IDependencyInjector = new Injector();
		injector.mapToValue( IBasicInjector, injector );
		injector.mapToValue( IDependencyInjector, injector );
		
		var logger = LogManager.getLogger( domain.getName() );
		injector.mapToValue( ILogger, logger );
		
		//register applicationContext
		injector.mapToValue( IApplicationContext, this );
		injector.mapToValue( IContextModule, this );
		
		super( injector, applicationContextName );
				
		this.initialize( null );
	}
	
	/**
	 * Override and implement
	 */
	override function _onInitialisation() : Void
	{

	}

	/**
	 * Override and implement
	 */
	override function _onRelease() : Void
	{
	}
}