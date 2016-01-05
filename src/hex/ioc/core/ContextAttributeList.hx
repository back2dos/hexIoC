package hex.ioc.core;

import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class ContextAttributeList
{
	static public inline var ID 					: String = "id";
	static public inline var TYPE 					: String = "type";
	static public inline var NAME 					: String = "name";
	static public inline var REF 					: String = "ref";
	static public inline var VALUE 					: String = "value";
	static public inline var FACTORY 				: String = "factory";
	static public inline var SINGLETON_ACCESS 		: String = "singleton-access";
	static public inline var METHOD 				: String = "method";
	static public inline var PARSER_CLASS 			: String = "parser-class";
	static public inline var LOCATOR 				: String = "locator";
	static public inline var VISIBLE 				: String = "visible";
	public static inline var MAP_TYPE 				: String = "map-type";
	public static inline var MAP_NAME 				: String = "map-name";
	public static inline var STRATEGY 				: String = "strategy";
	public static inline var INJECTED_IN_MODULE 	: String = "injectedInModule";
	public static inline var STATIC_REF 			: String = "static-ref";
	
	private function new() 
	{
		throw new PrivateConstructorException( "'ContextAttributeList' class can't be instantiated." );
	}
}