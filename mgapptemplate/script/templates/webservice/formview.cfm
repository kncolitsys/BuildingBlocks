&lt;cfimport prefix="bean" taglib="/%appfolder%/lib/tools/taglib/bean"&gt;
&lt;cfset %objectname%formbean = viewstate.getValue('%objectname%formbean') &gt;
&lt;cfset request.modelGlueSuppressDebugging = true /&gt;

&lt;script&gt;
function save%objectname%(id)
{
	document.getElementById('%objectname%form').submit();
}
&lt;/script&gt;
&lt;cfoutput&gt;
<fieldset>
<legend>Edit %objectname%</legend>
&lt;cfform action="index.cfm?event=save%objectname%" id="%objectname%form" name="%objectname%form" method="post"&gt;
&lt;table&gt;
<cfoutput>
<cfloop list="#qcolumns.columnlist#" index="onecolumn">
&lt;tr&gt;
&lt;td&gt;&lt;strong&gt;#onecolumn#&lt;/strong&gt;:&lt;/td&gt;
&lt;td&gt;&lt;bean:text field="%objectname%.#onecolumn#" /&gt;&lt;/td&gt;
&lt;/tr&gt;
</cfloop>
</cfoutput>
&lt;tr&gt;&lt;td&gt;&lt;input type="button" value="Save" onclick="save%objectname%();" /&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;/table&gt;
&lt;/cfform&gt;
</fieldset>
&lt;/cfoutput&gt;
