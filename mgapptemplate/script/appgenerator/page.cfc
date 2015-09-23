<cfcomponent>
	<cfproperty name="id"/>
	<cfproperty name="object"/>
	<cfproperty name="event"/>
	
	<cfset this.object 			= "" />
	<cfset this.event			= "" />
	
	<cffunction name="init" returntype="any">
		<cfargument name="object"/>
		<cfargument name="event"/>
		<cfset this.object 	= arguments.object />
		<cfset this.event	= arguments.event />
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="changestoapply">
		<!-- mg%object%.xml -->
		<cfif not fileexists( expandpath('../../config/ModelGlue_#this.object#.xml') )>
			<cfreturn "ModelGlue_#this.object#.xml" />
		</cfif>
		<cffile action="read" file="#expandpath('../../config/ModelGlue_#this.object#.xml')#" variable="mgfilecontents"/>
		<cfif not find("message=""#this.event#""",mgfilecontents) or not find("event-handler name=""#this.event#""",mgfilecontents)>
			<cfreturn "ModelGlue_#this.object#.xml" />	
		</cfif>
		<!-- mg.xml -->
		<cffile action="read" file="#expandpath('../../config/ModelGlue.xml')#" variable="mgfilecontents"/>
		<cfif not find("ModelGlue_#this.object#.xml",mgfilecontents)>
			<cfreturn "ModelGlue.xml" />
		</cfif>
		<!-- controller -->
		<cfif not fileexists( expandpath('../../controller/#this.object#.cfc') )>
			<cfreturn "#this.object#.cfc" />
		</cfif>
		<cffile action="read" file="#expandpath('../../controller/#this.object#.cfc')#" variable="mgfilecontents"/>
		<cfif not find("name=""#this.event#""",mgfilecontents)>
			<cfreturn "#this.object#.cfc" />
		</cfif>
		<!-- view -->
		<cfif not directoryexists( expandpath('../../views/#this.object#') )>
			<cfreturn "view" />
		</cfif>
		<cfif not fileexists( expandpath('../../views/#this.object#/dsp#this.event#.cfm') )>
			<cfreturn "view" />
		</cfif>
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="applychanges">
		<cfscript>
			applymgevent();
			applycontrollerfunction();
			applyview();
		</cfscript>
	</cffunction>
	
	<cffunction name="addlistener">
		<cffile action="read" file="#expandpath('../../config/ModelGlue_#this.object#.xml')#" variable="mgfilecontents"/>
		<cfif not find("message=""#this.event#""",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml">			<message-listener message="%eventname%" function="%eventname%" />
		</controller></cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "</controller>", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../config/ModelGlue_#this.object#.xml')#" output="#replacetokensinstring(mgfilecontents)#"/>
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
		
	<cffunction name="checkmgeventfile">
		<cfif not fileexists( expandpath('../../config/ModelGlue_#this.object#.xml') )>
			<cffile action="copy" source="#expandpath('../templates/webservice/BlankModelGlue.xml')#" destination="#expandpath('../../config/ModelGlue_#this.object#.xml')#" />
			<cfset replacetokensinfile( expandpath('../../config/ModelGlue_#this.object#.xml') )/>
		</cfif>
	</cffunction>
	
	<cffunction name="applymgevent">
		<cfset checkmgeventfile() />
		<cfset checkmginclude() />
		<cfset addlistener() />
		<cffile action="read" file="#expandpath('../../config/ModelGlue_#this.object#.xml')#" variable="mgfilecontents"/>
		<cfif not find("event-handler name=""#this.event#""",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml"><event-handlers>
			<event-handler name="%eventname%">
				<broadcasts>
					<message name="%eventname%" />
				</broadcasts>
				<views>
					<include name="body" template="%objectname%/dsp%eventname%.cfm" />
				</views>
				<results>
					<result do="view.template"/> 
				</results>
			</event-handler></cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "<event-handlers>", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../config/ModelGlue_#this.object#.xml')#" output="#replacetokensinstring(mgfilecontents)#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="applycontrollerfunction">
		<cfif not fileexists( expandpath('../../controller/#this.object#.cfc') )>
			<cffile action="copy" source="#expandpath('../templates/webservice/blankcontroller.cfc')#" destination="#expandpath('../../controller/#this.object#.cfc')#" />
			<cfset replacetokensinfile( expandpath('../../controller/#this.object#.cfc') )/>
		</cfif>
		<cffile action="read" file="#expandpath('../../controller/#this.object#.cfc')#" variable="mgfilecontents"/>
		<cfif not find("name=""#this.event#""",mgfilecontents)>
			<cfsavecontent variable="eventhandlerxml">	&lt;cffunction name="%eventname%" access="public" returntype="any"&gt;
		&lt;cfargument name="event" type="any"&gt;
	&lt;/cffunction&gt;
&lt;/cfcomponent&gt;</cfsavecontent>
			<cfset mgfilecontents = replace(mgfilecontents, "</cfcomponent>", eventhandlerxml) />
			<cffile action="write" file="#expandpath('../../controller/#this.object#.cfc')#" output="#replacetokensinstring(mgfilecontents)#"/>
		</cfif>
	</cffunction>
	
	
	<cffunction name="applyview">
		<cfif not directoryexists( expandpath('../../views/#this.object#') )>
			<cfdirectory action="create" directory="#expandpath('../../views/#this.object#')#"/>
		</cfif>
		<cfif not fileexists( expandpath('../../views/#this.object#/dsp#this.event#.cfm') )>
			<cfoutput>
			<cfsavecontent variable="viewcontent">This is the #this.object# view in views/#this.object#/dsp#this.event#.cfm</cfsavecontent>
			</cfoutput>
			<cffile action="write" file="#expandpath('../../views/#this.object#/dsp#this.event#.cfm')#" output="#replacetokensinstring(viewcontent)#"/>
		</cfif>
	</cffunction>	
	
	<cffunction name="replacetokensinfile">
		<cfargument name="file"/>
		<cffile action="read" file="#arguments.file#" variable="filecontents"/>
		<cfset filecontents = replace(filecontents, "%objectname%", "#this.object#", "ALL") />
		<cfset filecontents = replace(filecontents, "%eventname%", "#this.event#", "ALL") />
		<cfset filecontents = replace(filecontents, "&lt;", "<", "ALL") />
		<cfset filecontents = replace(filecontents, "&gt;", ">", "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".script.appgenerator","","ALL") >		
		<cfset filecontents = replace(filecontents, "%newApplicationDirectoryDotPath%", scriptname, "ALL") />
		<cffile action="write" file="#arguments.file#" output="#filecontents#"/>
	</cffunction>

	<cffunction name="replacetokensinstring">
		<cfargument name="text"/>
		<cfset arguments.text = replace(arguments.text, "%objectname%", "#this.object#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "%eventname%", "#this.event#", "ALL") />
		<cfset arguments.text = replace(arguments.text, "&lt;", "<", "ALL") />
		<cfset arguments.text = replace(arguments.text, "&gt;", ">", "ALL") />
		<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
		<cfset scriptname = mid(scriptname,2, len(scriptname))/>
		<cfset scriptname = mid(scriptname, 1, len(scriptname)-1) />
		<cfset scriptname = replace(scriptname, ".script.appgenerator","","ALL") >		
		<cfset arguments.text = replace(arguments.text, "%newApplicationDirectoryDotPath%", scriptname, "ALL") />
		<cfreturn arguments.text />
	</cffunction>
		
</cfcomponent>