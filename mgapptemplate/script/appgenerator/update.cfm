<cfant	buildFile="#expandpath('update.xml')#"
		defaultDirectory="seemsTobeIgnoredButMustBePresent"
		anthome="alsoSeemsToBeIgnoredButMayNeedToHaveAnEnvironmentVariableSetup"
		target="updateLocal"
		messages="result"
/> 

<cfdump var="#result#">
<br />
<br />

<a href="index.cfm">Back to the main page</a>