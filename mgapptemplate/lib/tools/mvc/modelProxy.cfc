<cfcomponent>
	<cfset this.xmlhelper 		= createObject("component", "%newApplicationDirectoryDotPath%.lib.tools.convert.Xml") />
	<cfset this.cfcpath 		= "" />
	<cfset this.remoteobject	= 0 />
	<cfset this.outerxmlwrapper	= "out" />
	<cfset this.innerxmlwrapper	= "in" />
	<cffunction name="getCfcPath">
		<cfreturn this.cfcpath/>
	</cffunction>
	<cffunction name="setCfcPath">
		<cfargument name="cfcpath">
		<cfset this.cfcpath = arguments.cfcpath />
	</cffunction>
	<cffunction name="getOuterxmlwrapper">
		<cfreturn this.outerxmlwrapper/>
	</cffunction>
	<cffunction name="setOuterxmlwrapper">
		<cfargument name="outerxmlwrapper">
		<cfset this.outerxmlwrapper = arguments.outerxmlwrapper />
	</cffunction>
	<cffunction name="getinnerxmlwrapper">
		<cfreturn this.innerxmlwrapper/>
	</cffunction>
	<cffunction name="setinnerxmlwrapper">
		<cfargument name="innerxmlwrapper">
		<cfset this.innerxmlwrapper = arguments.innerxmlwrapper />
	</cffunction>	
	<cffunction	name="OnMissingMethod" access="public" returntype="any"	output="false" hint="Handles missing method exceptions.">
		<!--- Define arguments. --->
		<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method."/>
		<cfargument	name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />
		<cfset var argumentstruct 	= 0 />
		<cfset var funcname			= 0 />
		<cfset var paramlist 		= 0 />		
		<cfset var keylist 			= 0 />		
		<cfset var strKey 			= 0 />		
		<cfset var result			= 0 />		
		<cfset var noxmlheader		= 0 />		
		<cfset var oxw				= 0 />		
		<cfset var ixw				= 0 />		
		<!--- loop through arguments and convert beans to xml --->
		<cfif not isobject(this.remoteobject)>
			<cfset this.remoteobject = createobject("component", this.cfcpath) />
		</cfif>
		<cfset argumentstruct = arguments.MissingMethodArguments />
		<cfloop index="strKey" list="#StructKeyList( arguments.MissingMethodArguments )#" delimiters=",">
			<cfif isobject(arguments.MissingMethodArguments[strKey])>
				<cfset arguments.MissingMethodArguments[strKey] = this.xmlhelper.BeanToXML(arguments.MissingMethodArguments[strKey],"#this.outerxmlwrapper#","#this.innerxmlwrapper#")>
			</cfif>
		</cfloop>
		
		<cfset funcname = arguments.MissingMethodName />
		<cfset paramlist = "" />
		<cfset keylist = listsort(StructKeyList( arguments.MissingMethodArguments ), "text") />
		<cfloop index="strKey" list="#keylist#" delimiters=",">
			<cfif isnumeric(strKey)>
				<cfset paramlist = listappend(paramlist, "argumentstruct['#strKey#']") />
			<cfelse>
				<cfset paramlist = listappend(paramlist, "#strKey#=argumentstruct['#strKey#']") />
			</cfif>
		</cfloop>
		<cfset result = evaluate("this.remoteobject.#funcname#(#paramlist#)") />

		<cfif not isdefined("result")>
			<cfreturn />
		</cfif>
		<!--- if the returned result is xml, then convert it to a query --->
		<cfif isSimpleValue(result) and isXml(result)>
			<cfset noxmlheader 				= rereplace(result,"(<\?xml.*?\?>.*?)(<.*)", "\2")/>
			<cfset oxw 						= rereplace(noxmlheader,"(<)(\w*)([\ ])(.*?>)(.*)", "\2") />
			<cfif not find("<", oxw) and not find(" ", oxw)>
				<cfset this.outerxmlwrapper	= oxw />
			</cfif>
			<cfset ixw					 	= rereplace(noxmlheader,"(<.*?>)(<)(\w*)(>)(.*)", "\3") />
			<cfif not find("<", ixw) and not find(" ", ixw)>
				<cfset this.innerxmlwrapper = ixw />
			</cfif>
			<cfset result 					= this.xmlhelper.xmlToQuery(result, "/#this.outerxmlwrapper#/#this.innerxmlwrapper#") />
		</cfif>
		<!--- Return out. --->
		<cfreturn result/>
	</cffunction>
</cfcomponent>
