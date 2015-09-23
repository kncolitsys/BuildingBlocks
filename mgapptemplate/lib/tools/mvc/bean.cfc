<cfcomponent name="Core Bean" output="false">
<!---

<cfcomponent output="false" extends="...">

<cfset variables.id = "">
<cfset variables.username = "">
<cfset variables.password = "">
<cfset variables.name = "">
<cfset variables.email = "">

</cfcomponent>

--->
<cffunction name="getFields" access="public" returntype="any" output="false">
	<cfreturn StructToArray(variables)>
</cffunction>

<cffunction name="getVariables" access="public" returntype="any" output="false">
	<cfreturn variables>
</cffunction>


<cffunction name="StructToArray" returntype="array" access="public" output="false">
	<cfargument name="structToConvert" type="struct">
	<cfset var newarray = "" />
	<cfset var funcstruct = "" />
	<cfset var strkey = "" />
	<cfset newarray = arraynew(1) />
	<!--- Loop over keys in the struct. --->
	<cfloop index="strKey" list="#StructKeyList( structToConvert )#" delimiters=",">
		 <cfif issimplevalue(arguments.structToConvert[strKey])>
		 	<cfset funcstruct = structNew() />
			<cfset funcstruct.name= "get#strKey#" />
			<cfset funcstruct.access = "public" />
			<cfset funcstruct.returntype = "any" />
			<cfset arrayappend(newarray,funcstruct) />
		</cfif>
	</cfloop>	
	<cfreturn newarray>				
</cffunction>

<cffunction name="onMissingMethod" access="public" returnType="any" output="false">
   <cfargument name="missingMethodName" type="string" required="true">
   <cfargument name="missingMethodArguments" type="struct" required="true">
   <cfset var key 			= structkeylist(missingMethodArguments) />
   <cfset var variablename 	= "" />
   <cfif find("get", arguments.missingMethodName) is 1>
      <cfset variablename = replaceNoCase(arguments.missingMethodName,"get","")>
      <cfif not isdefined("variables.#variablename#")>
		<cfset variables[variablename] = "" >
	  </cfif>
	  <cfreturn variables[variablename]/>
   </cfif>

   <cfif find("set", arguments.missingMethodName) is 1>
      <cfset variablename = replaceNoCase(arguments.missingMethodName,"set","")>
      <cfset variables[variablename] = arguments.missingMethodArguments[key] >
   </cfif>
</cffunction>


</cfcomponent>