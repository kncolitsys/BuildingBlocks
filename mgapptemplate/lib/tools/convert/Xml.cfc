<cfcomponent output="no">
	<cfset introspect = createobject("component", "%newApplicationDirectoryDotPath%.lib.tools.introspect") />
	<!---
	
	This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0. For more information,
	please see the web site at:
		
		http://www.cflib.org
		
	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.
		
	License:
	This code may be used freely. 
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->
<cffunction name="dump" access="public" output="true" returntype="void" hint="Simulates cfdump from a cfscript block">
	<cfargument name="var" required="true" type="any" hint="Variable to dump" />
	<cfargument name="expand" required="false" type="boolean" hint="Boolean to expand the dump" />
	<cfargument name="top" required="false" type="numeric" hint="Only show the top n layers" />

	<cfscript>

		var sOptions = "";

		if (structKeyExists(arguments, "expand"))
			sOptions = " expand=" & arguments.expand;

		if (structKeyExists(arguments, "top"))
			sOptions = sOptions & " top=" & arguments.top;

	</cfscript>

	<cfdump var="#arguments.var#" />

	<cfreturn />

</cffunction>

<cffunction name="getXmlValue" access="public" output="false" returntype="string">
	<cfargument name="xml" required="true" type="string"/>
	<cfargument name="outerwrapper" required="true" type="string"/>
	<cfargument name="innerwrapper" required="true" type="string"/>
	<cfargument name="field" required="true" type="string"/>
	<cfargument name="position" required="false" type="numeric" default="1">
	<cfset var valuearray = "" />
	<cfset var value = "" />
	<cfscript>
		// use xmlsearch to grab that element
		valuearray=xmlsearch(arguments.xml,"/#arguments.outerwrapper#/#arguments.innerwrapper#[#arguments.position#]/#arguments.field#");
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

<cffunction name="abort" access="public" output="false" returntype="void" hint="aborts">
	<cfabort>
</cffunction>

<cffunction name="removeNullDates" access="public" output="false" returntype="string" hint="removesNullDates">
	<cfargument name="text">
	<cfset var cleaneduptext 	= replace(arguments.text,"01/01/100","","ALL")/>
	<cfset cleaneduptext 		= replace(cleaneduptext,"{ts '0100-01-01 00:00:00'}","","ALL")/>
	<cfset cleaneduptext 		= replace(cleaneduptext,"{ts '100-01-01 00:00:00'}","","ALL")/>
	<cfreturn cleaneduptext/>
</cffunction>

<cffunction name="clean" access="public" output="false" returntype="string" hint="removesNullDates">
	<cfargument name="text">
	<cfset var cleaneduptext 	= replace(arguments.text,"","","ALL") />
	<cfreturn cleaneduptext/>
</cffunction>

<cffunction name="BridgeTableToXml" returntype="string" access="public">
	<cfargument name="field" 			required="yes">
 	<cfargument name="outerxml" 		required="no" default="out">
	<cfargument name="innerxml" 		required="no" default="in">
	<cfset var currentfield = "" />
	<cfset var list = "" />
	<cfset var currentfieldvalue = "" />
	<cfset var onelistitem = "" />
	<cfset var minusbeanname = "" />
	<cfset var beanname = "" />
	<cfset var newxml = "" />
	<cfset var checkboxfield = "" />
	<cfset beanname 		= listfirst(arguments.field,".")/>
	<cfset checkboxfield 	= listlast(arguments.field,".") />
	<cfif structkeyexists(form, "#beanname#.#checkboxfield#" ) >
		<cfset list = form[ "#beanname#.#checkboxfield#" ] />
	<cfelse>
		<cfset list = "" />
	</cfif>
	<cfoutput>
	<cfsavecontent variable="newxml"><?xml version="1.0" encoding="UTF-8"?>
	<#outerxml#>
	<cfloop list="#list#" index="onelistitem">
		<#innerxml#>
			<#checkboxfield#>#onelistitem#</#checkboxfield#>
			<cfloop list="#StructKeyList(form)#" index="currentfield">
				<!--- if it belongs to this bean, i.e. for "facility" is of facility.* --->
				<cfif refind("^#ucase(beanname)#\.",currentfield) or beanname eq "">
					<!--- for the current field we are looping on grab its value --->
					<cfset currentfieldvalue = form["#currentfield#"]>
					<!--- We want to take off "Facility" from "Facility.id" --->
					<cfset minusbeanname =	rereplace(currentfield,"^#ucase(beanname)#\.","")>
					<cfif minusbeanname neq checkboxfield>
						<#lcase(minusbeanname)#>#evaluate( currentfield )#</#lcase(minusbeanname)#>
					</cfif>
				</cfif>
			</cfloop>
		</#innerxml#>
	</cfloop>
	</#outerxml#>
	</cfsavecontent>
	</cfoutput>
	<cfreturn removeNullDates(newxml)>
