<?xml version="1.0" encoding="iso-8859-1"?>
  
  
  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" indent="yes" />
  
  <xsl:template match="/">
    <Project xmlns="http://schemas.microsoft.com/project">
      <Name>Project1</Name>
      <Author>Freemind2MSProject Conversor</Author>
      <Tasks>
        <Task>
          <UID>0</UID>
          <ID>0</ID>
          <Type>1</Type>
          <IsNull>0</IsNull>
          <WBS>0</WBS>
          <OutlineNumber>0</OutlineNumber>
          <OutlineLevel>0</OutlineLevel>
          <FixedCostAccrual>3</FixedCostAccrual>
          <RemainingDuration>PT8H0M0S</RemainingDuration>
        </Task>
  
        <xsl:apply-templates select="map/node" />
      </Tasks>
    </Project>   
  </xsl:template>
  
  <xsl:template match="node">
    <xsl:variable name="outlineLevel" select="(count(ancestor::node())-1)"/>
  
    <Task>
      <UID>1</UID>
      <ID>1</ID>
      <Name><xsl:value-of select="@TEXT"/></Name>
      <Type>1</Type>
      <IsNull>0</IsNull>
      <OutlineNumber>1</OutlineNumber>
      <OutlineLevel><xsl:value-of select="$outlineLevel"/></OutlineLevel>
      <FixedCostAccrual>3</FixedCostAccrual>
      <RemainingDuration>PT8H0M0S</RemainingDuration>
    </Task>
  
    <xsl:apply-templates select="node"/>
  </xsl:template>
    
  </xsl:stylesheet>