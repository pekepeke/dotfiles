<!--
Written by Michael Kefeder 2004 (a.k.a. HTD at http://www.weird-birds.org/)

Transforms GANTT charts created by http://ganttproject.sf.net/ to SVG images

Stylesheet needs date extensions available at 
http://www.exslt.org/
-->
<!--
Hacked by Hideki Suzuki 2010 (hidehide55 http://www.hatena.ne.jp/hidehide55)
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:date="http://exslt.org/dates-and-times"
		extension-element-prefixes="date">
	<!--<xsl:import href="date/date.xsl" />-->
	<xsl:output method="xml"/>

<!-- parameters -->
	<xsl:param name="day_width">15</xsl:param>
	<xsl:param name="task_height">15</xsl:param>
	<xsl:param name="offset_top">30</xsl:param>
	<xsl:param name="show_progress">1</xsl:param>
	<xsl:param name="use_pattern">0</xsl:param>
	<xsl:param name="text_style">font-family: meiryo;font-size: 10;fill: Black;</xsl:param>
	<xsl:param name="text_style_sun">font-family: meiryo;font-size: 10;fill: Red;</xsl:param>
	<xsl:param name="text_style_sat">font-family: meiryo;font-size: 10;fill: Blue;</xsl:param>

	<xsl:variable name="img_width_temp">
		<xsl:call-template name="getDateDiffWidth">
			<xsl:with-param name="start">
				<xsl:call-template name="gandate2isodate">
					<xsl:with-param name="gandate" select="string(/project/@view-date)"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="end">
				<xsl:call-template name="getLastDay"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="img_width" select="$img_width_temp + $day_width * 10"/>
	<xsl:variable name="img_height" select="$offset_top + count(/project/tasks/descendant::task) * ($task_height + 3)"/>
	
<!-- ROOT -->
	<xsl:template match="/">
		<svg id="svg-root" width="{$img_width}" height="{$img_height}">
		<!--
		<defs>
			<pattern id="pattern" x="0" y="0" width="{$day_width*2}" height="1" patternUnits="userSpaceOnUse">
				<rect x="{$day_width}" y="0" width="{$day_width}" height="{$img_height}" fill="#CCccCC"/>
				<rect x="{$day_width}" y="0" width="{$day_width}" height="{$img_height}" fill="#EEeeEE"/>
			</pattern>
		</defs>
		-->
			<xsl:call-template name="createCalender"/>
			
			<xsl:call-template name="createTaskView"/>
		</svg>
	</xsl:template>

<!-- TASK -->
	<xsl:template name="createTaskView">
		<xsl:param name="parent" select="/project/tasks"/>
		<xsl:param name="line" select="number(0)"/>

		<xsl:if test="count($parent/task) &gt; 0">
		<xsl:for-each select="$parent/task">
			<xsl:variable name="length" select="@duration * $day_width"/>
			<xsl:variable name="percent" select="$length div 100 * @complete"/>
			<xsl:variable name="ypos" select="$offset_top + (count(preceding::task) + $line) * ($task_height + 3)"/>
			<xsl:variable name="x_offset">
				<xsl:call-template name="getDateDiffWidth">
					<xsl:with-param name="start">
						<xsl:call-template name="gandate2isodate">
							<xsl:with-param name="gandate" select="string(/project/@view-date)"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="end">
						<xsl:call-template name="gandate2isodate">
							<xsl:with-param name="gandate" select="@start"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<g>
			<!-- ***************************************************** -->
			<xsl:if test="count(./depend) &gt; 0">
				<xsl:for-each select="./depend">
					<xsl:call-template name="drawDependLine">
						<xsl:with-param name="dependId" select="@id"/>
						<xsl:with-param name="x1" select="$x_offset + $length"/>
						<xsl:with-param name="y1" select="$ypos + ($task_height div 2)"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<!-- ***************************************************** -->
			<xsl:choose>
				<xsl:when test="count(./task) = 0">
					<rect x="{$x_offset}" y="{$ypos}" width="{$length}" height="{$task_height}" style="fill:{@color};stroke:#000000;"/>
				</xsl:when>
				<xsl:otherwise>
					<rect x="{$x_offset}" y="{$ypos}" width="{$length}" height="3" style="fill:#666666;stroke:#666666;"/>
					<rect x="{$x_offset}" y="{$ypos}" width="3" height="{$task_height}" style="fill:#666666;stroke:#666666;"/>
					<rect x="{$x_offset + $length - 3}" y="{$ypos}" width="3" height="{$task_height}" style="fill:#666666;stroke:#666666;"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
			<xsl:when test="$show_progress != 0">
				<rect x="{$x_offset}" y="{$ypos}" width="{$percent}" height="{$task_height}" style="fill:#DDDDDD;stroke:none;"/>
				<text x="{$x_offset+2}" y="{$ypos + 12}" style="{$text_style}"><xsl:value-of select="concat (@name, ' (', @complete,'%)')"/></text>
			</xsl:when>
			<xsl:otherwise>
				<text x="{$x_offset+2}" y="{$ypos + 12}" style="{$text_style}"><xsl:value-of select="@name"/></text>
			</xsl:otherwise>
			</xsl:choose>
			</g>
			<xsl:call-template name="createTaskView">
				<xsl:with-param name="parent" select="."/>
				<xsl:with-param name="line" select="$line+1"/>
			</xsl:call-template>
		</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!-- ***************************************************** -->
	<xsl:template name="drawDependLine">
		<xsl:param name="parent" select="/project/tasks"/>
		<xsl:param name="line" select="number(0)"/>
		<xsl:param name="dependId" select="number(0)"/>
		<xsl:param name="x1" select="number(0)"/>
		<xsl:param name="y1" select="number(0)"/>

		<xsl:if test="count($parent/task) &gt; 0">
			<xsl:for-each select="$parent/task">
				<xsl:if test="@id = $dependId">

					<xsl:variable name="ypos" select="$offset_top + (count(preceding::task) + $line) * ($task_height + 3)"/>
					<xsl:variable name="x_offset">
						<xsl:call-template name="getDateDiffWidth">
							<xsl:with-param name="start">
								<xsl:call-template name="gandate2isodate">
									<xsl:with-param name="gandate" select="string(/project/@view-date)"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="end">
								<xsl:call-template name="gandate2isodate">
									<xsl:with-param name="gandate" select="@start"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="x2" select="$x_offset"/>
					<xsl:variable name="y2" select="$ypos"/>

					<polyline fill="none" stroke="#666666" stroke-width="1"
						points="{$x1},{$y1} {$x2},{$y1} {$x2},{$y2}"/>
					<polyline fill="none" stroke="#666666" stroke-width="1"
						points="{$x2 - 2},{$y2 - 5} {$x2},{$y2} {$x2 + 2},{$y2 - 5}"/>

				</xsl:if>
				<xsl:call-template name="drawDependLine">
					<xsl:with-param name="parent" select="."/>
					<xsl:with-param name="line" select="$line+1"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- ***************************************************** -->

<!-- CALENDER -->
	<xsl:template name="createCalender">
		<!-- background (patterns not supported by most opensource SVG render tools) -->
		<xsl:if test="$use_pattern != 0">
			<rect x="0" y="0" width="{$img_width}" height="{$img_height}" fill="url(#pattern)"/>
		</xsl:if>
		<xsl:if test="$use_pattern = 0">
			<xsl:call-template name="createCalenderBackground"/>
		</xsl:if>
		<!-- dates -->
		<g id="calenderdates">
		<xsl:call-template name="createCalenderDates">
			<xsl:with-param name="day" select="number(0)"/>
			<xsl:with-param name="start_date">
			<xsl:call-template name="gandate2isodate">
				<xsl:with-param name="gandate" select="string(/project/@view-date)"/>
			</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
		</g>
	</xsl:template>

<!-- Dates -->
	<xsl:template name="createCalenderBackground">
		<xsl:param name="day">0</xsl:param>
		
		
		<!-- end recursion -->
		<xsl:if test="$day*$day_width &lt; $img_width">
		<xsl:choose>
		<xsl:when test="$day mod 2 = 1">
			<rect x="{$day*$day_width}" y="0" width="{$day_width}" height="{$img_height}" fill="#CCccCC"/>
		</xsl:when>
		<xsl:otherwise>
			<rect x="{$day*$day_width}" y="0" width="{$day_width}" height="{$img_height}" fill="#EEeeEE"/>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="createCalenderBackground">
			<xsl:with-param name="day" select="number($day + 1)"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>

<!-- Dates -->
	<xsl:template name="createCalenderDates">
		<xsl:param name="day">0</xsl:param>
		<xsl:param name="start_date">2004-01-01</xsl:param>
		<xsl:param name="cur_month">0</xsl:param>
		
		<!-- end recursion -->
		<xsl:if test="$day*$day_width &lt; $img_width">
		<xsl:variable name="newdate" select="date:add($start_date, concat('P', $day, 'D'))"/>
		<xsl:variable name="newmonth" select="date:month-name(string($newdate))"/>

		<xsl:if test="$cur_month != $newmonth">
			<text x="{$day*$day_width}" y="12" style="{$text_style}"><xsl:value-of select="$newmonth"/></text>
		</xsl:if>

		<xsl:element name="text">
			<xsl:attribute name="x"><xsl:value-of select="$day*$day_width + $day_width div 2"/></xsl:attribute>
			<xsl:attribute name="y">24</xsl:attribute>
			<xsl:attribute name="text-anchor">middle</xsl:attribute>
			<xsl:attribute name="style">
			<xsl:choose>
				<xsl:when test="date:day-in-week($newdate) = 1">
					<xsl:value-of select="$text_style_sun"/>
				</xsl:when>
				<xsl:when test="date:day-in-week($newdate) = 7">
					<xsl:value-of select="$text_style_sat"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text_style"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="date:day-in-month(string($newdate))"/>
		</xsl:element>
		<xsl:call-template name="createCalenderDates">
			<xsl:with-param name="day" select="number($day + 1)"/>
			<xsl:with-param name="start_date" select="$start_date"/>
			<xsl:with-param name="cur_month" select="$newmonth"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
<!-- GANTTproject Date-format to ISO-conform date -->
	<xsl:template name="gandate2isodate">
		<xsl:param name="gandate"/>
		<xsl:param name="isodate"/>
		
		<xsl:variable name="part" select="substring-before($gandate, '/')"/>

		<!-- end recursion -->
		<xsl:choose>
		<xsl:when test="string-length($part) != 0">
			<xsl:choose>
			<xsl:when test="string-length($part) = 1">
				<xsl:variable name="newisodate" select="concat ('-', '0', $part, $isodate)"/>
				<xsl:call-template name="gandate2isodate">
					<xsl:with-param name="gandate" select="substring-after($gandate, '/')"/>
					<xsl:with-param name="isodate" select="string($newisodate)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="newisodate" select="concat ('-', $part, $isodate)"/>
				<xsl:call-template name="gandate2isodate">
					<xsl:with-param name="gandate" select="substring-after($gandate, '/')"/>
					<xsl:with-param name="isodate" select="string($newisodate)"/>
				</xsl:call-template>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat ($gandate, $isodate)"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- calculate total duration in Days 
	this template adds @start and @duration of the root tasks 
	and returns the highest date found
-->
	<xsl:template name="getLastDay">
		<xsl:param name="elem" select="/project/tasks/task"/>
		<xsl:param name="max_date" select="string('1980-01-01')"/>
		<!--<xsl:for-each select="/project/tasks/task">-->

			<xsl:variable name="prj_start_date">
				<xsl:call-template name="gandate2isodate">
					<xsl:with-param name="gandate" select="string($elem/@start)"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="cur_date" select="date:add($prj_start_date, concat('P', $elem/@duration, 'D'))"/>

			<xsl:variable name="date_diff" select="date:difference(string($cur_date), string($max_date))"/>
			<xsl:choose>
			<!-- stop recursion -->
			<xsl:when test="count ($elem/following::*) = 0 and substring ($date_diff, 1, 1) != '-'">
				<xsl:value-of select="string($max_date)"/>
			</xsl:when>
			<xsl:when test="count ($elem/following::*) = 0">
				<xsl:value-of select="string($cur_date)"/>
			</xsl:when>
			<!-- find max -->
			<xsl:when test="substring ($date_diff, 1, 1) = '-'">
				<xsl:call-template name="getLastDay">
					<xsl:with-param name="elem" select="$elem/following::task" />
					<xsl:with-param name="max_date" select="string($cur_date)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getLastDay">
					<xsl:with-param name="elem" select="$elem/following::task" />
					<xsl:with-param name="max_date" select="string($max_date)" />
				</xsl:call-template>
			</xsl:otherwise>
			</xsl:choose>
		<!--</xsl:for-each>-->
	</xsl:template>
<!-- Width from start to end date -->
	<xsl:template name="getDateDiffWidth">
		<xsl:param name="start"/>
		<xsl:param name="end"/>
		
		<xsl:variable name="date_diff" select="date:difference(string($start), string($end))"/>
		<xsl:variable name="diff_days" select="number(substring-before(substring-after($date_diff,'P'), 'D'))"/>
		<xsl:value-of select="$diff_days*$day_width"/>
	</xsl:template>
</xsl:stylesheet>