</cffunction>

<cffunction name="BeanToXml" returntype="string" access="public">
	<cfargument name="thebean">
 	<cfargument name="outerxml">
	<cfargument name="innerxml">
	<cfset var current = "" />
	<cfset var value = "" />
	<cfset var currentfieldname = "" />
	<cfset var currentfunctionname = "" />
	<cfset var newxml = "" />
	<!--- Create a new structure. --->
	<cfset aboutcfc=structNew()>
	<cfset thebean = arguments.thebean>
	<!--- Populate the structure with the metadata for the
				tellTimeObj instance of the tellTime CFC. --->
	<cfset aboutcfc = introspect.introspectMetaData(arguments.thebean)>
	<cfset outerxml = arguments.outerxml>
	<cfset innerxml = arguments.innerxml>
	<cfset newxml = "<?xml version=""1.0"" encoding=""ISO-8859-1""?><#outerxml#>">
	<cfoutput>
		<cfset newxml = newxml & "<#innerxml#>">
		<cfloop from="1" to="#arraylen(aboutcfc.functions)#" index="i">
			<cfscript>
				current = aboutcfc.functions[i];
				currentfunctionname = current.name;
				currentfieldname = lcase(replace(currentfunctionname,"get",""));
			</cfscript>
			<cfif refind("^get.*",currentfunctionname)>
				<cfset value = evaluate("thebean.#currentfunctionname#()") />
				<cfif issimplevalue(value)>
					<cfset newxml = newxml & "<#currentfieldname#>#xmlformat(value)#</#currentfieldname#>">
				</cfif>
			</cfif>
		</cfloop>
		<cfset newxml = newxml & "</#innerxml#>">
		<cfset newxml = newxml & "</#outerxml#>">
	</cfoutput>
	<cfreturn clean(removeNullDates(newxml))>
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
		  try
			{
				columnvalue=record[listgetat(columnList,j)];
				columnvalue=evaluate("columnvalue#tovaluepath#");
				operation="instance.set#column#(columnvalue)";
				// if it is a date and columnvalue is "" then set it to 01/01/100
				if( evaluate( "isdate(instance.get#column#())" ) and len(columnvalue) eq 0 )
				{
					operation="instance.set#column#('01/01/100')";
				}
				evaluate(operation);
			}
			catch(any excpt)
			{
			}
		}
	  }
	}
	return instance;
}		
	
/**
 * Generates an XMLDoc object from a basic CF Query.
 * 
 * @param query 	 The query to transform. (Required)
 * @param rootElement 	 Name of the root node. (Default is "query.") (Optional)
 * @param row 	 Name of each row. Default is "row." (Optional)
 * @param nodeMode 	 Defines the structure of the resulting XML.  Options are 1) "values" (default), which makes each value of each column mlText of individual nodes; 2) "columns", which makes each value of each column an attribute of a node for that column; 3) "rows", which makes each row a node, with the column names as attributes. (Optional)
 * @return Returns a string. 
 * @author Nathan Dintenfass (&#110;&#97;&#116;&#104;&#97;&#110;&#64;&#99;&#104;&#97;&#110;&#103;&#101;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 2, November 15, 2002 
 */
 
