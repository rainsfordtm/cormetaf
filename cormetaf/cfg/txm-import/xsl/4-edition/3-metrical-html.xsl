<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:txm="http://textometrie.org/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>

    <xsl:param name="edition-name"> dipl </xsl:param>

    <xsl:param name="number-words-per-page"><!-- Ignored by this stylesheet --> 999999 </xsl:param>

    <xsl:param name="pagination-element"><!-- Ignored by this stylesheet --> a[@class='txm-page'] </xsl:param>

    <xsl:param name="css-name"><!-- Ignored by this stylesheet --> ogr-txm-dipl.css </xsl:param>

    <xsl:param name="output-directory">
        <xsl:value-of select="concat($current-file-directory, '/', $edition-name)"/>
    </xsl:param>

    <xsl:variable name="current-file-name">
        <!-- Copied from TXM default stylesheets -->
        <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)\.[^/]+$">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="current-file-directory">
        <!-- Copied from TXM default stylesheets -->
        <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)\.[^/]+$">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>

    <xsl:template match="/">
        <!-- Adapted from TXM default stylesheets, combines edition and pager -->
        <!-- xsl:result-document href="{$output-directory}/{$current-file-name}_1.html/" -->
        <html>
            <head>
                <title>
                    <xsl:choose>
                        <xsl:when test="//tei:text/@id">
                            <xsl:value-of select="//tei:text[1]/@id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$current-file-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
                <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
                <meta name="description" content="{//tei:text/descendant::tei:w[1]/@id}"/>
                <meta name="txm:first-word-id" content="{//tei:text/descendant::tei:w[1]/@id}"/>
                <!-- As required by TXM docs -->
                <link rel="stylesheet" media="all" type="text/css" href="css/cormetaf.css"/>
            </head>
            <xsl:apply-templates select="descendant::tei:text"/>
        </html>
        <!-- /xsl:result-document -->
    </xsl:template>
    
<xsl:template match="tei:text">
    
    <!-- Pass 0: convert <l/> to <lb/> -->
    
    <xsl:variable name="stage0" as="node()*">
        <xsl:apply-templates select="." mode="l-to-lb"/>
    </xsl:variable>

    <!-- Pass 1: add lb attributes -->
    <xsl:variable name="stage1" as="node()*">
        <xsl:apply-templates select="$stage0" mode="add-lb"/>
    </xsl:variable>

    <!-- Pass 2: convert txm:ana to attributes -->
    <xsl:variable name="stage2" as="node()*">
        <xsl:apply-templates select="$stage1" mode="ana2attr"/>
    </xsl:variable>

    <!-- Pass 3: render -->
    <body>
        <!-- a class="txm-page" title="1" next-word-id="w_0"/ -->
        <div class="txmeditionpage">
            <h1>
                <xsl:value-of select="@id"/>
            </h1>
            <br/>
            <table>
                <xsl:for-each select="@*">
                    <tr>
                        <td>
                            <xsl:value-of select="name()"/>
                        </td>
                        <td>
                            <xsl:value-of select="."/>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
        <div class="txmeditionpage">
            <table>
                <xsl:apply-templates select="$stage2//tei:lb[@type='sylvaline']"
                        mode="render-line"/>
            </table>
        </div>
    </body>

</xsl:template>

<xsl:template match="tei:l" mode="l-to-lb">
    <xsl:element name="tei:lb">
        <xsl:attribute name="type">sylvaline</xsl:attribute>
        <xsl:attribute name="n" select="count(preceding::tei:l)"/>
    </xsl:element>
    <xsl:apply-templates select="*" mode="l-to-lb"/>
</xsl:template>

<xsl:template match="*" mode="l-to-lb">
    <xsl:copy>
        <xsl:apply-templates select="@*, node()" mode="l-to-lb"/>
    </xsl:copy>
</xsl:template>


<xsl:template match="*" mode="add-lb">
    <xsl:copy>
        <xsl:attribute name="tei-lb"
            select="preceding::tei:lb[@type='sylvaline'][1]/@n"/>
        <xsl:apply-templates select="@*, node()" mode="add-lb"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="@*|text()" mode="add-lb l-to-lb">
    <xsl:copy/>
</xsl:template>

<xsl:template match="tei:w" mode="ana2attr">

    <xsl:copy>

        <!-- copy original attributes -->
        <xsl:apply-templates select="@*" mode="ana2attr"/>

        <!-- create attributes from txm:ana -->
        <xsl:for-each select="txm:ana[starts-with(@type,'#')]">
            <xsl:attribute name="{substring-after(@type,'#')}"
                           select="."/>
        </xsl:for-each>
        
        <!-- process remaining children -->
        <xsl:apply-templates select="node()[not(self::txm:ana)]"
                             mode="ana2attr"/>

    </xsl:copy>

</xsl:template>

<xsl:template match="@*|node()" mode="ana2attr">
    <xsl:copy>
        <xsl:apply-templates select="@*, node()" mode="ana2attr"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="tei:lb" mode="render-line">

    <xsl:variable name="line" select="@n"/>
    
    <tr>
    
        <xsl:element name="td">
            <xsl:attribute name="class">texttt</xsl:attribute>
            <xsl:apply-templates
                select="following::tei:w[@tei-lb=$line]"
                mode="render-word"/>
        </xsl:element>
        
        <xsl:element name="td">
            <xsl:attribute name="class">linemet</xsl:attribute>
            <xsl:value-of select="following::tei:w[1]/@line_met"/>
        </xsl:element>
        
        <xsl:element name="td">
            <xsl:value-of select="following::tei:w[1]/@ref"/>
        </xsl:element>
    
    </tr>
    <xsl:text>&#x0a;</xsl:text>

</xsl:template>
       
<xsl:template match="tei:w" mode="render-word">

    <xsl:variable name="width"
        select="number(@counted_syllables) * 8"/>
        
    <xsl:variable name="last-w" select="preceding::tei:w[@syllabified != '--'][1]"/>
    <xsl:variable name="pad-left">
        <xsl:choose>
            <xsl:when test="$last-w/@counted_syllables = '0'">
                <xsl:value-of select="$width - string-length(txm:form/text()) - string-length($last-w/txm:form/text()) - 1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$width - string-length(txm:form/text()) - 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:if test="@counted_syllables != '0' and @syllabified != '--'">
        
        <!-- Pad left -->
        <xsl:value-of select="substring('&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;', 1, number($pad-left))"/>
        <!-- Proclitics -->
        <xsl:if test="$last-w/@counted_syllables = '0'">
            <xsl:element name="span">
                <xsl:attribute name="class">w</xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:apply-templates select="$last-w/@*[name() = ('pos', 'lemma', 'prosody', 'metpos', 'soptem', 'counted_syllables')]"
                     mode="title-string"/>
                </xsl:attribute>
                <xsl:value-of select="$last-w/txm:form"/>
            </xsl:element>
        </xsl:if>
        <!-- Main word -->
        <xsl:element name="span">
            <xsl:attribute name="class">w</xsl:attribute>
            <xsl:attribute name="title">
                <xsl:apply-templates select="@*[name() = ('pos', 'lemma', 'prosody', 'metpos', 'soptem', 'counted_syllables')]"
                     mode="title-string"/>
            </xsl:attribute>
            <xsl:value-of select="txm:form"/>
        </xsl:element>
        <!-- Following space -->
        <xsl:text>&#xa0;</xsl:text>
    </xsl:if>

</xsl:template>

    <xsl:template match="@*" mode="title-string">
        <xsl:value-of select="name()"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:if test="not(position() = last())">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
