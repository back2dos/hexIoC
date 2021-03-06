package hex.ioc.parser.xml;

import hex.compiletime.xml.XmlUtil;
import hex.factory.BuildRequest;
import hex.ioc.core.ContextAttributeList;
import hex.ioc.core.ContextNodeNameList;
import hex.ioc.vo.CommandMappingVO;
import hex.ioc.vo.StateTransitionVO;
import hex.ioc.vo.TransitionVO;
import hex.runtime.error.ParsingException;
import hex.runtime.xml.AbstractXMLParser;

/**
 * ...
 * @author Francis Bourre
 */
class StateXMLParser extends AbstractXMLParser<BuildRequest>
{
	public function new() 
	{
		super();
	}
	
	override public function parse() : Void
	{
		var iterator = this._contextData.firstElement().elementsNamed( ContextNodeNameList.STATE );
		while ( iterator.hasNext() )
		{
			var node = iterator.next();
			this._parseNode( node );
			this._contextData.firstElement().removeChild( node );
		}
	}
	
	function _parseNode( xml : Xml ) : Void
	{
		var identifier : String = XMLAttributeUtil.getID( xml );
		if ( identifier == null )
		{
			throw new ParsingException( this + " encounters parsing error with '" + xml.nodeName + "' node. You must set an id attribute." );
		}
		
		var staticReference 		= XMLAttributeUtil.getStaticRef( xml );
		var instanceReference 		= XMLAttributeUtil.getRef( xml );
		var enterList 				= this._buildList( xml, ContextNodeNameList.ENTER );
		var exitList 				= this._buildList( xml, ContextNodeNameList.EXIT );
		var transitionList 			= this._getTransitionList( xml, ContextNodeNameList.TRANSITION );
		
		var stateTransitionVO 		= new StateTransitionVO( identifier, staticReference, instanceReference, enterList, exitList, transitionList );
		stateTransitionVO.ifList 	= XmlUtil.getIfList( xml );
		stateTransitionVO.ifNotList = XmlUtil.getIfNotList( xml );
		
		this._builder.build( STATE_TRANSITION( stateTransitionVO ) );
	}
	
	function _buildList( xml : Xml, nodeName : String ) : Array<CommandMappingVO>
	{
		var it = xml.elementsNamed( nodeName );
		var list : Array<CommandMappingVO> = [];
		
		while( it.hasNext() )
		{
			var item = it.next();
			list.push( { 
							commandClassName: XMLAttributeUtil.getCommandClass( item ), 
							fireOnce: XMLAttributeUtil.getFireOnce( item ), 
							contextOwner: XMLAttributeUtil.getContextOwner( item ),
							methodRef: XMLAttributeUtil.getMethod( item )
						} );
		}
		
		return list;
	}
	
	function _getTransitionList( xml : Xml, nodeName : String ) : Array<TransitionVO>
	{
		var iterator = xml.elementsNamed( nodeName );
		var list : Array<TransitionVO> = [];
		while( iterator.hasNext() )
		{
			var transition = iterator.next();
			var message = transition.elementsNamed( ContextNodeNameList.MESSAGE ).next();
			var state = transition.elementsNamed( ContextNodeNameList.STATE ).next();
			
			var vo = new TransitionVO();
			vo.messageReference = message.get( ContextAttributeList.REF ) != null ?
													message.get( ContextAttributeList.REF ):
														message.get( ContextAttributeList.STATIC_REF );
														
			vo.stateReference = state.get( ContextAttributeList.REF ) != null ?
													state.get( ContextAttributeList.REF ):
														state.get( ContextAttributeList.STATIC_REF );
			list.push( vo );
		}
		
		return list;
	}
}