<?xml version="1.0" encoding="UTF-8"?>
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
                        <xsl:when test="//tei:text/@id-cormetaf">
                            <xsl:value-of select="//tei:text[1]/@id-cormetaf"/>
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
        <!-- Adapted from default TXM stylesheet -->
        <body>
            <!-- a class="txm-page" title="1" next-word-id="w_0"/ -->
            <div class="txmeditionpage">
                <h1>
                    <xsl:value-of select="@id-cormetaf"/>
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
                <xsl:apply-templates/>
            </div>

        </body>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <!-- The CorMetAF uses div type="chapter" to split up different
        pieces in a text. Use h2 if there's a heading. -->
        <xsl:if test="@type = 'chapter' and tei:head">
            <h2>
                <xsl:apply-templates select="tei:head"/>
            </h2>
        </xsl:if>
        <xsl:apply-templates select="node()[not(self::tei:head)]"/>
    </xsl:template>
    
    <xsl:template match="tei:docTitle">
        <!-- Used in Sponsus, use <h1> -->
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <!-- Theatre texts -->
    
    <xsl:template match="tei:speaker">
        <!-- Encode speaker as h3. Will always be within <sp>, outside <lg> (TEI guidelines). -->
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:variable name="this-ab" select="."/>
        <!-- Add language attribute and class from parent element to table -->
        <xsl:element name="table">
            <xsl:if test="@lang">
                <xsl:attribute name="lang" select="@lang"/>
            </xsl:if>
            <xsl:attribute name="class" select="./parent::node()/local-name()"/>
            <tr>
                <th/>
                <th>
                    <xsl:element name="span">
                        <xsl:attribute name="title">
                            <xsl:apply-templates select="@*[not(name() = 'n')]" mode="title-string"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="@n"/>
                    </xsl:element>
                    <!-- Add heading if there is one -->
                    <xsl:apply-templates select="tei:head"/>
                </th>
            </tr>
            <!-- Everything except "head" -->
            <xsl:apply-templates select="tei:*[local-name()!='head']"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:l">
        <xsl:variable name="lineno" select="@n"/>
        <tr>
            <td class="lineno">
                <xsl:choose>
                    <xsl:when test="ends-with(@n, '0') or ends-with(@n, '5')">
                        <xsl:value-of select="@n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <xsl:element name="td">
                <xsl:attribute name="class">l</xsl:attribute>
                <xsl:if test="@lang">
                    <xsl:attribute name="lang" select="@lang"/>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <!-- lb elements are important if the text has no abs or ls.
        SylVA automatically adds "lb type="sylvaline" iff there's no
        markup in the CSV. So we'll treat these much like l elements,
        except there's no table to insert them into. We'll span them.
        -->
        <xsl:if test="@type='sylvaline'">
            <!-- HTML br/ element -->
            <xsl:element name="br"/>
            <!-- Span for lineno -->
            <xsl:element name="span">
                <xsl:attribute name="class">lineno</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="ends-with(@n, '0') or ends-with(@n, '5')">
                        <xsl:value-of select="concat(@n, substring('&#xa0;&#xa0;&#xa0;&#xa0;', 1, 4 - string-length(@n)))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#xa0;&#xa0;&#xa0;&#xa0;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:secl">
        <!-- Text which is out of place and ASSUMED not to be included in a table for verse -->
        <div class="secl">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Lists -->
    
    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="@type='label'">
                <dl>
                    <xsl:apply-templates mode="dl"/>
                </dl>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates mode="ul"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:label" mode="dl">
        <dt><xsl:apply-templates/></dt>
    </xsl:template>
    
    <xsl:template match="tei:label" mode="ul">
        <!-- This template shouldn't be called; turns labels into separate lis -->
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="tei:item" mode="dl">
        <dd><xsl:apply-templates/></dd>
    </xsl:template>
    
    <xsl:template match="tei:item" mode="ul">
        <li><xsl:apply-templates/></li>
    </xsl:template>


    <!--Render TEI elements -->

    <xsl:template match="tei:w">
        <xsl:element name="span">
            <xsl:attribute name="id" select="@id"/>
            <xsl:attribute name="class">w</xsl:attribute>
            <!-- Place in italics any word whose lang tag does not correspond to the 
                language of the closest ancestor node with a lang specification.-->
            <xsl:if test="txm:ana[@type = '#lang']/text() != ./ancestor::node()[@lang != ''][position()=1]/@lang">
                <xsl:attribute name="style">font-style: italic;</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="title">
                <xsl:apply-templates
                    select="txm:ana[@type = ('#pos', '#lemma', '#prosody', '#metpos', '#soptem', '#counted_syllables')]"
                    mode="title-string"/>
            </xsl:attribute>
            <xsl:value-of select="txm:form"/>
        </xsl:element>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="txm:ana" mode="title-string">
        <xsl:value-of select="substring(@type, 2)"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:if test="not(position() = last())">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*" mode="title-string">
        <!-- For <ab> properties -->
        <xsl:value-of select="name()"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:if test="not(position() = last())">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:pb | tei:cb">
        <xsl:element name="span">
            <xsl:attribute name="class">milestone</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@facs">
                    <!-- Deactivated link <a href="{@facs}"> -->
                        <xsl:apply-templates select="." mode="string"/>
                    <!-- Deactivated link </a> -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:pb" mode="string">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="tei:ab|tei:p">
        <!-- Turn ps and abs into an HTML p; add xml:lang if present; class inherited from parent element -->
        <xsl:element name="p">
            <xsl:if test="@lang">
                <xsl:attribute name="lang" select="@lang"/>
            </xsl:if>
            <xsl:attribute name="class" select="./parent::node()/local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:gap|tei:supplied">
        <xsl:element name="span">
            <!-- Material marked as "supplied" -->
            <xsl:attribute name="class">supplied</xsl:attribute>
            <xsl:attribute name="title">missing or reconstructed section of text not included in corpus tokens</xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:choose>
                <xsl:when test="local-name()='gap' and @unit = 'line'">
                    <xsl:text>............................</xsl:text>
                </xsl:when>
                <xsl:when test="local-name()='gap'">
                    <xsl:text>...</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:surplus">
        <!-- Don't print -->
    </xsl:template>
    
    <xsl:template match="tei:*">
        <xsl:choose>
            <xsl:when test="not(descendant::tei:lg or descendant::tei:ab or descendant::tei:p)">
                <!-- Spans if it doesn't contain abs, lgs or ps.-->
                <xsl:element name="span">
                    <xsl:attribute name="class" select="local-name()"/>
                    <xsl:if test="@lang">
                        <xsl:attribute name="lang" select="@lang"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- Use a div -->
                <xsl:element name="div">
                    <xsl:attribute name="class" select="local-name()"/>
                    <xsl:if test="@lang">
                        <xsl:attribute name="lang" select="@lang"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="local-name() = 's' and ancestor::tei:p">
            <!-- Print a slash at the end of a sentence in prose texts -->
            <xsl:text>/ </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Copy everything templates (NOT for elements) -->

   
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
