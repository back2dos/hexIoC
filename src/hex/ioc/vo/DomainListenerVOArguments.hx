package hex.ioc.vo;

/**
 * ...
 * @author Francis Bourre
 */
class DomainListenerVOArguments
{
	public var name 			: String;
	public var staticRef 		: String;
	public var method 			: String;
	public var strategy 		: String;
	public var injectedInModule : Bool = false;

	public function new( ?name : String, ?staticRef : String, ?method : String, ?strategy : String, ?injectedInModule : Bool = false )
	{
		this.name 				= name;
		this.staticRef 			= staticRef;
		this.method 			= method;
		this.strategy 			= strategy;
		this.injectedInModule 	= injectedInModule;
	}
}