function queryToXML(query){
	//the default name of the root element
	var root = "query";
	//the default name of each row
	var row = "row";
	//make an array of the columns for looping
	var cols = listToArray(query.columnList);
	//which mode will we use?
	var nodeMode = "values";
	//vars for iterating
	var ii = 1;
	var rr = 1;
	//vars for holding the values of the current column and value
	var thisColumn = "";
	var thisValue = "";
	//a new xmlDoc
	var xml = xmlNew();
	//if there are 2 arguments, the second one is name of the root element
	if(structCount(arguments) GTE 2)
		root = arguments[2];
	//if there are 3 arguments, the third one is the name each element
	if(structCount(arguments) GTE 3)
		row = arguments[3];		
	//if there is a 4th argument, it's the nodeMode
	if(structCount(arguments) GTE 4)
		nodeMode = arguments[4]; 
	else
		nodeMode = "values";	
	//create the root node
	xml.xmlRoot = xmlElemNew(xml,root);
	//capture basic info in attributes of the root node
	xml[root].xmlAttributes["columns"] = arrayLen(cols);
	xml[root].xmlAttributes["columnnames"] = query.columnlist;
	xml[root].xmlAttributes["rows"] = query.recordCount;
	//loop over the recordcount of the query and add a row for each one
	for(rr = 1; rr LTE query.recordCount; rr = rr + 1){
		arrayAppend(xml[root].xmlChildren,xmlElemNew(xml,row)); 
		//loop over the columns, populating the values of this row
		for(ii = 1; ii LTE arrayLen(cols); ii = ii + 1){
			thisColumn = lcase(cols[ii]);
			thisValue = query[cols[ii]][rr];
			switch(nodeMode){
				case "rows":
					xml[root][row][rr].xmlAttributes[thisColumn] = thisValue;
					break;
				case "columns":
					arrayAppend(xml[root][row][rr].xmlChildren,xmlElemNew(xml,thisColumn)); 
					xml[root][row][rr][thisColumn].xmlAttributes["value"] = thisValue;
					break;
				default:
					arrayAppend(xml[root][row][rr].xmlChildren,xmlElemNew(xml,thisColumn)); 
					xml[root][row][rr][thisColumn].xmlText = thisValue;						
			}

		}
	}
	//return the xmlDoc
	return removeNullDates(xml);	
}


function structToXML(thestruct, outerxml,innerxml){
	return queryToXML(StructToQuery(thestruct),outerxml,innerxml);
}


  /**
  * Convert an XML document into a query record set
  * 
  * @param xmlDoc           XML document object (Required)
  * @param path             An XPath leading to the XML node set that will form the rows of the query (Required)
  * @param columnDataList   Comma-delimited list of column data  (Required)
  * @return query record set
  * @author Matthew Walker, www.eswsoftware.com
  * @version 1.2, 2005-08-24 handles empty record fields - update by Nathanael Waite
  * @version 1.1, 2004-09-05 added querySetCell() - thanks Dan
  * @version 1, 2004-04-07
  */

  function xmlToQuery(xmlDoc, path) {
    var records = xmlSearch(xmlDoc, path);
    var i = 0;
    var j = 0;
   // var temp = listToArray(columnDataList);
    var columns = arrayNew(1);
    var column = "";
	var columnlist = "";
    var result = "";
	var tovaluepath = "[1].xmltext";
	var columnvalue = "";
	var record = "";
	var columnliststring = "";
	var columnlistarray = "";
	var outerxmlminusfwd = "";
	var outerxml = "";
	
	
	xmlDoc = xmlparse(xmlDoc);
	
	columnliststring = "xmlDoc#replace(path,"/",".","ALL")#[1].xmlchildren";
	
	try
	{
		columnlistarray = evaluate(columnliststring);
	}
	catch(Any excpt)
	{
		// from /countyprojects/countyproject/ we want just countyprojects/countyproject/
		outerxmlminusfwd = mid(path,2,len(path));
		// from countyprojects/countyproject/ we want just countyprojects
		outerxml = rereplace(outerxmlminusfwd,"(.*)(/.*)","\1");
		// we want to grab the columnnames from <countyprojects columnnames="COUNTY_ID,ID,PROJECT_ID" columns="3" rows="0"/>
		columnliststring = "xmlDoc.#outerxml#[1].xmlattributes.columnnames";
		columnlist = evaluate(columnliststring);
	}
	
	if(structCount(arguments) GTE 3)
		columnlist = arguments[3];
	if(structCount(arguments) GTE 4)
		tovaluepath = arguments[4];
			
	
	if(columnlist eq "")
	{
		columnlist = "";
		for(i=1; i lte ArrayLen(columnlistarray); i=i+1)
		{
			columnlist = columnlist & iif(columnlist eq "", de(""), de(",")) & "#evaluate("#columnliststring#[i].xmlname")#";
		}
	}

	result = queryNew(columnList);
	
    if ( arraylen(records) ) 
	{
      queryAddRow(result, arrayLen(records));
      for ( i = 1; i lte arrayLen(records); i = i + 1 ) {
        record = records[i];
        for ( j = 1; j lte listlen(columnList); j = j + 1 ) {
          column = listgetat(columnList,j);
          if ( structKeyExists(record, column) ) { 
		  	columnvalue=record[listgetat(columnList,j)];
			columnvalue=evaluate("columnvalue#tovaluepath#");
            querySetCell(result, column, columnvalue, i);
          }
          else {
            querySetCell(result, column, "", i);
          }
        }
      }
    }
	
    return result;
  }
  
</cfscript>

