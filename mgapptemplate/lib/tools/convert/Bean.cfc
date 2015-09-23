<cfcomponent>
	<cfset introspect = createobject("component", "%newApplicationDirectoryDotPath%.lib.tools.introspect") />
	<cffunction name="removeNullDates" access="public" output="false" returntype="string" hint="removesNullDates">
		<cfargument name="text">
		<cfset var cleaneduptext = replace(arguments.text,"01/01/100","","ALL")/>
		<cfreturn cleaneduptext/>
	</cffunction>
	
	<cffunction name="getBlankXML" returntype="string">
		<cfreturn "<?xml version=""1.0"" encoding=""UTF-8""?><out></out>"/>
	</cffunction>

	<cffunction name="PopulateArrayOfBeansToXml" access="public" output="false" returntype="xml">
		<cfargument name="prefix" type="string" required="false" default="" />
		<cfargument name="type" type="any" required="false" hint="" />
		<cfif isdefined("arguments.type")>
			<cfset poparray = "PopulateArray(arguments.prefix,arguments.type)" /> 
		<cfelse>
			<cfset poparray = "PopulateArray(prefix=arguments.prefix)" /> 
		</cfif>
		<cfset thearray = evaluate("#poparray#") />
		<cfif arraylen(thearray) eq 0>
			<cfreturn getBlankXML()/>
		</cfif>
		<cfset thexml 	= ArrayOfBeansToXml(thearray) />
		<cfreturn thexml />
	</cffunction>

	<cffunction name="PopulateArray" access="public" output="false" returntype="any">
		<cfargument name="prefix" type="string" required="false" default="" />
		<cfargument name="type" type="any" required="false" hint="" default="%newApplicationDirectoryDotPath%.lib.tools.mvc.bean" />
		<cfset var BeanName = arguments.prefix />
		<cfset var instance = "" />
		<cfset var myarray = ArrayNew(1) />

		<!--- Loop through fieldnames and if they relate to this bean, set the values --->
		<cfif StructKeyList(form) neq "">
			<!--- for the current field we are looping on--->
			<cfloop list="#StructKeyList(form)#" index="currentfield">
				<!--- if it belongs to this bean, i.e. for "facility" is of facility.* --->
				<cfif refindnocase("^#BeanName#\[",currentfield)>
					<!--- for the current field we are looping on grab its value --->
					<cfset currentfieldvalue = form["#currentfield#"]>
					<!--- We want to take off "Facility" from "Facility.id" --->
					<cfset minusbeanname = rereplace(currentfield,"^#ucase(BeanName)#\[\d*\]\.","")>
					<cfset findindex = rereplace(currentfield,"(.*?)(\[)(\d+)(\])(.*)","\3","ALL")>
					<!--- create bean instance --->
					<cftry>
						<cfset testvalue = myarray[findindex]>
						<cfcatch>
							<cfif isSimpleValue(arguments.type)>
								<cfoutput>creating array #findindex#<br></cfoutput>
								<cfset myarray[#findindex#] = createObject("component", arguments.type) />
								<cfif structKeyExists(myarray[#findindex#], "init")>
									<cfset myarray[#findindex#].init() />
								</cfif>
							<cfelse>
								<cfset myarray[#findindex#] = arguments.type />
							</cfif>
						</cfcatch>
					</cftry>
					<!--- add in the "().get"'s i.e. make it getAddress().getId() from address.id--->
					<cfset withgets = replace(minusbeanname,".","().get","ALL")>
					<!--- Change last "get" to set i.e. getAddress().setId() --->
					
					<cfif find("get",withgets)>
						<cfset makelastgetoneset = rereplace(withgets,"(.*)(get)(.*?)$","\1set\3", "ONE")>
						<cfset evaluate("myarray[#findindex#].get#makelastgetoneset#(currentfieldvalue)")>
					<cfelse>
						<cfset makelastgetoneset = withgets>
						<cfset evaluate("myarray[#findindex#].set#makelastgetoneset#(currentfieldvalue)")>
					</cfif>
					<!--- Put it all together and evaluate i.e. facility.getAddress().setId(form.facility.address.id) --->
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn myarray />
	</cffunction>	
	
	<cffunction name="PopulateBean" access="public" output="false" returntype="any">
		<cfargument name="prefix" type="string" required="false" default="" />
		<cfargument name="type" type="any" required="false" default="%newApplicationDirectoryDotPath%.lib.tools.mvc.bean"  />
		<cfset var BeanName = arguments.prefix />
		<cfset var instance = "" />
		
		<cfif isSimpleValue(arguments.type)>
			<cfset instance = createObject("component", arguments.type) />
			<cfif structKeyExists(instance, "init")>
				<cfset instance.init() />
			</cfif>
		<cfelse>
			<cfset instance = arguments.type />
		</cfif>
		<!--- Loop through fieldnames and if they relate to this bean, set the values --->
		<cfif StructKeyList(form) neq "">
			<!--- for the current field we are looping on--->
			<cfloop list="#StructKeyList(form)#" index="currentfield">
				<!--- if it belongs to this bean, i.e. for "facility" is of facility.* --->
				<cfif refind("^#ucase(beanname)#\.",currentfield) or beanname eq "">
					<!--- for the current field we are looping on grab its value --->
					<cfset currentfieldvalue = form["#currentfield#"]>
					<!--- We want to take off "Facility" from "Facility.id" --->
					<cfset minusbeanname =rereplace(currentfield,"^#ucase(beanname)#\.","")>
					<!--- add in the "().get"'s i.e. make it getAddress().getId() from address.id--->
					<cfset withgets = replace(minusbeanname,".","().get","ALL")>
					<!--- Change last "get" to set i.e. getAddress().setId() --->
					<cfif find("get",withgets)>
						<cfset makelastgetoneset = rereplace(withgets,"(.*)(get)(.*?)$","\1set\3", "ONE")>
					<cfelse>
						<cfset makelastgetoneset = withgets>
					</cfif>
					<cfoutput>#makelastgetoneset#</cfoutput><br>
					<cfif currentfieldvalue eq "true"><cfset currentfieldvalue = true/></cfif>
					<cfif currentfieldvalue eq "false"><cfset currentfieldvalue = false/></cfif>
					<cftry>
						<cfset evaluate("instance.set#makelastgetoneset#(currentfieldvalue)")/>
						<cfcatch>
						</cfcatch>
					</cftry>
					<!--- Put it all together and evaluate i.e. facility.getAddress().setId(form.facility.address.id) --->
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn instance>
	</cffunction>
	
	<cffunction name="ArrayOfBeansToXml" returntype="string" access="public">
		<cfargument name="thearray">
		<cfargument name="outerxml" default="out">
		<cfargument name="innerxml" default="in">
		<!--- Create a new structure. --->
		<cfset aboutcfc=structNew()>
		<cfset thearray = arguments.thearray>
		<!--- Populate the structure with the metadata for the
					tellTimeObj instance of the tellTime CFC. --->
		<cfset aboutcfc=introspect.introspectMetaData(thearray[1])>
		<cfset outerxml = arguments.outerxml>
		<cfset innerxml = arguments.innerxml>
		<cfset newxml = "<?xml version=""1.0"" encoding=""UTF-8""?>">
		<cfoutput>
			<cfset newxml = newxml &  "<#outerxml#>">
			<cfloop from="1" to="#arraylen( thearray )#" index="j">
			<cfset thebean = thearray[j] />
			<cfset newxml = newxml & "<#innerxml#>">
			<cfloop from="1" to="#arraylen( aboutcfc.functions )#" index="i">
				<cfscript>
					current = aboutcfc.functions[i];
					currentfunctionname = current.name;
					currentfieldname = lcase(replace(currentfunctionname,"get",""));
				</cfscript>
				<cfif refind("^get.*",currentfunctionname)>
				<cfset newxml = newxml & "<#currentfieldname#>#evaluate("xmlformat(thebean.#currentfunctionname#())")#</#currentfieldname#>">
				</cfif>
			</cfloop>
			<cfset newxml = newxml & "</#innerxml#>">
			</cfloop>
			<cfset newxml = newxml & "</#outerxml#>">
		</cfoutput>
		<cfreturn removeNullDates(newxml)>
	</cffunction>
	
	<cffunction name="BeanToXml" returntype="string" access="public">
		<cfargument name="thebean">
		<cfargument name="outerxml">
		<cfargument name="innerxml">
		<!--- Create a new structure. --->
		<cfset aboutcfc=structNew()>
		<cfset thebean = arguments.thebean>
		<!--- Populate the structure with the metadata for the
					tellTimeObj instance of the tellTime CFC. --->
		<cfset aboutcfc=introspect.introspectMetaData(arguments.thebean)>
		<cfset outerxml = arguments.outerxml>
		<cfset innerxml = arguments.innerxml>
		<cfset newxml = "<?xml version=""1.0"" encoding=""UTF-8""?><#outerxml#>">
		<cfoutput>
			<cfset newxml = newxml & "<#innerxml#>">
			<cfloop from="1" to="#arraylen(aboutcfc.functions)#" index="i">
				<cfscript>
					current = aboutcfc.functions[i];
					currentfunctionname = current.name;
					currentfieldname = lcase(replace(currentfunctionname,"get",""));
				</cfscript>
				<cfif refind("^get.*",currentfunctionname)>
				<cfset newxml = newxml & "<#currentfieldname#>#evaluate("xmlformat(thebean.#currentfunctionname#())")#</#currentfieldname#>">
				</cfif>
			</cfloop>
			<cfset newxml = newxml & "</#innerxml#>">
			<cfset newxml = newxml & "</#outerxml#>">
		</cfoutput>
		<cfreturn removeNullDates(newxml)>
	</cffunction>
	
	<cfscript>
	
	function QueryToBean(query,bean)
	{
		var columnlist = query.columnlist;
		var column = "";
		var i = 1;
		for(i=1; i lte listlen(columnlist);i=i+1)
		{
			column = listgetat(columnlist,i);
			try
			{
				operation="bean.set#column#(query.#column#)";
				evaluate(operation);
			}
			catch(Any e)
			{
			}
		}
		return bean;
	}
	
	function XmlToBean(xmldoc,path,type)
	{
		var instance = "";
		var records = xmlSearch(xmlDoc, path);
		var i = 0;
		var j = 0;
		var columns = arrayNew(1);
		var column = "";
		var result = "";
		//var path = arguments.path;
		var tovaluepath = "[1].xmltext";
		
		if(isSimpleValue(type))
		{
			instance = createObject("component", type);
			if(structKeyExists(instance, "init"))
			{
				instance.init();
			}
		}
		else
		{
			instance = type;
		}
	
		xmlDoc = xmlparse(xmlDoc);
		columnliststring = "xmlDoc#replace(path,"/",".","ALL")#[1].xmlchildren";
		columnlistarray = evaluate(columnliststring);
		
		columnlist = "";
		for(i=1; i lte ArrayLen(columnlistarray); i=i+1)
		{
			columnlist = columnlist & iif(columnlist eq "", de(""), de(",")) & "#evaluate("#columnliststring#[i].xmlname")#";
		}
	
		if ( arraylen(records) ) 
		{
		  for ( i = 1; i lte arrayLen(records); i = i + 1 ) {
			record = records[i];
			for ( j = 1; j lte listlen(columnList); j = j + 1 ) {
			  column = listgetat(columnList,j);
			  try { 
				columnvalue=record[listgetat(columnList,j)];
				columnvalue=evaluate("columnvalue#tovaluepath#");
				operation="instance.set#column#(columnvalue)";
				evaluate(operation);
			  }
			  catch(Any e)
			  {
			  }
			}
		  }
		}
		return instance;
	}		
	</cfscript>

</cfcomponent>