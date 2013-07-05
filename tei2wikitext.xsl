<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

<xsl:output method="html" indent="no" encoding="utf-8"/>
  <xsl:param name="spaceCharacter">&#160;</xsl:param>

<xsl:template match="text()">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="tei:TEI">
  <xsl:apply-templates select="tei:text/*"/>
</xsl:template>

<xsl:template match="tei:abbr">
  <abbr>
    <xsl:apply-templates select="@*|*|text()"/>
  </abbr>
</xsl:template>

<xsl:template match="tei:anchor">
  <span>
    <xsl:apply-templates select="@*|*|text()"/>
  </span>
</xsl:template>

<xsl:template match="tei:att|tei:gi|tei:ident">
  <code>
    <xsl:apply-templates select="@*|*|text()"/>
  </code>
</xsl:template>

<xsl:template match="tei:author">
  <xsl:apply-templates select="@*|*|text()"/>
</xsl:template>

<xsl:template match="tei:cell">
  <td>
    <xsl:apply-templates select="@*|*|text()"/>
  </td>
</xsl:template>

<xsl:template match="tei:code">
  <source lang="{@lang}">
    <xsl:apply-templates select="@*|*|text()"/>
  </source>
</xsl:template>

<xsl:template match="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6">
  <xsl:apply-templates select="@*|*|text()"/>
</xsl:template>

<xsl:template match="tei:eg">
  <pre>
    <xsl:apply-templates select="@*|*|text()"/>
  </pre>
</xsl:template>

<xsl:template match="tei:emph|tei:hi">
  <xsl:choose>
    <xsl:when test="@rend = 'italic'">
      <xsl:text>''</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>''</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>'''</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>'''</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:figure"><!-- TODO generate thumb-->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:foreign">
  <span><!-- TODO -->
    <xsl:apply-templates select="@*|*|text()"/>
  </span>
</xsl:template>

<xsl:template match="tei:graphic">
  <xsl:text>[[File:</xsl:text>
  <xsl:value-of select="@url"/>
  <xsl:for-each select="tei:desc">
     <xsl:text>|</xsl:text>
     <xsl:call-template name="noP"/>
  </xsl:for-each>
  <xsl:text>]]</xsl:text>
</xsl:template>

<xsl:template match="tei:head|tei:title"><!-- TODO -->
  <xsl:text>&#xA;== </xsl:text>
  <xsl:call-template name="noP"/>
  <xsl:text> ==</xsl:text>
</xsl:template>

<xsl:template match="tei:item">
  <xsl:text>&#xA;* </xsl:text>
  <xsl:call-template name="noP"/>
</xsl:template>

<xsl:template match="tei:list">
  <xsl:choose>
    <xsl:when test="@type = 'gloss'">
      <xsl:for-each select="tei:label">
        <xsl:text>&#xA;; </xsl:text>
        <xsl:apply-templates select="@*|*|text()"/>
        <xsl:for-each select="following-sibling::tei:item[1]">
          <xsl:text>&#xA;: </xsl:text>
          <xsl:call-template name="noP"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="@type = 'ordered'">
      <xsl:for-each select="tei:head">
        <xsl:text>&#xA;==== </xsl:text>
        <xsl:call-template name="noP"/>
        <xsl:text> ====</xsl:text>
      </xsl:for-each>
      <xsl:for-each select="tei:item">
        <xsl:text>&#xA;# </xsl:text>
        <xsl:call-template name="noP"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="tei:head">
        <xsl:text>&#xA;==== </xsl:text>
        <xsl:call-template name="noP"/>
        <xsl:text> ====</xsl:text>
      </xsl:for-each>
      <xsl:for-each select="tei:item">
        <xsl:text>&#xA;* </xsl:text>
        <xsl:call-template name="noP"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:note[@place = 'foot']">
  <ref>
    <xsl:call-template name="noP"/>
  </ref>
</xsl:template>

<xsl:template match="tei:p">
  <xsl:text>&#xA;</xsl:text>
  <xsl:apply-templates select="@*|*|text()"/>
</xsl:template>

<xsl:template match="tei:q|tei:quote|tei:said">
  <xsl:choose>
    <xsl:when test="@rend = 'block'">
	<blockquote>
      <xsl:apply-templates select="@*|*|text()"/>
	</blockquote>
    </xsl:when>
    <xsl:otherwise>
	<q>
      <xsl:apply-templates select="@*|*|text()"/>
	</q>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:ref|tei:ptr">
  <xsl:choose>
    <xsl:when test="contains(@target, '/')">
         <xsl:text>[</xsl:text>
       <xsl:value-of select="@target"/>
       <xsl:text> </xsl:text>
       <xsl:call-template name="noP"/>
       <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
       <xsl:text>[[#</xsl:text>
       <xsl:value-of select="@target"/>
       <xsl:text>|</xsl:text>
       <xsl:call-template name="noP"/>
       <xsl:text>]]</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:row">
  <tr>
    <xsl:apply-templates select="@*|*|text()"/>
  </tr>
</xsl:template>

<xsl:template match="tei:table"> <!-- TODO -->
  <table>
    <xsl:for-each select="tei:head">
      <caption>
        <xsl:call-template name="noP"/>
      </caption>
    </xsl:for-each>
    <xsl:if test="tei:row[@role='label']">
      <thead>
        <xsl:apply-templates select="tei:row[@role='label']"/>
      </thead>
    </xsl:if>
    <xsl:apply-templates select="tei:row[not(@role='label')]"/>
  </table>
</xsl:template>

<xsl:template match="tei:surname|tei:forename|tei:back|tei:body|tei:front|tei:tbody|tei:tgroup|tei:s">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="tei:whatsTheDate">
  <xsl:value-of select="format-dateTime(current-dateTime(),'[Y]-[M02]-[D02]T[H02]:[m02]:[s02]Z')"/>
</xsl:template>

<xsl:template name="noP">
  <xsl:for-each select="@*|*|text()">
    <xsl:choose>
      <xsl:when test="name() = 'p'">
        <xsl:apply-templates select="@*|*|text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*">
  <xsl:message>Unknown element <xsl:value-of select="name()"/></xsl:message>
  <xsl:element name="{name()}">
    <xsl:apply-templates select="@*|*|text()"/>
  </xsl:element>
</xsl:template>

<!-- attributes -->
<xsl:template match="@xml:lang">
  <xsl:attribute name="lang">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="@xml:id">
  <xsl:attribute name="id">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="@style">
  <xsl:attribute name="style">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="@*"/>
</xsl:stylesheet>
