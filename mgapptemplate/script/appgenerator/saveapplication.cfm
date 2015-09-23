<cfsavecontent variable="appxml"><?xml version="1.0" encoding="UTF-8"?>
<application>
<cruds>
<cfoutput query="session.qcruds">
<crud>
<id>#id#</id>
<object>#object#</object>
<pk>#pk#</pk>
<listby>#listby#</listby>
<webservicepath>#webservicepath#</webservicepath>
<tablename>#tablename#</tablename>
<datasource>#datasource#</datasource>
</crud>
</cfoutput>
</cruds>
<pages>
<cfoutput query="session.qpages">
<page>
<id>#id#</id>
<object>#Object#</object>
<event>#Event#</event>
</page>
</cfoutput>
</pages>
</application>
</cfsavecontent>
<cfdump var="#appxml#">
<cffile action="write" file="#expandpath('../../config/application.xml')#" output="#trim(appxml)#"/>
<cflocation url="index.cfm"/>