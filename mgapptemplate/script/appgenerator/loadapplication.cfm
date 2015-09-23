<cfif fileexists( expandpath('../../config/application.xml') )>
	<cfset session.qcruds = QueryNew("id,object,pk,listby,webservicepath,tablename,datasource","varchar,varchar,varchar,varchar,varchar,varchar,varchar") />	
	<cfset session.qpages = QueryNew("id,object,event","varchar,varchar,varchar") />	

	<cffile action="read" file="#expandpath('../../config/application.xml')#" variable="appxml"/>
	<cfscript>
		thexml = appxml;
		// xml query to get array of each individual rows
		base 	= "/application/cruds/crud";
		records = xmlsearch(thexml, base);
		session.qcruds = QueryNew("id,object,pk,listby,webservicepath,tablename,datasource","varchar,varchar,varchar,varchar,varchar,varchar,varchar");	
		// Loop thru each set of countyproject in case there were several
		for(i = 1; i lte arraylen(records); i = i + 1)
		{			
			// grab current countyproject
			record			= records[i];
			// get values
			QueryAddRow(session.qcruds);
			QuerySetCell( session.qcruds, "id"				, getXmlValue(thexml,  base, 'id', i) );
			QuerySetCell( session.qcruds, "object"			, getXmlValue(thexml,  base, 'object', i) );
			QuerySetCell( session.qcruds, "pk"				, getXmlValue(thexml,  base, 'pk', i) );
			QuerySetCell( session.qcruds, "listby"			, getXmlValue(thexml,  base, 'listby', i) );
			QuerySetCell( session.qcruds, "webservicepath"	, getXmlValue(thexml,  base, 'webservicepath', i) );
			QuerySetCell( session.qcruds, "tablename"		, getXmlValue(thexml,  base, 'tablename', i) );
			QuerySetCell( session.qcruds, "datasource"		, getXmlValue(thexml,  base, 'datasource', i) );
			// set startdate if blank
	
		}
		base 	= "/application/pages/page";
		records = xmlsearch(thexml, base);
		// Loop thru each set of countyproject in case there were several
		for(i = 1; i lte arraylen(records); i = i + 1)
		{			
			// grab current countyproject
			record			= records[i];
			// get values id,object,event 
			QueryAddRow(session.qpages);
			QuerySetCell( session.qpages, "id"				, getXmlValue(thexml,  base, 'id', i) );
			QuerySetCell( session.qpages, "object"			, getXmlValue(thexml,  base, 'object', i) );
			QuerySetCell( session.qpages, "event"			, getXmlValue(thexml,  base, 'event', i) );
		}
	</cfscript>
</cfif>

<cffunction name="getXmlValue" access="public" output="false" returntype="string">
	<cfargument name="xml" required="true" type="string"/>
	<cfargument name="xpath" required="true" type="string"/>
	<cfargument name="field" required="true" type="string"/>
	<cfargument name="position" required="false" type="numeric" default="1">
	<cfset var valuearray = "" />
	<cfset var value = "" />
	<cfscript>
		// use xmlsearch to grab that element
		valuearray=xmlsearch(arguments.xml,"#arguments.xpath#[#arguments.position#]/#arguments.field#");
		// get the field, which is the first elemnt of the array
		try
		{
			value=valuearray[1].xmltext;
		}
		catch(Any e)
		{
			value="";
		}
	</cfscript>
	<cfreturn value />
</cffunction>
<cflocation url="index.cfm"/>