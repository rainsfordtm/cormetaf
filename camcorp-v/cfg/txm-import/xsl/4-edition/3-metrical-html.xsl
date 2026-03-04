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
                <link rel="stylesheet" media="all" type="text/css" href="css/ogr-txm-dipl.css"/>
            </head>
            <xsl:apply-templates select="descendant::tei:text"/>
        </html>
        <!-- /xsl:result-document -->
    </xsl:template>

    <xsl:template match="tei:text">
        <!-- Add line number from lb type='sylvaline' to every element -->
        <xsl:variable name="text">
            <xsl:apply-templates mode="add-lb"/>
        </xsl:variable>
        <!-- Adapted from default TXM stylesheet -->
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
                <xsl:apply-templates select="$text" mode="find-lbs"/>
            </div>

        </body>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="find-lbs">
        <!-- This is the main template because the metrical view is
        given by iterating the "sylvaline" lb attribute in apply-templates
        on the text node. -->
        <!-- Useful variable: the LB number we need to catch -->
        <xsl:variable name="lineno" select="@n"/>
        <xsl:apply-templates select="following::*[@tei-lb = $lineno]"/>
        <xsl:text>&#x0A;</xsl:text> <!-- newline -->
    </xsl:template>
    
    <!-- In "find-lb" mode, all other nodes should be ignored -->
    <xsl:template match="*" mode="find-lbs">
        <xsl:apply-templates mode="find-lbs"/>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <!-- We only print words with counted syllables -->
        <xsl:if test="@counted_syllables != 0">
            <xsl:apply-templates select="." mode="write-w"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="write-w">
        <!-- This template prints each word.
            - For each counted metrical position we allow five characters.
            - At the caesura and the rhyme we allow an extra two characters;
            these become spaces at the end of oxytones.
            - everything non-syllabic becomes proclitic.
        five characters; for oxytones an extra two at the end (perhaps to be revised?) -->
        <xsl:variable name="nochars">
            <xsl:value-of select="(@counted_syllables * 8)"/>
        </xsl:variable>
        <xsl:variable name="wordtype" select="substring(@prosody, 2, 2)"/>
        <xsl:variable name="last-w" select="preceding::tei:w[@syllabified != '--'][position() = 1]"/>
        <xsl:variable name="pad-left">
            <xsl:choose>
                <xsl:when test="$last-w/@counted_syllables = 0">
                    <xsl:value-of select="$nochars - string-length(.) - string-length($last-w) - 2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$nochars - string-length(.) - 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Print all non-proclitic words but delete segment-less words (punctuation) -->
        <xsl:if test="$nochars != 0">
            <!-- Pad left -->
            <xsl:value-of select="substring('&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;', 1, number($pad-left))"/>
            <!-- Proclitics -->
            <xsl:if test="$last-w/@counted_syllables = 0">
                <xsl:value-of select="$last-w"/>
                <xsl:text>&#xa0;</xsl:text>
            </xsl:if>
            <!-- Main word -->
            <xsl:value-of select="."/>
            <!-- Following space -->
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- Add lb 'sylvaline' to each element -->
    <xsl:template match="*" mode="add-lb">
        <!-- Result of applying this template is a tree with "tei:lb" attribute on every element;
        using lb type="sylvaline" -->
        <xsl:copy>
            <xsl:attribute name="tei-lb" select="preceding::tei:lb[@type = 'sylvaline'][position() = 1]/@n"/>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates mode="add-lb"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- What to do with non-rendered elements: process children (elements) or ignore (others) -->
    <xsl:template match="tei:*">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" mode="#default find-lbs"/>

    <!-- Copy everything templates (NOT for elements) -->

    <xsl:template match="@*" mode="copy">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()" mode="copy">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
