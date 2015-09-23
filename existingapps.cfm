<cfif not isdefined('session.dirlist') or isdefined('url.reinit')>
	<cfdirectory action="list" directory="#expandpath('../Applications')#" name="dir" recurse="yes">
	
	<cfquery name="dir" dbtype="query">
		Select * 
		from dir
		where directory like '%script\appgenerator'
	</cfquery>
	<cfset session.dirlist = dir />
</cfif>


<cfset lastdir = "" />
<cfoutput query="session.dirlist">
	<cfif find("script\appgenerator",session.dirlist.directory) and not lastdir eq session.dirlist.directory>
		<cfset apppath = replace(session.dirlist.directory,"\script\appgenerator","")/>
		<cfset apppath = replace(apppath,expandpath('/'),"")/>
		<li><a href="/#replace(apppath,"\","/","ALL")#/script/" target="_blank"><img src="images/arrow_left.png" /></a> #apppath#</li>
	</cfif>
	<cfset lastdir = session.dirlist.directory />
</cfoutput>