<cfcomponent 	displayname="Controller" 
				extends="ModelGlue.unity.controller.Controller" 
				output="false" 
				hint="<h1>Controller Base Class</h1>
				This is the <strong>Controller base class </strong>designed to automate 90% of the controller functions.  The other 10% is handled through functions that provide hooks into the process.  <br>
				There is a <strong>Add, Delete, Edit, List, and Save </strong>functions that are automated for you.  
				<h2>The Hooks</h2>
				For each one of those there are 'before' functions and 'after' functions that you can overide the blank stub functions to actually do something.<br>
				For example <strong>afterAdd</strong>, <strong>afterList </strong>and <strong>beforeAdd, beforeList</strong>.<br><br>
				There are also two other functions that are called in more then one function:<br>
				<strong>beforeListRedirect</strong> is called right before the redirect to the list function after a save or delete.  This is a good place to set a variable in the event to list by.<br>
				<strong>lookups</strong> is called during add/edit/list functions.  Put all lookups needed (say for dropdowns) in this function.
				<h2>Conventions assumed</h2>
				<strong>this.objectname</strong>: the name of the model bean from coldspring.<br>
				<strong>this.primarykey</strong>: the name of the primary key for the model.	<br>			
				<strong>this.listbytablekey</strong>: the name of the field in the model to list by/group by, i.e. for facilityname it is facility_id.	<br>			
				<strong>this.listbyurlkey</strong>: the name of the variable that is passed in the url/post to list by/group by.  Defaults to <strong>this.listbytablekey	</strong><br>			
				<strong>this.useredirect</strong>: true/false, whether to use cflocation(redirect) to go to the list function after save OR to just change events in MG.  The difference is the page will show the list but the URL will still say `saveFacility` if it isn't a redirect.
				">
	<cfproperty name="objectname" type="string" required="yes" default="" hint="the name of the model bean from coldspring." />
	<cfproperty name="primarykey" type="string" required="no" default="id" hint="the name of the primary key for the model." />
	<cfproperty name="listbytablekey" type="string" required="no" default="" hint="the name of the field in the model to list by/group by, i.e. for facilityname it is facility_id." />
	<cfproperty name="listbyurlkey" type="string" required="no" default="" hint="the name of the variable that is passed in the url/post to list by/group by.  Defaults to <strong>this.listbytablekey	</strong>" />
	<cfproperty name="useredirect" type="string" required="no" default="true" hint="true/false, whether to use cflocation(redirect) to go to the list function after save OR to just change events in MG.  The difference is the page will show the list but the URL will still say `saveFacility` if it isn't a redirect." />

	<cfset this.objectname 		= "" />
	<cfset this.primarykey 		= "id" />
	<cfset this.listbytablekey 	= "" />
	<cfset this.listbyurlkey 	= "" />
	<cfset this.useredirect 	= true />
	
	<cffunction name="getListByUrlKey" access="private" returnType="string" output="false" hint="An internal function to get which column to list by, i.e. facility_id">
	  	<cfargument name="event" type="any">
		<cfif this.listbyurlkey neq "">
			<cfreturn this.listbyurlkey />
		<cfelseif this.listbyurlkey eq "" and this.listbytablekey neq "">		
			<cfreturn this.listbytablekey />
		<cfelse>
			<cfreturn "" />
		</cfif>
		<cfreturn />
	</cffunction>	
	
	<cffunction name="showRequirements" access="private" returnType="void" output="true" hint="An internal helper function to show the base requirements to define a controller.">
		<cfoutput>
			<br>
			&lt;cfcomponent displayname="Controller" extends="..." output="false"&gt;<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.objectname 		= "insurance" /&gt;<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.primarykey 		= "id" /&gt;<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.listbytablekey 		= "facility_fk" /&gt;<br>
			<br>
			<br>
		</cfoutput>		
		<cfreturn />
	</cffunction>		
	
	
	<cffunction name="checkRequirements" access="private" returnType="void" output="false" hint="An internal helper function to check the base requirements to define a controller.">
	  	<cfargument name="event" type="any">
		<cfoutput>
		<cfif this.objectname eq "">
			Object name is required but not found.  Please refer to this example:
			<br>
			<br>
			#showRequirements()#
			<cfabort>
		<cfelseif this.primarykey eq "">
			Primary Key is required but not found.  Please refer to this example:
			<br>
			<br>
			#showRequirements()#
			<cfabort>	
		</cfif>
		</cfoutput>
		<cfreturn />
	</cffunction>		
	
	<cffunction name="lookups" access="public" returnType="void" output="false" hint="I'm the stub that is called during add/edit/list functions.  Put all calls to lookups in me.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>	
	
	<cffunction name="beforeAdd" access="public" returnType="void" output="false" hint="I'm the stub to be called before the add function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="add" access="public" returnType="void" output="false" hint="I'm the add function.  I call the lookups function, grab a formbean, set the list by key, and pass it to the view.">
	  	<cfargument name="event" type="any">
		<cfset var formbean = "" />
		<cfset checkRequirements() />
		<cfscript>
		 	beforeAdd(event);
			lookups(event);
			// Create form bean to pass to the page
			formbean = getModelGlue().getBean("#this.objectname#formbean");
			// if adding new and need to reference the parent
			if( arguments.event.getValue( getListByUrlKey() ) neq "")
			{
				evaluate("formbean.set#getListByUrlKey()#( arguments.event.getValue( getListByUrlKey() ) )");
			}
			evaluate("formbean.set#this.primarykey#(0)");
			arguments.event.setValue( "#this.objectname#formbean" , formbean );
			afterAdd(event);
		</cfscript>
		<cfreturn />
	</cffunction>
	<cffunction name="afterAdd" access="public" returnType="void" output="false" hint="I'm a stub to be called after the add function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	
	<cffunction name="beforeDelete" access="public" returnType="void" output="false" hint="I'm a stub to be called before the delete function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="delete" access="public" returnType="void" output="false" hint="I'm the delete function that deletes the specified row, and redirects to list.">
	  	<cfargument name="event" type="any">
		<cfset var xmlhelper = "" />
		<cfset var beanhelper = "" />
		<cfset var qonerow = "" />
		<cfset var formbean = "" />
		<cfset checkRequirements() />
		<cfscript>
			// bean helper file 
			xmlhelper 	= getModelGlue().getBean("xmlhelper");
			beanhelper 	= getModelGlue().getBean("beanhelper");
			// populate form bean 
			qonerow 		= getModelGlue().getBean( this.objectname ).get( arguments.event.getValue(this.primarykey) );
			formbean 		= xmlhelper.QueryToBean(qonerow, getModelGlue().getBean("#this.objectname#formbean"));
			arguments.event.setValue( "#this.objectname#formbean" , formbean );
			beforeDelete(event);
			getModelGlue().getBean( this.objectname ).delete ( evaluate("url.#this.primarykey#") );
			arguments.event.addResult("redirect");
			if(getListByUrlKey() neq "")
				arguments.event.setValue( "#getListByUrlKey()#" , evaluate("qonerow.#this.listbytablekey#") );
			afterDelete(event);
			beforeListRedirect(event);			
		</cfscript>
		<cfif this.useredirect>
			<cflocation url="index.cfm?event=list#this.objectname#s&#getListByUrlKey()#=#evaluate("qonerow.#this.listbytablekey#")#"/>
		</cfif>
	</cffunction>
	<cffunction name="afterDelete" access="public" returnType="void" output="false" hint="I'm the stub to be called after the delete function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
		
	<cffunction name="beforeEdit" access="public" returnType="void" output="false" hint="I'm the stub to be called before the edit function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="edit" access="public" returnType="void" output="false" hint="I'm the edit function that grabs the lookups, grabs the formbean, populates it and sends it to the view.">
	  	<cfargument name="event" type="any">
		<cfset var beanhelper 	= "" />
		<cfset var xmlhelper = "" />
		<cfset var formbean = "" />
		<cfset var qonerow = "" />
		<cfset checkRequirements() />
		<cfscript>
			xmlhelper 	= getModelGlue().getBean("xmlhelper");
			beanhelper 	= getModelGlue().getBean("beanhelper");
			beforeEdit(event);
			lookups(event);
			// Create form bean to pass to the page
			formbean 		= getModelGlue().getBean("#this.objectname#formbean");
			qonerow 		= getModelGlue().getBean( this.objectname ).get( arguments.event.getValue(this.primarykey) );
			formbean 		= xmlhelper.QueryToBean(qonerow, formbean);
			// if adding new and need to reference the parent
			if( arguments.event.getValue( getListByUrlKey() ) neq "")
			{
				evaluate("formbean.set#getListByUrlKey()#( arguments.event.getValue( getListByUrlKey() ) )");
			}
			arguments.event.setValue( "#this.objectname#formbean" , formbean );
			afterEdit(event);
		</cfscript>
		<cfreturn />
	</cffunction>
	<cffunction name="afterEdit" access="public" returnType="void" output="false" hint="I'm the stub to be called after the edit function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
		
	<cffunction name="beforeList" access="public" returnType="void" output="false" hint="I'm the stub to be called after the list function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="beforeListRedirect" access="public" returnType="void" output="false" hint="I'm the stub to be called before redirecting to the list.  I'm called right after afterDelete and afterSave.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="list" access="public" returnType="void" output="false" hint="I'm the list function that calls the lookups, and gets the query for all model objects listed by the property named up top.">
	  	<cfargument name="event" type="any">
		<cfset checkRequirements() />
		<cfif getListByUrlKey() neq "">
			<cfif arguments.event.getValue(getListByUrlKey()) eq "">
				<cfoutput>
					The controller specifies #getListByUrlKey()# to be in the url for the list event but it was not found.<br>
					Please make sure listbytablekey and listbyurlkey are set in the controller as so:<br>
					<br>
					&lt;cfcomponent displayname="Controller" extends="...." output="false"&gt;<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.objectname 		= "insurance" /&gt;<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.primarykey 		= "id" /&gt;<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.listbytablekey 		= "facility_fk" /&gt;<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&lt;cfset this.listbyurlkey 	= "facility_pk" /&gt;<br>
					<br>
					<br>
					where listbytablekey is the field you would list by and listbyurlkey is how the value is passed in via the url.<br>
					The url for reference: <cfdump var="#url#"/>
				</cfoutput>
				<cfabort>
			</cfif>
		</cfif>	
		<cfscript>
			lookups(event);
			beforeList(event);
			if(getListByUrlKey() neq "")
				arguments.event.setValue( "q#this.objectname#s" , getModelGlue().getBean( this.objectname ).listByProperty( this.listbytablekey, arguments.event.getValue( getListByUrlKey() ) ));
			else
				arguments.event.setValue( "q#this.objectname#s" , getModelGlue().getBean( this.objectname ).listAll() );
			afterList(event);
		</cfscript>
	</cffunction>
	<cffunction name="afterList" access="public" returnType="void" output="false" hint="I'm the stub to be called after the list function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>

	<cffunction name="beforeSave" access="public" returnType="void" output="false" hint="I'm the stub to be called before the save function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	<cffunction name="save" access="public" returnType="void" output="false" hint="I'm the save function that populates a formbean from the form submittal, passes it to the model, and then redirects to the list function. ">
	  	<cfargument name="event" type="any">
		<cfset var idvalue = "" />
		<cfset var formbean = "" />
		<cfset var qonerow = "" />
		<cfscript>
			// bean helper file 
			var beanhelper 	= getModelGlue().getBean("beanhelper");;
			beforeSave(event);
			// populate form bean 
			formbean 	= beanhelper.PopulateBean( this.objectname );
			arguments.event.setValue( "#this.objectname#formbean" , formbean );
			idvalue 	= getModelGlue().getBean( this.objectname ).save ( formbean );
			qonerow 	= getModelGlue().getBean( this.objectname ).get( numberformat( idvalue,"9999") );
			arguments.event.addResult("redirect");
			if(getListByUrlKey() neq "")
				arguments.event.setValue( "#getListByUrlKey()#" , evaluate("qonerow.#this.listbytablekey#") );
			arguments.event.setValue( "#this.primarykey#" , evaluate("qonerow.#this.primarykey#") );	
			afterSave(event);
			beforeListRedirect(event);
		</cfscript>
		<cfif this.useredirect>
			<cflocation url="index.cfm?event=list#this.objectname#s&#getListByUrlKey()#=#evaluate("qonerow.#this.listbytablekey#")#"/>
		</cfif>
	</cffunction>
	<cffunction name="afterSave" access="public" returnType="void" output="false" hint="I'm the stub to be called after the save function.">
	  	<cfargument name="event" type="any">
		<cfreturn />
	</cffunction>
	
</cfcomponent>
