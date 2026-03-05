<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:txm="http://textometrie.org/1.0" exclude-result-prefixes="xs" version="2.0">
		
		<xsl:output method="xhtml" encoding="UTF-8" indent="no"/>
		
		<xsl:param name="edition-name"> default </xsl:param>
		
		<xsl:param name="number-words-per-page"><!-- Ignored by this stylesheet --> 999999 </xsl:param>
		
		<xsl:param name="pagination-element"><!-- Ignored by this stylesheet --> a[@class='txm-page'] </xsl:param>
		
		<xsl:param name="css-name"><!-- Ignored by this stylesheet --> ogr-txm.css </xsl:param>
		
		<xsl:param name="output-directory">
			<xsl:value-of select="concat($current-file-directory, '/', $edition-name)"/>
		</xsl:param>
	
	<xsl:variable name="current-file-name">
		<!-- Copied from TXM default stylesheets -->
		<xsl:analyze-string select="document-uri(.)"
			regex="^(.*)/([^/]+)\.[^/]+$">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(2)" />
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:variable>
	
	<xsl:variable name="current-file-directory">
		<!-- Copied from TXM default stylesheets -->
		<xsl:analyze-string select="document-uri(.)"
			regex="^(.*)/([^/]+)\.[^/]+$">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(1)" />
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:result-document href="{$output-directory}/{$current-file-name}_1.html/">
			<xsl:apply-templates/>
		
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:copy/>
	</xsl:template>
	

</xsl:stylesheet>
