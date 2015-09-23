&lt;link REL=&quot;STYLESHEET&quot; TYPE=&quot;text/css&quot; HREF=&quot;content/css/stylesheet.css&quot;&gt;
&lt;cfset request.modelGlueSuppressDebugging = true /&gt;
&lt;cfset q%objectname%s = viewstate.getValue("q%objectname%s") /&gt;

&lt;script&gt;
	function add%objectname%(value)
	{
		url="index.cfm?event=add%objectname%&%listbytablekey%="+value;
		window.location= url;
	}
	function edit%objectname%(id)
	{
		url="index.cfm?event=edit%objectname%&%primarykey%="+id;
		window.location= url;
	}
	function delete%objectname%(id)
	{
		if(confirm('Are you sure you want to delete this?'))
		{
			url="index.cfm?event=delete%objectname%&%primarykey%="+id;
			window.location= url;
		}
	}
&lt;/script&gt;

&lt;cfoutput&gt;
<cfoutput>
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn eq pk>
Add new %objectname% &lt;a href=&quot;javascript:add%objectname%(##viewstate.getvalue('%listbytablekey%')##)&quot;&gt;&lt;img src=&quot;content/images/add.png&quot;/&gt;&lt;/a&gt;
</cfif>
</cfloop>
<fieldset>
<legend>%objectname%s</legend>
&lt;table &gt;
&lt;tr&gt;
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn eq pk>
&lt;td class=&quot;tableheader&quot;&gt;&lt;strong&gt;#onecolumn#&lt;strong&gt;&lt;/td&gt;
</cfif>
</cfloop>
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn neq pk>
&lt;td class=&quot;tableheader&quot;&gt;&lt;strong&gt;#onecolumn#&lt;/strong&gt;&lt;/td&gt;
</cfif>
</cfloop>
&lt;td class=&quot;tableheader&quot;&gt;&lt;strong&gt;Delete&lt;/strong&gt;&lt;/td&gt;
&lt;/tr&gt;
&lt;cfset bgcolor = &quot;####FFFFFF&quot;&gt;
&lt;cfloop query=&quot;q%objectname%s&quot;&gt;
&lt;tr bgcolor=&quot;##bgcolor##&quot;&gt;
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn eq pk>
&lt;td&gt;&lt;a href=&quot;javascript:edit%objectname%(##q%objectname%s.#onecolumn###)&quot;&gt;&lt;img src=&quot;content/images/application_edit.png&quot;/&gt; ##q%objectname%s.#onecolumn###&lt;/a&gt;&lt;/td&gt;
</cfif>
</cfloop>
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn neq pk>
&lt;td&gt;
&lt;cfif isDate(q%objectname%s.#onecolumn#)&gt;
##dateformat(q%objectname%s.#onecolumn#,&quot;mm/dd/yyyy&quot;)##
&lt;cfelse&gt;
##q%objectname%s.#onecolumn###
&lt;/cfif&gt;
&lt;/td&gt;
</cfif>
</cfloop>
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
<cfif onecolumn eq pk>
&lt;td&gt;&lt;a onclick="if(confirm('Are you sure you want to delete?')) return true; else return false;" href=&quot;#ajaxlink('index.cfm?event=delete%objectname%&amp;#onecolumn#=##q%objectname%s.#onecolumn###')#&quot;&gt;&lt;img src=&quot;content/images/delete.png&quot;/&gt;&lt;/label&gt;&lt;/td&gt;
</cfif>
</cfloop>
&lt;/tr&gt;
&lt;cfif bgcolor eq &quot;####FFFFFF&quot;&gt;
&lt;cfset bgcolor = &quot;####CCCCCC&quot;&gt;
&lt;cfelse&gt;
&lt;cfset bgcolor = &quot;####FFFFFF&quot;&gt;
&lt;/cfif&gt;
&lt;/cfloop&gt;
&lt;/table&gt;
&lt;/cfoutput&gt;
</fieldset>
</cfoutput>
