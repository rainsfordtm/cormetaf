<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:txm="http://textometrie.org/1.0" exclude-result-prefixes="tei" version="2.0">

    <xsl:output indent="yes"/>

    <xsl:param name="use-verse-lines">true</xsl:param>
    
    <!-- This parameter sets the names of the word ana attributes to include the TXM corpus -->
    <xsl:param name="word-anas">line_id lemma pos pos_nca syntag2 ref prosody metpos soptem counted_syllables syllabified line_met</xsl:param>

    <xsl:template match="/*">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:txm="http://textometrie.org/1.0">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>

    <xsl:template match="tei:standOff | tei:pc"/>
    <!-- Ditch the standoff annotation, the TEI header and ALL children and the TEI node, which is being duplicated-->

    <xsl:template match="tei:teiHeader">
        <xsl:copy/> <!--Leaves the element, removes the contents which is not correctly parsed by TXM. -->
    </xsl:template>
    
    
    <xsl:template match="tei:c | tei:seg">
        <!-- Ditch c and seg elements and their attributes, keeping only children -->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:w">
        <!-- Convert ana to separate attrs-->
        <xsl:element name="w" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="@xml:id"/>
            <xsl:apply-templates select="@*[local-name() != 'id']"/>
                <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@xml:id">
        <!-- Swap TEI compliant "xml:id" for a simple id -->
        <xsl:attribute name="id" select="."/>
    </xsl:template>

    <xsl:template match="@ana">
        <xsl:variable name="anas" select="tokenize(., ' ')"/>
        <xsl:variable name="parent" select="parent::node()/local-name()"/>
        <xsl:for-each select="$anas">
            <xsl:choose>
                <xsl:when test="substring-before(., '£')='#ref'">
                    <!-- Reinstates spaces in the ref attribute -->
                    <xsl:attribute name="ref" select="replace(substring-after(., '£'), '_', ' ')"/>
                </xsl:when>
                <xsl:when test="$parent='w' and not(contains($word-anas, substring(substring-before(., '£'),2)))">
                    <!-- This is a word-level annotation we do not want to export, so do nothing -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{substring(substring-before(., '£'),2)}" select="substring-after(., '£')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@join">
        <!-- Renames join attribute (reserved CQP name) -->
        <xsl:attribute name="tei-join" select="."/>
    </xsl:template>
    
    <xsl:template match="@msd">
        <!-- Removes @msd attribute (duplicate of @morph in @ana) -->
    </xsl:template>
    
    <!-- Copy everything templates -->

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
