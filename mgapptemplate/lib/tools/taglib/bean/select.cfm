<cfparam name="attributes.field" default="">
<cfparam name="attributes.queryname" default="">
<cfparam name="attributes.defaultname" default="Select">
<cfparam name="attributes.lookupprimarykey" default="">
<cfparam name="attributes.lookuptext" default="text">


<cfif thisTag.ExecutionMode is 'start'>
	<cfscript>
		listhelper 	= createobject("component", "%newApplicationDirectoryDotPath%.lib.tools.convert.List");
		beginning 	= rereplace(attributes.field, "\..*","");
		end 		= rereplace(attributes.field, ".*\.","");
		formbean 	= evaluate("caller.#beginning#formbean");
		value 		= evaluate("formbean.get#end#()");
		attribList	= structkeylist(attributes);
		fieldlist	= listhelper.ListDiff(attribList, "field");
		
		qlookup		= evaluate("caller.#attributes.queryname#");
	</cfscript>
	<cfoutput>
	<select name="#beginning#.#end#">
		<option value="">#attributes.defaultname#</option>
		<cfloop query="qlookup">
			<option value="#evaluate("qlookup.#attributes.lookupprimarykey#")#" <cfif value eq evaluate("qlookup.#attributes.lookupprimarykey#")>selected="selected"</cfif>>#evaluate("qlookup.#attributes.lookuptext#")#</option>
		</cfloop>
	</select>
	</cfoutput>
</cfif>