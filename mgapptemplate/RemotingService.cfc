<!---
This is the Model-Glue remoting service for your application.

It's a thin, stateless wrapper around Model-Glue event invocation, likely to be
re-instantiated on each request it receives.

It's intended to be kept in the same directory as the entry point (normally index.cfm)
for your application.

Because of a chicken-and-egg issue, if you've changed the entry point, you'll want
to change the APPLICATION_TEMPLATE variable below.  Additionally, if you use a non-standard
event name, you'll want to set EVENT_VALUE_NAME as well.
--->

<cfcomponent output="false" extends="ModelGlue.unity.proxy.ModelGlueProxy">

<cfset APPLICATION_TEMPLATE = "/modelgluesamples/remoting/index.cfm" />
<cfset MODEL_GLUE_PATH = "/modelgluesamples/remoting/config/ModelGlue.xml" />
<cfset COLDSPRING_PATH = "/modelgluesamples/remoting/config/ColdSpring.xml" />
<cfset EVENT_VALUE_NAME = "event" />

</cfcomponent>