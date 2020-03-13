<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />

	<!-- Basis  v1
		XSLT for BLOCKS in MailingLijst-templates
		(c) EM-Cultuur, 2020
		-->

	<!-- CONFIGS -->
	<!--
	The widths have to be defined here because it needs to be defined in two attributes: STYLE and WIDTH
	Outlooks uses the WITH attribute and all other e-mail clients uses STYLE attribute.
	This widths are used for images and main tables.
	-->
	<xsl:variable name="width_13">216</xsl:variable>
	<xsl:variable name="width_12">337</xsl:variable>
	<xsl:variable name="width_23">458</xsl:variable>
	<xsl:variable name="width_full">700</xsl:variable>

	<!-- TEXTS -->
	<xsl:variable name="button1_text">Lees meer</xsl:variable>
	<xsl:variable name="button2_text">Koop kaarten</xsl:variable>
	<xsl:variable name="agenda_header_text">Agenda</xsl:variable>

	<xsl:variable name="date_day_0">zo </xsl:variable>
	<xsl:variable name="date_day_1">ma </xsl:variable>
	<xsl:variable name="date_day_2">di </xsl:variable>
	<xsl:variable name="date_day_3">wo </xsl:variable>
	<xsl:variable name="date_day_4">do </xsl:variable>
	<xsl:variable name="date_day_5">vr </xsl:variable>
	<xsl:variable name="date_day_6">za </xsl:variable>

	<xsl:variable name="date_month_1">jan </xsl:variable>
	<xsl:variable name="date_month_2">feb </xsl:variable>
	<xsl:variable name="date_month_3">mrt </xsl:variable>
	<xsl:variable name="date_month_4">apr </xsl:variable>
	<xsl:variable name="date_month_5">mei </xsl:variable>
	<xsl:variable name="date_month_6">jun </xsl:variable>
	<xsl:variable name="date_month_7">jul </xsl:variable>
	<xsl:variable name="date_month_8">aug </xsl:variable>
	<xsl:variable name="date_month_9">sep </xsl:variable>
	<xsl:variable name="date_month_10">okt </xsl:variable>
	<xsl:variable name="date_month_11">nov </xsl:variable>
	<xsl:variable name="date_month_12">dec </xsl:variable>

	<xsl:template match="/">

		<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="tblMain">

			<!-- Loop through items with stylenames starting with 'Item' -->
			<xsl:for-each select="matches/match[contains(style, 'Item')]">

				<!-- Basic widths of blocks, the widths below are based on basic and ideal width of 700px -->
				<xsl:variable name="width">
					<xsl:choose>
						<xsl:when test="contains(style, '1/2')"><xsl:value-of select="$width_12" /></xsl:when>
						<xsl:when test="contains(style, '1/3')"><xsl:value-of select="$width_13" /></xsl:when>
						<xsl:when test="contains(style, '2/3')"><xsl:value-of select="$width_23" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$width_full" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Start rule for each block, determine it on the position or rule_end of previous item -->
				<xsl:if test="position() = 1 or preceding-sibling::*[1]/rule_end = 'true'">
					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
				</xsl:if>

				<xsl:if test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (position() = 1 or preceding-sibling::*[1]/rule_end = 'true')">
					<xsl:text disable-output-escaping="yes"><![CDATA[<td><table cellpadding="0" cellspacing="0"><tr><td class="contentBlockContainer"><table cellpadding="0" cellspacing="0"><tr>]]></xsl:text>
				</xsl:if>

				<!-- Basic block -->
				<td>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">contentMainBlock</xsl:when>
							<xsl:otherwise>contentMainBlockItem</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>

					<table cellpadding="0" cellspacing="0" class="contentMainTable">
						<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
						<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;</xsl:attribute>
						<tr>
							<td>
								<xsl:attribute name="class">contentInnerContainer</xsl:attribute>
								<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>

								<!-- The data attributes are used for in contentblocks editor -->
								<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%" class="emItem emEditable emMoveable">
									<xsl:attribute name="data-sort"><xsl:value-of select="sort_on" /></xsl:attribute>
									<xsl:attribute name="data-ID"><xsl:value-of select="merge_ID"/></xsl:attribute>
									<xsl:attribute name="data-last">
										<xsl:choose>
											<xsl:when test="position() = last()">true</xsl:when>
											<xsl:otherwise>false</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="data-first">
										<xsl:choose>
											<xsl:when test="position() = 1">true</xsl:when>
											<xsl:otherwise>false</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<!-- Image above
									When a placeholder is used, then this item is created automatically after a new mailing is created
									The default placeholder is a square so 700x700 don't looks fancy... -->
									<xsl:if test="image != ''">
										<tr>
											<td class="contentImage">
												<xsl:choose>
													<xsl:when test="url != ''">
														<a target="_blank">
															<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
															<img border="0">
																<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
																<xsl:attribute name="style">display: block; width: <xsl:value-of select="$width" />px;</xsl:attribute>
																<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																<xsl:attribute name="src">
																	<xsl:choose>
																		<xsl:when test="contains(image, 'placeholder.png')">http://www.mailinglijst.nl/images/2014/placeholder_wide.png</xsl:when>
																		<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
															</img>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<img>
															<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
															<xsl:attribute name="style">display: block; width: <xsl:value-of select="$width" />px;</xsl:attribute>
															<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
															<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
															<xsl:attribute name="src">
																<xsl:choose>
																	<xsl:when test="contains(image, 'placeholder.png')">http://www.mailinglijst.nl/images/2014/placeholder_wide.png</xsl:when>
																	<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
														</img>
													</xsl:otherwise>
												</xsl:choose>

												<xsl:if test="extra2 != ''">
													<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
														<tr>
															<td class="contentImageSubtitle">
																<xsl:value-of select="extra2" />
															</td>
														</tr>
													</table>
												</xsl:if>
											</td>
										</tr>
									</xsl:if>

									<!-- Content and buttons container -->
									<tr>
										<td>

											<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
												<tr>
													<!-- BLOCK CONTENT (title, subtitle, date) with text and buttons -->
													<td class="contentInnerBlock" style="vertical-align: top;">

														<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

															<!-- Hide entire title part when Item (zonder titel) style is used of NOTITLE in the title field is filled (case sensitive!!) -->
															<xsl:if test="not(contains(style, 'zonder titel')) and not(contains(title, 'NOTITLE'))">

																<!-- Title -->
																<tr>
																	<td class="contentCaption">
																		<xsl:choose>
																			<xsl:when test="contains(style, '1/3')">
																				<h3><xsl:value-of select="title" disable-output-escaping="yes" /></h3>
																			</xsl:when>
																			<xsl:otherwise>
																				<h2><xsl:value-of select="title" disable-output-escaping="yes" /></h2>
																			</xsl:otherwise>
																		</xsl:choose>
																	</td>
																</tr>

																<!-- Subtitle (DB field = location) -->
																<xsl:if test="location != ''">
																	<tr>
																		<td class="contentSubtitle">
																			<h4><xsl:value-of select="location" disable-output-escaping="yes" /></h4>
																		</td>
																	</tr>
																</xsl:if>

																<!-- Date -->
																<xsl:if test="not(contains(display_playdate_start, '1 januari 2000')) or icon != ''">
																	<tr>
																		<td class="contentDate">
																			<xsl:call-template name="date_subtitle">
																				<xsl:with-param name="row" select="." />
																			</xsl:call-template>
																		</td>
																	</tr>
																</xsl:if>

															</xsl:if>

															<!-- Content -->
															<tr>
																<td class="content">
																	<xsl:value-of select="content" disable-output-escaping="yes" />
																</td>
															</tr>

															<!-- Two buttons for mobile version
															image_alt DB field is used as alternative button text ('1e veld' name in ML)
															icon2 DB field is used as alternative button text for second button
															When 1/3 style is used, seperate two buttons into two rules -->
															<xsl:if test="(url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON')))">
																<tr class="contentMobileButtonContainer" style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">
																	<td class="contentMobileButtonBlock">

																		<table cellpadding="0" cellspacing="0" class="contentMobileInnerContainer" style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">
																			<!-- Button 1 -->
																			<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON'))">
																				<xsl:if test="contains(style, '1/3')">
																					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
																				</xsl:if>
																				<td class="contentButtonBlock">
																					<xsl:attribute name="style">
																						<xsl:choose>
																							<xsl:when test="url2 != '' and not(contains(style, '1/3')) and not(contains(icon2, 'NOBUTTON'))">padding-right: 15px;</xsl:when>
																							<xsl:otherwise>padding-right: 0px;</xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<xsl:call-template name="button">
																						<xsl:with-param name="url" select="details_url" />
																						<xsl:with-param name="button_text" select="image_alt" />
																						<xsl:with-param name="button_default_text" select="$button1_text" />
																						<xsl:with-param name="class">contentButton</xsl:with-param>
																					</xsl:call-template>

																				</td>
																				<xsl:if test="contains(style, '1/3')">
																					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
																				</xsl:if>
																			</xsl:if>

																			<!-- Button 2 -->
																			<xsl:if test="url2 != ''">
																				<xsl:if test="contains(style, '1/3')">
																					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
																				</xsl:if>
																				<td class="contentButtonBlock">
																					<xsl:attribute name="style">
																						<xsl:choose>
																							<xsl:when test="contains(style, '1/3')">padding-top: 10px;</xsl:when>
																							<xsl:otherwise>padding-top: 0px;</xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<xsl:call-template name="button">
																						<xsl:with-param name="url" select="details_url2" />
																						<xsl:with-param name="button_text" select="icon2" />
																						<xsl:with-param name="button_default_text" select="$button2_text" />
																						<xsl:with-param name="class">contentButton2</xsl:with-param>
																					</xsl:call-template>

																				</td>
																				<xsl:if test="contains(style, '')">
																					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
																				</xsl:if>
																			</xsl:if>
																		</table>

																	</td>
																</tr>

															</xsl:if>
														</table>
													</td>

												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>

				<!-- Ending rules -->
				<xsl:choose>
					<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">
						<xsl:if test="rule_end != 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<td class="contentBlockMarge">&nbsp;</td>]]></xsl:text></xsl:if>

						<xsl:if test="position() = last() or rule_end = 'true'">
							<xsl:text disable-output-escaping="yes"><![CDATA[</tr></table></td></tr></table></td>]]></xsl:text>
						</xsl:if>
					</xsl:when>
				</xsl:choose>

				<xsl:if test="rule_end = 'true' or position() = last()">
					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>

					<!-- buttons rule, used for desktop version (the mobile version is defined after content above) -->
					<tr>
						<!-- BUTTON 1 -->
						<xsl:if test="preceding-sibling::match[2]/rule_end != 'true' and preceding-sibling::match[1]/rule_end != 'true'">
							<td class="contentButtonContainer">
								<xsl:call-template name="button_container">
									<xsl:with-param name="row" select="preceding-sibling::match[2]" />
								</xsl:call-template>
							</td>

							<td class="contentBlockMarge"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></td>
						</xsl:if>

						<!-- BUTTON 2 -->
						<xsl:if test="preceding-sibling::match[1]/rule_end != 'true'">
							<td class="contentButtonContainer">
								<xsl:call-template name="button_container">
									<xsl:with-param name="row" select="preceding-sibling::match[1]" />
								</xsl:call-template>
							</td>

							<td class="contentBlockMarge"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></td>
						</xsl:if>

						<!-- BUTTON 3 -->
						<td class="contentButtonContainer">
							<xsl:call-template name="button_container">
								<xsl:with-param name="row" select="." />
							</xsl:call-template>
						</td>

					</tr>
				</xsl:if>
				
			</xsl:for-each>

		</table>

	</xsl:template>

	<xsl:template name="date_subtitle">
		<xsl:param name="row" />

		<xsl:choose>
			<xsl:when test="$row/icon != ''">
				<xsl:value-of select="$row/icon" disable-output-escaping="yes" />
			</xsl:when>
			<xsl:when test="not(contains($row/display_playdate_start, '1 januari 2000'))">

				<xsl:variable name="start_date"><xsl:value-of select="substring-before($row/playdate_start, 'T')" /></xsl:variable>
				<xsl:variable name="start_year"><xsl:value-of select="substring-before($start_date,'-')" /></xsl:variable>
				<xsl:variable name="start_month"><xsl:value-of select="substring($row/playdate_start, 6, 2)" /></xsl:variable>
				<xsl:variable name="start_day"><xsl:value-of select="substring($row/playdate_start, 9, 2)" /></xsl:variable>

				<xsl:variable name="start_a" select="floor((14 - $start_month) div 12)"/>
				<xsl:variable name="start_y" select="$start_year - $start_a"/>
				<xsl:variable name="start_m" select="$start_month + 12 * $start_a - 2"/>

				<xsl:variable name="start_weekday" select="($start_day + $start_y + floor($start_y div 4) - floor($start_y div 100) + floor($start_y div 400) + floor((31 * $start_m) div 12)) mod 7" />

				<xsl:variable name="end_date"><xsl:value-of select="substring-before($row/playdate_end, 'T')" /></xsl:variable>
				<xsl:variable name="end_year"><xsl:value-of select="substring-before($end_date,'-')" /></xsl:variable>
				<xsl:variable name="end_month"><xsl:value-of select="substring($row/playdate_end, 6, 2)" /></xsl:variable>
				<xsl:variable name="end_day"><xsl:value-of select="substring($row/playdate_end, 9, 2)" /></xsl:variable>

				<xsl:variable name="end_a" select="floor((14 - $end_month) div 12)"/>
				<xsl:variable name="end_y" select="$end_year - $end_a"/>
				<xsl:variable name="end_m" select="$end_month + 12 * $end_a - 2"/>

				<xsl:variable name="end_weekday" select="($end_day + $end_y + floor($end_y div 4) - floor($end_y div 100) + floor($end_y div 400) + floor((31 * $end_m) div 12)) mod 7" />

				<xsl:choose>
					<xsl:when test="$start_weekday = '0'"><xsl:value-of select="$date_day_0" /></xsl:when>
					<xsl:when test="$start_weekday = '1'"><xsl:value-of select="$date_day_1" /></xsl:when>
					<xsl:when test="$start_weekday = '2'"><xsl:value-of select="$date_day_2" /></xsl:when>
					<xsl:when test="$start_weekday = '3'"><xsl:value-of select="$date_day_3" /></xsl:when>
					<xsl:when test="$start_weekday = '4'"><xsl:value-of select="$date_day_4" /></xsl:when>
					<xsl:when test="$start_weekday = '5'"><xsl:value-of select="$date_day_5" /></xsl:when>
					<xsl:when test="$start_weekday = '6'"><xsl:value-of select="$date_day_6" /></xsl:when>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="substring($start_day, 1, 1) = '0'"><xsl:value-of select="substring($start_day, 2, 1)" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$start_day" /></xsl:otherwise>
				</xsl:choose>

				<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

				<xsl:choose>
					<xsl:when test="$start_month = '01'"><xsl:value-of select="$date_month_1" /></xsl:when>
					<xsl:when test="$start_month = '02'"><xsl:value-of select="$date_month_2" /></xsl:when>
					<xsl:when test="$start_month = '03'"><xsl:value-of select="$date_month_3" /></xsl:when>
					<xsl:when test="$start_month = '04'"><xsl:value-of select="$date_month_4" /></xsl:when>
					<xsl:when test="$start_month = '05'"><xsl:value-of select="$date_month_5" /></xsl:when>
					<xsl:when test="$start_month = '06'"><xsl:value-of select="$date_month_6" /></xsl:when>
					<xsl:when test="$start_month = '07'"><xsl:value-of select="$date_month_7" /></xsl:when>
					<xsl:when test="$start_month = '08'"><xsl:value-of select="$date_month_8" /></xsl:when>
					<xsl:when test="$start_month = '09'"><xsl:value-of select="$date_month_9" /></xsl:when>
					<xsl:when test="$start_month = '10'"><xsl:value-of select="$date_month_10" /></xsl:when>
					<xsl:when test="$start_month = '11'"><xsl:value-of select="$date_month_11" /></xsl:when>
					<xsl:when test="$start_month = '12'"><xsl:value-of select="$date_month_12" /></xsl:when>
				</xsl:choose>

				<xsl:value-of select="$start_year" />

				<xsl:if test="$row/display_playdate_start != $row/display_playdate_end">

					<xsl:text disable-output-escaping="yes"><![CDATA[ t/m ]]></xsl:text>

					<xsl:choose>
						<xsl:when test="$end_weekday = '0'"><xsl:value-of select="$date_day_0" /></xsl:when>
						<xsl:when test="$end_weekday = '1'"><xsl:value-of select="$date_day_1" /></xsl:when>
						<xsl:when test="$end_weekday = '2'"><xsl:value-of select="$date_day_2" /></xsl:when>
						<xsl:when test="$end_weekday = '3'"><xsl:value-of select="$date_day_3" /></xsl:when>
						<xsl:when test="$end_weekday = '4'"><xsl:value-of select="$date_day_4" /></xsl:when>
						<xsl:when test="$end_weekday = '5'"><xsl:value-of select="$date_day_5" /></xsl:when>
						<xsl:when test="$end_weekday = '6'"><xsl:value-of select="$date_day_6" /></xsl:when>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="substring($end_day, 1, 1) = '0'"><xsl:value-of select="substring($end_day, 2, 1)" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$end_day" /></xsl:otherwise>
					</xsl:choose>

					<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

					<xsl:choose>
						<xsl:when test="$end_month = '01'"><xsl:value-of select="$date_month_1" /></xsl:when>
						<xsl:when test="$end_month = '02'"><xsl:value-of select="$date_month_2" /></xsl:when>
						<xsl:when test="$end_month = '03'"><xsl:value-of select="$date_month_3" /></xsl:when>
						<xsl:when test="$end_month = '04'"><xsl:value-of select="$date_month_4" /></xsl:when>
						<xsl:when test="$end_month = '05'"><xsl:value-of select="$date_month_5" /></xsl:when>
						<xsl:when test="$end_month = '06'"><xsl:value-of select="$date_month_6" /></xsl:when>
						<xsl:when test="$end_month = '07'"><xsl:value-of select="$date_month_7" /></xsl:when>
						<xsl:when test="$end_month = '08'"><xsl:value-of select="$date_month_8" /></xsl:when>
						<xsl:when test="$end_month = '09'"><xsl:value-of select="$date_month_9" /></xsl:when>
						<xsl:when test="$end_month = '10'"><xsl:value-of select="$date_month_10" /></xsl:when>
						<xsl:when test="$end_month = '11'"><xsl:value-of select="$date_month_11" /></xsl:when>
						<xsl:when test="$end_month = '12'"><xsl:value-of select="$date_month_12" /></xsl:when>
					</xsl:choose>

					<xsl:value-of select="$end_year" />

				</xsl:if>

				<xsl:if test="substring($row/playdate_start, 12, 5) != '00:00'">
					<xsl:text disable-output-escaping="yes"><![CDATA[ om ]]></xsl:text>
					<xsl:value-of select="substring($row/playdate_start, 12, 5)" />

					<xsl:if test="substring($row/playdate_end, 12, 5) != substring($row/playdate_start, 12, 5)">
						<xsl:text disable-output-escaping="yes"><![CDATA[ - ]]></xsl:text>
						<xsl:value-of select="substring($row/playdate_end, 12, 5)" />
					</xsl:if>
				</xsl:if>

			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="button_container">
		<xsl:param name="row" />

		<table cellpadding="0" cellspacing="0">
			<!-- Button 1 -->
			<xsl:if test="$row/url != '' and not(contains($row/image_alt, 'NOBUTTON'))">
				<xsl:if test="contains($row/style, '1/3')">
					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
				</xsl:if>
				<td class="contentButtonBlock">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="$row/url2 != '' and not(contains($row/style, '1/3')) and not(contains($row/icon2, 'NOBUTTON'))">padding-right: 15px;</xsl:when>
							<xsl:otherwise>padding-right: 0px;</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="button">
						<xsl:with-param name="url" select="$row/details_url" />
						<xsl:with-param name="button_text" select="$row/image_alt" />
						<xsl:with-param name="button_default_text" select="$button1_text" />
						<xsl:with-param name="class">contentButton</xsl:with-param>
					</xsl:call-template>

				</td>
				<xsl:if test="contains($row/style, '1/3')">
					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
				</xsl:if>
			</xsl:if>

			<!-- Button 2 -->
			<xsl:if test="$row/url2 != '' and not(contains($row/icon2, 'NOBUTTON'))">
				<xsl:if test="contains($row/style, '1/3')">
					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
				</xsl:if>
				<td class="contentButtonBlock">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="contains($row/style, '1/3')">padding-top: 10px;</xsl:when>
							<xsl:otherwise>padding-top: 0px;</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="button">
						<xsl:with-param name="url" select="$row/details_url2" />
						<xsl:with-param name="button_text" select="$row/icon2" />
						<xsl:with-param name="button_default_text" select="$button2_text" />
						<xsl:with-param name="class">contentButton2</xsl:with-param>
					</xsl:call-template>

				</td>
				<xsl:if test="contains($row/style, '')">
					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
				</xsl:if>
			</xsl:if>
		</table>

	</xsl:template>

	<xsl:template name="button">
		<xsl:param name="button_text" />
		<xsl:param name="button_default_text" />
		<xsl:param name="url" />
		<xsl:param name="class" />
		<xsl:param name="align">left</xsl:param>

		<a target="_blank">
			<xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>

			<table cellpadding="0" cellspacing="0">
				<xsl:attribute name="align"><xsl:value-of select="$align" /></xsl:attribute>
				<tr>
					<td>
						<xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
						<a target="_blank">
							<xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
							<xsl:choose>
								<xsl:when test="$button_text != ''"><xsl:value-of select="$button_text" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="$button_default_text" /></xsl:otherwise>
							</xsl:choose>
						</a>
					</td>
				</tr>
			</table>
		</a>

	</xsl:template>

</xsl:stylesheet>