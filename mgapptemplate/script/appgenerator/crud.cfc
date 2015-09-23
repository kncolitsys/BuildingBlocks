<cfcomponent>
	<cfproperty name="id"/>
	<cfproperty name="object"/>
	<cfproperty name="pk"/>
	<cfproperty name="listby"/>
	<cfproperty name="webservicepath"/>
	<cfproperty name="tablename"/>
	<cfproperty name="datasource"/>
	
	<cfset this.id 				= "" />
	<cfset this.object 			= "" />
	<cfset this.pk 				= "" />
	<cfset this.listby 			= "" />
	<cfset this.webservicepath 	= "" />
	<cfset this.tablename 		= "" />
	<cfset this.datasource 		= "" />	
	
	<cffunction name="init">
		<cfargument name="object"/>
		<cfargument name="pk"/>
		<cfargument name="listby"/>
		<cfargument name="webservicepath"/>
		<cfargument name="tablename"/>
		<cfargument name="datasource"/>
		<cfset this.object = arguments.object />
		<cfset this.pk = arguments.pk />
		<cfset this.listby = arguments.listby />
		<cfset this.webservicepath= arguments.webservicepath />
		<cfset this.tablename = arguments.tablename />
		<cfset this.datasource = arguments.datasource />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="applychanges">
		<cfscript>
			crudevents();
			crudcontroller();
			formbean();
			model();
			crudviews();
			crudajax();
		</cfscript>	
	</cffunction>
	
	<cffunction name="changestoapply">
		<!-- ajax -->
		<cfif not fileexists( expandpath('../../content/js/#this.object#.js') )>
			<cfreturn "content/js/#this.object#.js" />
		</cfif>
		<!-- views -->
		<cfif not directoryexists( expandpath('../../views/#this.object#') )>
			<cfreturn "view dir" />
		</cfif>
		<cfif not fileexists( expandpath('../../views/#this.object#/lst#this.object#.cfm') )>
			<cfreturn "list view" />
		</cfif>
		<cfif not fileexists( expandpath('../../views/#this.object#/frm#this.object#.cfm') )>
			<cfreturn "form view" />
		</cfif>
		<!-- model -->
		<cffile action="read" file="#expandpath('../../config/Coldspring.xml')#" variable="mgfilecontents"/>
		<cfif not find("bean id=""#this.object#""",mgfilecontents)>
			<cfreturn "model" />
		</cfif>
		<!-- formbean -->
		<cfif not find("bean id=""#this.object#formbean""",mgfilecontents)>
			<cfreturn "formbean" />
		</cfif>
		<!-- controller -->
		<cfif not fileexists( expandpath('../../controller/#this.object#.cfc') )>
			<cfreturn "controller" />
		</cfif>
		<!-- mg includes -->
		<cffile action="read" file="#expandpath('../../config/ModelGlue.xml')#" variable="mgfilecontents"/>
		<cfif not find("ModelGlue_#this.object#.xml",mgfilecontents)>
			<cfreturn "mg include"/>
		</cfif>
		<!--mg  -->
		<cfif not fileexists( expandpath('../../config/ModelGlue_#this.object#.xml') )>
			<cfreturn "ModelGlue_#this.object#.xml"/>
		</cfif>
		<cfreturn "" />
	</cffunction>

	
	<cffunction name="crudajax">
		<cfif not fileexists( expandpath('../../content/js/#this.object#.js') )>
			<cffile action="copy" source="#expandpath('../templates/webservice/ajax.js')#" destination="#expandpath('../../content/js/#this.object#.js')#" />
			<cfset replacetokensinfile( expandpath('../../content/js/#this.object#.js') )/>
		</cfif>
	</cffunction>

	<cffunction name="crudviews">
		<cfif not directoryexists( expandpath('../../views/#this.object#') )>
			<cfdirectory action="create" directory="#expandpath('../../views/#this.object#')#"/>
		</cfif>
		<cfset pk = this.pk />
		<cfquery name="qcolumns" datasource="#this.datasource#" maxrows="1">
			SELECT *
			FROM #this.tablename#
		</cfquery>
		<cfif not fileexists( expandpath('../../views/#this.object#/lst#this.object#.cfm') )>
			<cfsavecontent variable="listview"><cfinclude template="../templates/webservice/listview.cfm"/></cfsavecontent>
			<cffile action="write" file="#expandpath('../../views/#this.object#/lst#this.object#.cfm')#" output="#replacetokensinstring(listview)#"/>
		</cfif>
		<cfif not fileexists( expandpath('../../views/#this.object#/frm#this.object#.cfm') )>
			<cfsavecontent variable="formview"><cfinclude template="../templates/webservice/formview.cfm"/></cfsavecontent>
			<cffile action="write" file="#expandpath('../../views/#this.object#/frm#this.object#.cfm')#" output="#replacetokensinstring(formview)#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="model">
		<cffile action="read" file="#expandpath('../../config/Coldspring.xml')#" variable="mgfilecontents"/>
		<cfif not find("bean id=""#this.object#""",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml"><!-- model -->
	<bean id="%objectname%" class="%newApplicationDirectoryDotPath%.lib.tools.mvc.modelProxy">
		<property name="cfcpath">
		   <value>%webservicepath%</value>
		</property>
	</bean></cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "<!-- model -->", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../config/Coldspring.xml')#" output="#replacetokensinstring(mgfilecontents)#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="formbean">
		<cffile action="read" file="#expandpath('../../config/Coldspring.xml')#" variable="mgfilecontents"/>
		<cfif not find("bean id=""#this.object#formbean""",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml"><!-- Form Beans -->
	<bean id="%objectname%formbean"				class="%newApplicationDirectoryDotPath%.lib.tools.mvc.bean" 		singleton="false"/></cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "<!-- Form Beans -->", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../config/Coldspring.xml')#" output="#replacetokensinstring(mgfilecontents)#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="crudcontroller">
		<cfif not fileexists( expandpath('../../controller/#this.object#.cfc') )>
			<cffile action="copy" source="#expandpath('../templates/webservice/controller.cfc')#" destination="#expandpath('../../controller/#this.object#.cfc')#" />
			<cfset replacetokensinfile( expandpath('../../controller/#this.object#.cfc') )/>
		</cfif>
	</cffunction>
	
	<cffunction name="checkmginclude">
		<cffile action="read" file="#expandpath('../../config/ModelGlue.xml')#" variable="mgfilecontents"/>
		<cfif not find("ModelGlue_#this.object#.xml",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml"><modelglue>
	<include template="config/ModelGlue_%objectname%.xml"/></cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "<modelglue>", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../config/ModelGlue.xml')#" output="#replacetokensinstring(mgfilecontents)#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="crudevents">
		<cfset checkmginclude() />
		<cfif not fileexists( expandpath('../../config/ModelGlue_#this.object#.xml') )>
			<cffile action="copy" source="#expandpath('../templates/webservice/ModelGlue.xml')#" destination="#expandpath('../../config/ModelGlue_#this.object#.xml')#" />
			<cfset replacetokensinfile( expandpath('../../config/ModelGlue_#this.object#.xml') )/>
		</cfif>
	</cffunction>
	
	<cffunction name="replacetokensinfile">
		<cfargument name="file"/>
		<cffile action="read" file="#arguments.file#" variable="filecontents"/>
		<cfset filecontents = replace(filecontents, "%objectname%", "#this.object#", "ALL") />
		<cfset filecontents = replace(filecontents, "&lt;", "<", "ALL") />
		<cfset filecontents = replace(filecontents, "&gt;", ">", "ALL") />
		<cfset filecontents = replace(filecontents, "%primarykey%", "#this.pk#", "ALL") />
		<cfset filecontents = replace(filecontents, "%listbytablekey%", "#this.listby#", "ALL") />
		<cfset filecontents = replace(filecontents, "%webservicepath%", "#this.webservicepath#", "ALL") />
		<cfset filecontents = replace(filecontents, "&quot;", """", "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".script.appgenerator","","ALL") >
		<cfset filecontents = replace(filecontents, "%newApplicationDirectoryDotPath%", scriptname, "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".", "/", "ALL")>
		<cfset filecontents = replace(filecontents, "%appfolder%", scriptname, "ALL") />		
		<cffile action="write" file="#arguments.file#" output="#filecontents#"/>
	</cffunction>
	
	
	
	<cffunction name="replacetokensinstring">
		<cfargument name="text"/>
		<cfset arguments.text = replace(arguments.text, "%objectname%", "#this.object#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "&lt;", "<", "ALL") />
		<cfset arguments.text = replace(arguments.text, "&gt;", ">", "ALL") />
		<cfset arguments.text = replace(arguments.text, "%primarykey%", "#this.pk#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "%listbytablekey%", "#this.listby#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "%webservicepath%", "#this.webservicepath#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "&quot;", """", "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".script.appgenerator","","ALL") >
		<cfset arguments.text = replace(arguments.text, "%newApplicationDirectoryDotPath%", scriptname, "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".", "/", "ALL")>
		<cfset arguments.text = replace(arguments.text, "%appfolder%", scriptname, "ALL") />		
		<cfreturn arguments.text />
	</cffunction>
	
</cfcomponent>