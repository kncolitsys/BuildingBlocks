<cfcomponent displayname="Controller" extends="%newApplicationDirectoryDotPath%.lib.tools.mvc.controller" output="false">
	<cfset this.objectname 		= "%objectname%" />
	<cfset this.primarykey 		= "%primarykey%" />
	<cfset this.listbytablekey 	= "%listbytablekey%" />

	<cffunction name="lookups" access="public" returnType="void" output="false">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>

</cfcomponent>
