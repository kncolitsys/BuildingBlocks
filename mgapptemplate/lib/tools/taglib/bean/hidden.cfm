<cfparam name="attributes.field" default="">

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
	<input type="hidden" name="#beginning#.#end#" id="#beginning#.#end#" value="#value#" <cfloop list="#fieldlist#" index="onefield">#onefield#="#evaluate("attributes.#onefield#")#" </cfloop> />
	</cfoutput>
</cfif>