<!---<cffunction name="queryToXML" returntype="string" access="public" output="false" hint="Converts a query to XML">
	<cfargument name="data" type="query" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="cDataCols" type="string" required="false" default="">
	
	<cfset var s = createObject('java','java.lang.StringBuffer').init("<?xml version=""1.0"" encoding=""UTF-8""?>")>
	<cfset var col = "">
	<cfset var columns = arguments.data.columnlist>
	<cfset var txt = "">

	<cfset s.append("<#arguments.rootelement#>")>
	
	<cfloop query="arguments.data">
		<cfset s.append("<#arguments.itemelement#>")>

		<cfloop index="col" list="#columns#">
			<cfset txt = arguments.data[col][currentRow]>
			<cfif isSimpleValue(txt)>
				<cfif listFindNoCase(arguments.cDataCols, col)>
					<cfset txt = "<![CDATA[" & txt & "]]" & ">">
				<cfelse>
					<cfset txt = xmlFormat(txt)>
				</cfif>
			<cfelse>
				<cfset txt = "">
			</cfif>

			<cfset s.append("<#col#>#txt#</#col#>")>

		</cfloop>
		
		<cfset s.append("</#arguments.itemelement#>")>	
	</cfloop>
	
	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfreturn removeNullDates( s.toString() )>
</cffunction>--->

	<cffunction name="QueryToStruct" access="public" returntype="any" output="false"
		hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">
		
		<!--- Define arguments. --->
		<cfargument name="Query" type="query" required="true" />
		<cfargument name="Row" type="numeric" required="false" default="0" />
		
		<cfscript>
			
			// Define the local scope.
			var LOCAL = StructNew();
			
			// Determine the indexes that we will need to loop over.
			// To do so, check to see if we are working with a  given row, 
			// or the whole record set.
			if (ARGUMENTS.Row){
				
				// We are only looping over one row.
				LOCAL.FromIndex = ARGUMENTS.Row;
				LOCAL.ToIndex = ARGUMENTS.Row;
				
			} else {
			
				// We are looping over the entire query.
				LOCAL.FromIndex = 1;
				LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;
			
			}
			
			// Get the list of columns as an array and the column count.
			LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
			LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );
			
			// Create an array to keep all the objects.
			LOCAL.DataArray = ArrayNew( 1 );
			
			// Loop over the rows to create a structure for each row.
			for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
			
				// Create a new structure for this row.
				ArrayAppend( LOCAL.DataArray, StructNew() );
				
				// Get the index of the current data array object.
				LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );
				
				// Loop over the columns to set the structure values.
				for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
	
					// Get the column value.
					LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
				
					// Set column value into the structure.
					LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
				
				}
			
			}
			
			
			// At this point, we have an array of structure objects that
			// represent the rows in the query over the indexes that we 
			// wanted to convert. If we did not want to convert a specific
			// record, return the array. If we wanted to convert a single
			// row, then return the just that STRUCTURE, not the array.
			if (ARGUMENTS.Row){
				
				// Return the first array item.
				return( LOCAL.DataArray[ 1 ] );
				
			} else {
			
				// Return the entire array.
				return( LOCAL.DataArray );
				
			}
			
		</cfscript>	
	</cffunction>
	<cffunction name="StructToQuery">
		<cfargument name="structToConvert" type="struct">
		<cfset var value = "" />
		<cfset var strKey = "" />
		<cfset var newquery = "" />
		<!--- Create a new query. --->
		<cfset newquery = QueryNew( "" ) />
		 
		<!--- Loop over keys in the struct. --->
		<cfloop index="strKey" list="#StructKeyList( structToConvert )#" delimiters=",">
			 <cfset value= ArrayNew(1) />
			 <cfset value[1] = removeNullDates(arguments.structToConvert[strKey]) />
			 <!--- Add column to new query with default values. --->
			<cfset QueryAddColumn( 
				newquery, 
				strKey, 
				"VARCHAR",
				value
				) />
		 
		</cfloop>	
		<cfreturn newquery>				
	</cffunction>
	<cffunction name="StructToArray">
		<cfargument name="structToConvert" type="struct">
		<cfset var newarray = "" />
		<cfset var strKey = "" />
		<cfset newarray = arraynew(1) />
		<!--- Loop over keys in the struct. --->
		<cfloop index="strKey" list="#StructKeyList( structToConvert )#" delimiters=",">
			 <cfset newarray = arrayappend(newarray,arguments.structToConvert[strKey]) />
		</cfloop>	
		<cfreturn newarray>				
	</cffunction>
</cfcomponent>