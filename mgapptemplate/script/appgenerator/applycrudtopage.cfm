<cfif isdefined("url.page_id")>
	<cfquery name="qpage" dbtype="query">
		SELECT *
		from session.qpages
		where id = '#url.page_id#'
	</cfquery>
<cfelse>
	Error, no page id passed in. <cfabort>
</cfif>
<cfif isdefined("url.crud_id")>
	<cfquery name="qcrud" dbtype="query">
		SELECT *
		from session.qcruds
		where id = '#url.crud_id#'
	</cfquery>
</cfif>
<cfoutput>
<cfdump var="#qcrud#">
<cfdump var="#qpage#">
<cfsavecontent variable="newcontent"><!-- this cannot be inside of a cflayoutarea (tabs) -->
&lt;script src="content/js/#qcrud.object#.js?##rand()##"&gt;&lt;/script&gt;
<!-- this cannot be inside of a cflayoutarea (tabs) -->
&lt;cfwindow name="#qcrud.object#div" title="Add/Edit #qcrud.object#" initshow="false"/&gt;
<!-- put this where you want it to show the #qcrud.object# list -->
&lt;cfdiv id="#qcrud.object#listdiv" bind="url:index.cfm?event=list#qcrud.object#s&#qcrud.listby#=1" /&gt;
</cfsavecontent>
<cfset newcontent = replace(newcontent,"&gt;",">","ALL")/>
<cfset newcontent = replace(newcontent,"&lt;","<","ALL")/>
<cfdump var="#newcontent#">
<cffile action="read" file="#expandpath('../../views/#qpage.object#/dsp#qpage.event#.cfm')#" variable="filecontents"/>
<cffile action="write" file="#expandpath('../../views/#qpage.object#/dsp#qpage.event#.cfm')#" output="#newcontent# #filecontents#"/>
</cfoutput>
<cflocation url="editpage.cfm?id=#url.page_id#">