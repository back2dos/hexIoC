package hex.ioc.vo;

/**
 * ...
 * @author Francis Bourre
 */
class ConstructorVO
{
	public var              ID              : String;
	public var              type            : String;
	public var              arguments       : Array<Dynamic>;
	public var              factory         : String;
	public var              singleton       : String;
	public var              injectInto      : Bool;
	public var              ref             : String;
	public var              result          : Dynamic;
	public var 				mapType			: String;
	public var 				staticRef		: String;
	public var 				isProperty		: Bool;
		
	public function new(  	id 				: String,
							?type 			: String,
							?args 			: Array<Dynamic>,
							?factory 		: String,
							?singleton 		: String,
							?injectInto 	: Bool = false,
							?ref 			: String,
							?mapType 		: String,
							?staticRef 		: String,
							?isProperty 	: Bool = false )
	{
		this.ID         = id;
		this.type       = type;
		this.arguments  = args;
		this.factory    = factory;
		this.singleton  = singleton;
		this.injectInto = injectInto;
		this.ref 		= ref;
		this.mapType 	= mapType;
		this.staticRef 	= staticRef;
		this.isProperty = isProperty;
	}

	public function toString() : String
	{
		return 	"("
				+ "id:"                 + ID            + ", "
				+ "type:"               + type          + ", "
				+ "arguments:[" 		+ arguments 	+ "], "
				+ "factory:"    		+ factory       + ", "
				+ "singleton:"  		+ singleton 	+ ", "
				+ "injectInto:"  		+ injectInto 	+ ", "
				+ "ref:"  				+ ref 			+ ", "
				+ "mapType:"  			+ mapType 		+ ", "
				+ "staticRef:"          + staticRef     + ")";
	}
}