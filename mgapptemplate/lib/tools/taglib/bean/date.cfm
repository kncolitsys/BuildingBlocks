<cfparam name="attributes.field" default="">
<cfparam name="attributes.format" default="mm/dd/yyyy">

<cfif thisTag.ExecutionMode is 'start'>
	<cfscript>
		listhelper 	= createobject("component", "%newApplicationDirectoryDotPath%.lib.tools.convert.List");
		beginning 	= rereplace(attributes.field, "\..*","");
		end 		= rereplace(attributes.field, ".*\.","");
		formbean 	= evaluate("caller.#beginning#formbean");
		value 		= evaluate("formbean.get#end#()");
		attribList	= structkeylist(attributes);
		fieldlist	= listhelper.ListDiff(attribList, "field");
	</cfscript>
	<cfoutput>
	<input type="text" name="#beginning#.#end#" id="#beginning#.#end#" value="#dateformat(value, attributes.format)#">
	&nbsp;<img src="content/images/calendar.png" width="20" onclick="window_open('#beginning#.#end#')" value="..." align="absmiddle">
	</cfoutput>
</cfif>