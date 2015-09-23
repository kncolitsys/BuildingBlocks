<cfparam name="attributes.field" default="">
<cfparam name="attributes.queryname" default="">
<cfparam name="attributes.defaultname" default="Select">
<cfparam name="attributes.lookupprimarykey" default="">
<cfparam name="attributes.lookuptext" default="text">
<cfparam name="attributes.selectedvalues" default="">


<cfif thisTag.ExecutionMode is 'start'>
	<cfscript>
		listhelper 	= createobject("component", "%newApplicationDirectoryDotPath%.lib.tools.convert.List");
		beginning 	= rereplace(attributes.field, "\..*","");
		end 		= rereplace(attributes.field, ".*\.","");
		attribList	= structkeylist(attributes);
		fieldlist	= listhelper.ListDiff(attribList, "field");
		
		qlookup		= evaluate("caller.#attributes.queryname#");
	</cfscript>
	<cfoutput>
		<cfloop query="qlookup">
			<input type="checkbox" name="#beginning#.#end#" <cfif listfind(attributes.selectedvalues, evaluate("qlookup.#attributes.lookupprimarykey#"))>checked="checked"</cfif> value="#evaluate("qlookup.#attributes.lookupprimarykey#")#">
			#evaluate("qlookup.#attributes.lookuptext#")# <br>
		</cfloop>
	</cfoutput>
</cfif>