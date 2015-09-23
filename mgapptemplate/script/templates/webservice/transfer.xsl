<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
			&lt;object name="%objectname%" table="<xsl:value-of select="//dbtable/@name" />"&gt;
				<xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']">&lt;id name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" /&gt;
				</xsl:for-each>
				<xsl:for-each select="root/bean/dbtable/column[@primaryKey!='Yes']">&lt;property name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" column="<xsl:value-of select="@name" />" <xsl:choose><xsl:when test="@required='No'">nullable="true"</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>/&gt;
				</xsl:for-each>
			&lt;/object&gt;</xsl:template>
</xsl:stylesheet>

