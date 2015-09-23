<cfcomponent> 
	<cffunction name="dateDiffNull" access="public" returntype="string">
		<cfargument name="datepart" required="yes">
		<cfargument name="date1" required="yes">
		<cfargument name="date2" required="yes">
		<cfif date1 neq "" and date2 neq "">
			<cfreturn dateDiff(datepart, date1, date2)/>
		</cfif>
		<cfreturn ""/>
	</cffunction>
	<cffunction name="smallestOfArray" access="public" returntype="string">
		<cfargument name="dateArray" type="array">
		<cfset smallest = dateArray[1]>
		<cfloop index="thisElement" from="1" to="#arraylen(dateArray)#">
			<cfset date2 = dateArray[thisElement]>
			<cfset smallest = smallestDate(smallest,date2)>	
		</cfloop>
		<cfreturn smallest/>
	</cffunction>
	<cffunction name="biggestOfArray" access="public" returntype="string">
		<cfargument name="dateArray" type="array">
		<cfset biggest = dateArray[1]>
		<cfloop index="thisElement" from="1" to="#arraylen(dateArray)#">
			<cfset date2 = dateArray[thisElement]>
			<cfset biggest = biggestDate(biggest,date2)>	
		</cfloop>
		<cfreturn biggest/>
	</cffunction>
  
<!---used in the APTS app  TSC--->  
	<cffunction name="smallestOf3Dates" access="public" returntype="string">
		<cfargument name="date1" default="">
		<cfargument name="date2" default="">
		<cfargument name="date3" default="">
		<cfset datearray = ArrayNew(1)>
		<cfset datearray[1] = date1>
		<cfset datearray[2] = date2>
		<cfset datearray[3] = date3>
		<cfreturn smallestOfArray(datearray)>
	</cffunction>
	<cffunction name="smallestDate" access="public" returntype="string">
		<cfargument name="date1">
		<cfargument name="date2">
		<cfset smallest = "">
		
		<cfif date1 eq "" and date2 eq "">
			<cfreturn "">
		</cfif>
		<cfif date1 eq "">
			<cfreturn date2>
		</cfif>
		<cfif date2 eq "">
			<cfreturn date1>
		</cfif>
		
		<cfswitch expression="#datecompare(date1,date2)#">
			<cfcase value="-1">
				<cfset smallest = date1>
			</cfcase>
			<cfcase value="0">
				<cfset smallest = date1>
			</cfcase>
			<cfcase value="1">
				<cfset smallest = date2>
			</cfcase>
		</cfswitch>
		<cfreturn smallest />
	</cffunction>
	<cffunction name="biggestDate" access="public" returntype="string">
		<cfargument name="date1">
		<cfargument name="date2">
		<cfset biggest = "">
		
		<cfif date1 eq "" and date2 eq "">
			<cfreturn "">
		</cfif>
		<cfif date1 eq "">
			<cfreturn date2>
		</cfif>
		<cfif date2 eq "">
			<cfreturn date1>
		</cfif>
	
		<cfswitch expression="#datecompare(date1,date2)#">
			<cfcase value="-1">
				<cfset biggest = date2>
			</cfcase>
			<cfcase value="0">
				<cfset biggest = date2>
			</cfcase>
			<cfcase value="1">
				<cfset biggest = date1>
			</cfcase>
		</cfswitch>
		<cfreturn biggest />
	</cffunction>
</cfcomponent>















