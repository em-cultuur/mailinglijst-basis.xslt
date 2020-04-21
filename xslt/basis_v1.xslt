<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />

	<!-- Basis  v1
	XSLT for BLOCKS in MailingLijst-templates
	(c) EM-Cultuur, 2020
	Last change: JWDB 21 april 2020

	BLOCKSTULE-names determine grouping
	blockdeails (db.fiesds) dettermine content, design of the blocks
	design is set in the CSS of the template (few exceptions)

	for xslt-fieldnames (db.fieldnames, block-names) reference :
    https://docs.google.com/spreadsheets/d/1YH9x9XHwB_tUU6pUYobAH4UFw3eY7HIlSVqLEHc6ySU/edit?usp=sharing
	-->

	<!-- DEFAULTS/CONSTANTS -->
	<!--
	Image widths must be defined in CSS and XSLT
	And are used for style and width-parameters

	-->
	<xsl:variable name="width_13">220</xsl:variable>
	<xsl:variable name="width_12">340</xsl:variable>
	<xsl:variable name="width_23">460</xsl:variable>
	<xsl:variable name="width_full">700</xsl:variable>
	<xsl:variable name="image_width_lr">220</xsl:variable>
	<xsl:variable name="image_width_agenda">125</xsl:variable>

	<!-- TEXT DEFAULTS (can be overridden -->
	<xsl:variable name="button1_text">Lees meer</xsl:variable>
	<xsl:variable name="button2_text">Koop kaarten</xsl:variable>
	<xsl:variable name="button_icon"></xsl:variable>
	<xsl:variable name="button2_icon"></xsl:variable>
	<xsl:variable name="button_icon_feature"></xsl:variable>
	<xsl:variable name="button2_icon_feature"></xsl:variable>

	<xsl:variable name="agenda_header_text">Agenda</xsl:variable>
	<xsl:variable name="agenda_icon"></xsl:variable>
	<xsl:variable name="agenda_icon_width">36</xsl:variable>

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

	<xsl:variable name="date_period_prefix"> t/m </xsl:variable>
	<xsl:variable name="date_time_prefix"> om </xsl:variable>
	<xsl:variable name="date_time_period_prefix"> - </xsl:variable>

	<xsl:variable name="index_title">In deze nieuwsbrief:</xsl:variable>
	<xsl:variable name="index_indentation"><xsl:text disable-output-escaping="yes"><![CDATA[&bull;&nbsp;]]></xsl:text></xsl:variable>

	<xsl:template match="/">

		<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">

			<!-- Blocks are grouped on blockstyle-name-first-word (Item, Agenda)
			Loop through block-styles starting with 'Item' -->
			<xsl:for-each select="matches/match[contains(style, 'Item')]">

				<!-- Check configured block style, some blocks needs own HTML code in this XSLT-file for compatibility reasons -->
				<xsl:choose>

					<!-- All blocks except: call2action, tussenkopje and agenda  -->
					<xsl:when test="not(contains(style, 'call2action')) and not(contains(style, 'tussenkopje')) and not(contains(style, 'agenda'))">

						<!-- Default widths of blocks, set in the header of this document -->
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
							<xsl:text disable-output-escaping="yes"><![CDATA[<td><table cellpadding="0" cellspacing="0"><tr><td class="ctBlockCont"><table cellpadding="0" cellspacing="0"><tr>]]></xsl:text>
						</xsl:if>

						<!-- BLOCKSTYLE: ITEM-->
						<td>
							<!--
                            When using HIGHLIGHTED (uitgelicht) styles, we need to swap the classes to Featured which haves alternative background color by default.
                            When db.extra2 is filled, then the alternative background color is set, sets the classes to Featured as well.
                            -->
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and not(contains(style, 'uitgelicht')) and extra1 = ''">ctMainBlock</xsl:when>
									<xsl:when test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (contains(style, 'uitgelicht') or extra1 != '')">ctMainBlockFeat</xsl:when>
									<xsl:when test="contains(style, 'banner')">ctMainBlockBan</xsl:when>
									<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">ctMainBlockItemFeat</xsl:when>
									<xsl:otherwise>ctMainBlockItem</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="(url = '' or contains(image_alt, 'NOBUTTON')) and (url2 = '' or contains(icon2, 'NOBUTTON'))"> ctMainNoButton</xsl:if>
							</xsl:attribute>

							<!--
                            When db.extra1 is filled, then a custom background color is set.
                            -->
							<xsl:if test="extra1 != ''">
								<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>
							</xsl:if>

							<table cellpadding="0" cellspacing="0" class="ctMainTable">
								<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
								<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;</xsl:attribute>
								<tr>
									<td>
										<!-- The data attributes are needed for the BLOKKEN-EDITOR in the MailingLijst User Interface -->
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
											<tr>
												<td>
													<xsl:attribute name="class">
														<xsl:choose>
															<xsl:when test="contains(style, 'banner')">ctInnerContBan</xsl:when>
															<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">ctInnerContFeat</xsl:when>
															<xsl:otherwise>ctInnerCont</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>

													<!--
                                                    When db.extra1 is filled, then a custom background color is set.
                                                    This logic is double with the TD above, but it is needed for the BLOKKEN_EDITOR
                                                    -->
													<xsl:if test="extra1 != ''">
														<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>
													</xsl:if>

													<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
														<!-- Titles above
														When the style name contains a trigger word 'titels boven' then move the titles to above image
														But ignore this if no image is set
														-->
														<xsl:if test="image != '' and contains(style, 'titels boven')">
															<!-- Hide title when item.style.name contains "geen titel", or content of db.title contains 'NOTITLE' (case sensitive)
																The titles in banner styles cannot be hidden -->
															<xsl:if test="(not(contains(style, 'geen titel')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">
																<xsl:call-template name="titles" />
															</xsl:if>
														</xsl:if>

														<!-- Image above
                                                        When a placeholder is used, then this block item is created automatically after a new mailing were created
                                                        The default placeholder is a square. To prevent ugly look with 700px by 700px, replace it by a wide variant of the placeholder
                                                        Hide this part when using image left/right styles -->
														<xsl:if test="image != '' and not(contains(style, 'afb.'))">
															<tr>
																<td>
																	<!-- ##JWDB 26 march 2020: when the image width is smaller than 480, then don't stretch out on mobile. So add other class to them -->
																	<xsl:attribute name="class">
																		<xsl:choose>
																			<xsl:when test="$width &lt; 480">ctImgSmall</xsl:when>
																			<xsl:otherwise>ctImg</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>

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
																							<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
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
																						<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																						<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																					</xsl:choose>
																				</xsl:attribute>
																			</img>
																		</xsl:otherwise>
																	</xsl:choose>

																	<!-- when db.extra2 field is filled, show it as image subtitle / photo credits -->
																	<xsl:if test="extra2 != ''">
																		<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																			<tr>
																				<td class="ctImgSubt">
																					<xsl:value-of select="extra2" />
																				</td>
																			</tr>
																		</table>
																	</xsl:if>
																</td>
															</tr>
														</xsl:if>

														<!-- Show no image when image only block style is used and without any image is set -->
														<xsl:if test="image = '' and contains(style, '(afbeelding)')">
															<tr>
																<td class="ctImg">
																	<img>
																		<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
																		<xsl:attribute name="style">display: block; width: <xsl:value-of select="$width" />px;</xsl:attribute>
																		<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																		<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																		<xsl:attribute name="src">https://via.placeholder.com/<xsl:value-of select="$width" />x300?text=GEEN AFBEELDING</xsl:attribute>
																	</img>
																</td>
															</tr>
														</xsl:if>

														<!-- Hide entire content container when using image only block style -->
														<xsl:if test="not(contains(style, '(afbeelding)'))">
															<tr>
																<td>
																	<!-- Inner container for both image left/right and content blocks
                                                                    dir attribute is used to force image right to be displayed right
                                                                    this is used to prevent code copies and image will be displayed above content when opening on mobile devices-->
																	<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
																		<xsl:attribute name="dir">
																			<xsl:choose>
																				<xsl:when test="contains(style, 'afb. rechts')">rtl</xsl:when>
																				<xsl:otherwise>ltr</xsl:otherwise>
																			</xsl:choose>
																		</xsl:attribute>
																		<tr>
																			<!-- Image left/right container  trigger: 'AFB.'
                                                                            Will be displayed when using Item (afb. links) or Item (afb. rechts) styles
                                                                            -->
																			<xsl:if test="contains(style, 'afb.')">
																				<td>
																					<xsl:attribute name="class">
																						<xsl:choose>
																							<xsl:when test="contains(style, 'afb. rechts') and contains(style, 'banner')">ctImgRightOuterBlockBan</xsl:when>
																							<xsl:when test="contains(style, 'afb. rechts')">ctImgRightOuterBlock</xsl:when>
																							<xsl:when test="contains(style, 'afb. links') and contains(style, 'banner')">ctImgLeftOuterBlockBan</xsl:when>
																							<xsl:otherwise>ctImgLeftOuterBlock</xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<table cellpadding="0" cellspacing="0" style="width: 100%" width="100%">
																						<tr>
																							<td>
																								<xsl:attribute name="class">
																									<xsl:choose>
																										<xsl:when test="contains(style, 'afb. rechts') and contains(style, 'banner')">ctImgRightInnerBlockBan</xsl:when>
																										<xsl:when test="contains(style, 'afb. rechts')">ctImgRightInnerBlock</xsl:when>
																										<xsl:when test="contains(style, 'afb. links') and contains(style, 'banner')">ctImgLeftInnerBlockBan</xsl:when>
																										<xsl:otherwise>ctImgLeftInnerBlock</xsl:otherwise>
																									</xsl:choose>
																								</xsl:attribute>
																								<!-- must image be made clickable by adding (button)url-->
																								<xsl:choose>
																									<xsl:when test="url != ''">
																										<a target="_blank">
																											<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																											<img border="0">
																												<xsl:attribute name="width"><xsl:value-of select="$image_width_lr" /></xsl:attribute>
																												<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width_lr" />px;</xsl:attribute>
																												<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																												<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																												<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
																											</img>
																										</a>
																									</xsl:when>
																									<xsl:otherwise>
																										<img>
																											<xsl:attribute name="width"><xsl:value-of select="$image_width_lr" /></xsl:attribute>
																											<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width_lr" />px;</xsl:attribute>
																											<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																											<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																											<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
																										</img>
																									</xsl:otherwise>
																								</xsl:choose>

																								<!-- when db.extra2 field is filled, show it as image subtitle / photo credits -->
																								<xsl:if test="extra2 != ''">
																									<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																										<tr>
																											<td class="ctImgSubt">
																												<xsl:value-of select="extra2" />
																											</td>
																										</tr>
																									</table>
																								</xsl:if>
																							</td>
																						</tr>
																					</table>
																				</td>
																			</xsl:if>
																			<!-- Content and buttons container -->
																			<td class="ctOuterBlock" dir="ltr">

																				<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
																					<tr>
																						<!-- BLOCK CONTENT (title, subtitle, date) with text and buttons -->
																						<td class="ctInnerBlock" style="vertical-align: top;">

																							<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

																								<!-- Hide title when item.style.name contains "geen titel", or content of db.title contains 'NOTITLE' (case sensitive)
																								The titles in banner styles cannot be hidden
																								Hide this part when the style name contains trigger words 'titels boven' -->
																								<xsl:if test="not(contains(style, 'titels boven'))">
																									<xsl:if test="(not(contains(style, 'geen titel')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">
																										<xsl:call-template name="titles" />
																									</xsl:if>
																								</xsl:if>

																								<!-- Content
																								Hide this part when using banner blocks
																								##JWDB 31 march 2020: when using index item style, show a list with all items in this newsletter with some exceptions (sub headers, this item, full image items, call2action and items with NOTITLE)
																								The validation on ending <br> in content is to prevent we're adding too many enters
																								-->
																								<xsl:if test="not(contains(style, 'banner')) and content != ''">
																									<tr>
																										<td class="content">
																											<xsl:value-of select="content" disable-output-escaping="yes" />

																											<xsl:if test="contains(style, 'index')">
																												<xsl:choose>
																													<xsl:when test="substring(content, string-length(content) - string-length('&lt;br&gt;') +1) = '&lt;br&gt;'"><br /></xsl:when>
																													<xsl:otherwise><br /><br /></xsl:otherwise>
																												</xsl:choose>

																												<xsl:if test="$index_title != ''">
																													<xsl:value-of select="$index_title" /><br />
																												</xsl:if>

																												<xsl:for-each select="/matches/match[contains(style, 'Item') and not(contains(style, 'index')) and not(contains(style, 'tussenkopje')) and not(contains(style, 'afbeelding')) and not(contains(title, 'NOTITLE')) and not(contains(style, 'call2action'))]">
																													<xsl:variable name="title">
																														<xsl:call-template name="double_pipes">
																															<xsl:with-param name="input" select="title" />
																															<xsl:with-param name="replace_with"><xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text></xsl:with-param>
																														</xsl:call-template>
																													</xsl:variable>

																													<xsl:value-of select="$index_indentation" disable-output-escaping="yes" />
																													<a class="indexLink">
																														<xsl:attribute name="href">#<xsl:value-of select="merge_ID" /></xsl:attribute>
																														<xsl:value-of select="$title" disable-output-escaping="yes" />
																													</a><br />
																												</xsl:for-each>
																											</xsl:if>
																										</td>
																									</tr>
																								</xsl:if>

																								<!-- BUTTONS
																								default button text is set as constants above
                                                                                                db.image_alt is used as alternative button text ('1e veld' name in ML)
                                                                                                db.icon2  is used as alternative button text for second button
                                                                                                When 1/3 style is used,  buttons are shown on two lines
                                                                                                No buttons will be displayed when NOBUTTON is set in db.image_alt and/or db.icon2
                                                                                                -->
																								<xsl:if test="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON'))))">
																									<tr style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">
																										<xsl:attribute name="class">
																											<xsl:choose>
																												<xsl:when test="contains(style, 'banner')">ctMobButContBan</xsl:when>
																												<xsl:when test="contains(style, 'uitgelicht') or extra1 !=''">ctMobButContFeat</xsl:when>
																												<xsl:otherwise>ctMobButCont</xsl:otherwise>
																											</xsl:choose>
																										</xsl:attribute>
																										<td class="ctMobButBlock">

																											<table cellpadding="0" cellspacing="0" class="ctMobInnerCont" style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">

																												<!-- ##JWDB 31 march 2020: buttons can be aligned middle or right by adding 'button midden' or 'button rechts' in the style name -->
																												<xsl:attribute name="align">
																													<xsl:choose>
																														<xsl:when test="contains(style, 'button midden')">center</xsl:when>
																														<xsl:when test="contains(style, 'button rechts')">right</xsl:when>
																														<xsl:otherwise>left</xsl:otherwise>
																													</xsl:choose>
																												</xsl:attribute>
																												<tr>
																													<!-- Button 1 -->
																													<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON'))">
																														<td class="ctButBlock">
																															<xsl:attribute name="style">padding-right: 15px;</xsl:attribute>

																															<xsl:call-template name="button">
																																<xsl:with-param name="url" select="details_url" />
																																<xsl:with-param name="button_text" select="image_alt" />
																																<xsl:with-param name="button_default_text" select="$button1_text" />
																																<xsl:with-param name="class">ctBut</xsl:with-param>
																																<xsl:with-param name="hide">1</xsl:with-param>
																																<xsl:with-param name="button_icon">
																																	<xsl:choose>
																																		<xsl:when test="contains(style, 'banner') or contains(style, 'uitgelicht') or extra1 != ''"><xsl:value-of select="$button_icon_feature" /></xsl:when>
																																		<xsl:otherwise><xsl:value-of select="$button_icon" /></xsl:otherwise>
																																	</xsl:choose>
																																</xsl:with-param>
																															</xsl:call-template>

																														</td>
																													</xsl:if>

																													<!-- Button 2 -->
																													<xsl:if test="url2 != ''">
																														<td class="ctButBlock">

																															<xsl:call-template name="button">
																																<xsl:with-param name="url" select="details_url2" />
																																<xsl:with-param name="button_text" select="icon2" />
																																<xsl:with-param name="button_default_text" select="$button2_text" />
																																<xsl:with-param name="class">ctBut2</xsl:with-param>
																																<xsl:with-param name="hide">1</xsl:with-param>
																																<xsl:with-param name="button_icon">
																																	<xsl:choose>
																																		<xsl:when test="contains(style, 'banner') or contains(style, 'uitgelicht') or extra1 != ''"><xsl:value-of select="$button2_icon_feature" /></xsl:when>
																																		<xsl:otherwise><xsl:value-of select="$button2_icon" /></xsl:otherwise>
																																	</xsl:choose>
																																</xsl:with-param>
																															</xsl:call-template>

																														</td>
																													</xsl:if>
																												</tr>
																											</table>

																										</td>
																									</tr>

																								</xsl:if>

																								<!-- MOBILE buttons trigger: AFB.
																								Two buttons for some block styles as image left/right
                                                                                                We need to put buttons next to images instead of below for blockstyle-names containing 'afb'  -->
																								<xsl:if test="(url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON')))">

																									<!-- check if the following or previous 1/2, 1/3 or 2/3 items have buttons
																									If not, then show this part to prevent unwanted white spaces between text and buttons -->
																									<xsl:variable name="previous_buttons_2" select="((preceding-sibling::match[2]/url != '' and not(contains(preceding-sibling::match[2]/image_alt, 'NOBUTTON'))) or (preceding-sibling::match[2]/url2 != '' and not(contains(preceding-sibling::match[2]/icon2, 'NOBUTTON'))))" />
																									<xsl:variable name="previous_buttons_1" select="((preceding-sibling::match[1]/url != '' and not(contains(preceding-sibling::match[1]/image_alt, 'NOBUTTON'))) or (preceding-sibling::match[1]/url2 != '' and not(contains(preceding-sibling::match[1]/icon2, 'NOBUTTON'))))" />
																									<xsl:variable name="next_buttons_1" select="((following-sibling::match[1]/url != '' and not(contains(following-sibling::match[1]/image_alt, 'NOBUTTON'))) or (following-sibling::match[1]/url2 != '' and not(contains(following-sibling::match[1]/icon2, 'NOBUTTON'))))" />
																									<xsl:variable name="next_buttons_2" select="((following-sibling::match[2]/url != '' and not(contains(following-sibling::match[2]/image_alt, 'NOBUTTON'))) or (following-sibling::match[2]/url2 != '' and not(contains(following-sibling::match[2]/icon2, 'NOBUTTON'))))" />

																									<xsl:variable name="show_buttons">
																										<xsl:choose>
																											<!-- As first 1/2 item in the block -->
																											<xsl:when test="contains(style, '1/2') and rule_end = 'false' and not($next_buttons_1) and
																												contains(following-sibling::match[1]/style, '1/2')">1</xsl:when>

																											<!-- As second 1/2 item in the block -->
																											<xsl:when test="contains(style, '1/2') and rule_end = 'true' and not($previous_buttons_1) and
																												contains(preceding-sibling::match[1]/style, '1/2')">1</xsl:when>

																											<!-- As first 2/3 item in the block -->
																											<xsl:when test="contains(style, '2/3') and rule_end = 'false' and not($next_buttons_1)">1</xsl:when>

																											<!-- As second 2/3 item in the block -->
																											<xsl:when test="contains(style, '2/3') and rule_end = 'true' and not($previous_buttons_1)">1</xsl:when>

																											<!-- As first 1/3 item in the block in combination with a 2/3 item -->
																											<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($next_buttons_1) and
																												contains(following-sibling::match[1]/style, '2/3') and
																												following-sibling::match[1]/rule_end = 'true'">1</xsl:when>

																											<!-- As last 1/3 item in the block in combination with a 2/3 item -->
																											<xsl:when test="contains(style, '1/3') and rule_end = 'true' and not($previous_buttons_1) and
																												contains(preceding-sibling::match[1]/style, '2/3') and
																												preceding-sibling::match[1]/rule_end = 'false'">1</xsl:when>

																											<!-- As first 1/3 item in the block in combination with two other 1/3 items -->
																											<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($next_buttons_1) and not($next_buttons_2) and
																												contains(following-sibling::match[1]/style, '1/3') and
																												following-sibling::match[1]/rule_end = 'false' and
																												contains(following-sibling::match[2]/style, '1/3') and
																												following-sibling::match[2]/rule_end = 'true'">1</xsl:when>

																											<!-- As second 1/3 item in the block in combination with two other 1/3 items -->
																											<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($previous_buttons_1) and not($next_buttons_1) and
																												contains(following-sibling::match[1]/style, '1/3') and
																												following-sibling::match[1]/rule_end = 'true' and
																												contains(preceding-sibling::match[1]/style, '1/3') and
																												preceding-sibling::match[1]/rule_end = 'false'">1</xsl:when>

																											<!-- As third 1/3 item in the block in combination with two other 1/3 items -->
																											<xsl:when test="contains(style, '1/3') and rule_end = 'true' and not($previous_buttons_1) and not($previous_buttons_2) and
																												contains(preceding-sibling::match[1]/style, '1/3') and
																												preceding-sibling::match[1]/rule_end = 'false' and
																												contains(preceding-sibling::match[2]/style, '1/3') and
																												preceding-sibling::match[2]/rule_end = 'false'">1</xsl:when>

																											<xsl:otherwise>0</xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:if test="contains(style, 'afb.') or $show_buttons = 1">
																										<tr>
																											<xsl:call-template name="button_container">
																												<xsl:with-param name="row" select="." />
																												<xsl:with-param name="ignore_width">1</xsl:with-param>
																											</xsl:call-template>
																										</tr>
																									</xsl:if>
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
														</xsl:if>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>

						<!-- End of block -->
						<xsl:choose>
							<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">
								<xsl:if test="rule_end != 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<td class="ctBlockMargin">&nbsp;</td>]]></xsl:text></xsl:if>

								<xsl:if test="position() = last() or rule_end = 'true'">
									<xsl:text disable-output-escaping="yes"><![CDATA[</tr></table></td></tr></table></td>]]></xsl:text>
								</xsl:if>
							</xsl:when>
						</xsl:choose>

						<xsl:if test="rule_end = 'true' or position() = last()">
							<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>

							<!-- Buttons, used for desktop version (the mobile version is defined after content above).
                            Except for some block styles containing images-->
							<xsl:if test="not(contains(style, 'afb.')) and not(contains(style, 'afbeelding'))">

								<!-- Check if it's necessary to show this buttons row if one 1/2 have buttons -->
								<xsl:variable name="previous_buttons_2" select="((preceding-sibling::match[2]/url != '' and not(contains(preceding-sibling::match[2]/image_alt, 'NOBUTTON'))) or (preceding-sibling::match[2]/url2 != '' and not(contains(preceding-sibling::match[2]/icon2, 'NOBUTTON'))))" />
								<xsl:variable name="previous_buttons_1" select="((preceding-sibling::match[1]/url != '' and not(contains(preceding-sibling::match[1]/image_alt, 'NOBUTTON'))) or (preceding-sibling::match[1]/url2 != '' and not(contains(preceding-sibling::match[1]/icon2, 'NOBUTTON'))))" />
								<xsl:variable name="current_buttons" select="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON'))))"></xsl:variable>

								<xsl:variable name="show_buttons">
									<xsl:choose>
										<!-- First 1/2 haves buttons and second one not -->
										<xsl:when test="contains(style, '1/2') and not($current_buttons) and $previous_buttons_1 and
											contains(preceding-sibling::match[1]/style, '1/2')">0</xsl:when>

										<!-- Second 1/2 haves buttons and first one not -->
										<xsl:when test="contains(style, '1/2') and $current_buttons and not($previous_buttons_1) and
											contains(preceding-sibling::match[1]/style, '1/2')">0</xsl:when>

										<!-- First 2/3 haves buttons and second 1/3 not -->
										<xsl:when test="contains(style, '1/3') and not($current_buttons) and $previous_buttons_1 and
											contains(preceding-sibling::match[1]/style, '2/3') and
											preceding-sibling::match[1]/rule_end = 'false'">0</xsl:when>

										<!-- Second 2/3 haves buttons and first 1/3 not -->
										<xsl:when test="contains(style, '2/3') and $current_buttons and not($previous_buttons_1) and
											contains(preceding-sibling::match[1]/style, '1/3') and
											preceding-sibling::match[1]/rule_end = 'false'">0</xsl:when>

										<!-- first 1/3 haves buttons and other 1/3 items not -->
										<xsl:when test="contains(style, '1/3') and not($current_buttons) and not($previous_buttons_1) and $previous_buttons_2 and
											contains(preceding-sibling::match[1]/style, '1/3') and
											preceding-sibling::match[1]/rule_end = 'false' and
											contains(preceding-sibling::match[2]/style, '1/3') and
											preceding-sibling::match[2]/rule_end = 'false'">0</xsl:when>

										<!-- second 1/3 haves buttons and other 1/3 items not -->
										<xsl:when test="contains(style, '1/3') and not($current_buttons) and $previous_buttons_1 and not($previous_buttons_2) and
											contains(preceding-sibling::match[1]/style, '1/3') and
											preceding-sibling::match[1]/rule_end = 'false' and
											contains(preceding-sibling::match[2]/style, '1/3') and
											preceding-sibling::match[2]/rule_end = 'false'">0</xsl:when>

										<!-- third 1/3 haves buttons and other 1/3 items not -->
										<xsl:when test="contains(style, '1/3') and $current_buttons and not($previous_buttons_1) and not($previous_buttons_2) and
											contains(preceding-sibling::match[1]/style, '1/3') and
											preceding-sibling::match[1]/rule_end = 'false' and
											contains(preceding-sibling::match[2]/style, '1/3') and
											preceding-sibling::match[2]/rule_end = 'false'">0</xsl:when>

										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:if test="$show_buttons = 1">
									<tr>
										<td class="ctDeskButCont">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<!-- BUTTON 1 -->
													<xsl:if test="preceding-sibling::match[2]/rule_end != 'true' and preceding-sibling::match[1]/rule_end != 'true'">
														<xsl:call-template name="button_container">
															<xsl:with-param name="row" select="preceding-sibling::match[2]" />
														</xsl:call-template>

														<td class="ctBlockMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></td>
													</xsl:if>

													<!-- BUTTON 2 -->
													<xsl:if test="preceding-sibling::match[1]/rule_end != 'true'">
														<xsl:call-template name="button_container">
															<xsl:with-param name="row" select="preceding-sibling::match[1]" />
														</xsl:call-template>

														<td class="ctBlockMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></td>
													</xsl:if>

													<!-- BUTTON 3 -->
													<xsl:call-template name="button_container">
														<xsl:with-param name="row" select="." />
													</xsl:call-template>
												</tr>
											</table>
										</td>
									</tr>
								</xsl:if>
							</xsl:if>

							<!-- Create a table-row to generate margin between two item blocks -->
							<tr>
								<td class="ctBottomMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</td>
							</tr>
						</xsl:if>

					</xsl:when>

					<!-- BLOCKSTYLE: Call2action -->
					<xsl:when test="contains(style, 'call2action')">

						<tr>
							<!-- Basic block -->
							<td class="ctCallMainBlock">

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
									<tr>
										<td class="ctCallOuterCont">

											<xsl:choose>
												<xsl:when test="url != ''">

													<a target="_blank">
														<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
														<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
															<tr>
																<td class="ctCallInnerCont">
																	<!--
																	When extra1 is filled, then a custom background color is set. Set this when is filled only.
																	You can find the default background color in CSS by class ctCallInnerCont.
																	-->
																	<xsl:if test="extra1 != ''">
																		<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>
																	</xsl:if>

																	<h2>
																		<a target="_blank">
																			<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																			<xsl:value-of select="title" />
																		</a>
																	</h2>
																</td>
															</tr>
														</table>
													</a>

												</xsl:when>
												<xsl:otherwise>

													<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
														<tr>
															<td class="ctCallInnerCont">
																<!--
																When extra1 is filled, then a custom background color is set. Set this when is filled only.
																You can find the default background color in CSS by class ctCallInnerCont.
																-->
																<xsl:if test="extra1 != ''">
																	<xsl:attribute name="style">background-color: <xsl:value-of select="extra1" />;</xsl:attribute>
																</xsl:if>

																<h2><xsl:value-of select="title" /></h2>
															</td>
														</tr>
													</table>

												</xsl:otherwise>
											</xsl:choose>

										</td>
									</tr>
								</table>
							</td>
						</tr>

						<!-- Create a line to generate margin between two item blocks -->
						<tr>
							<td class="ctBottomMargin">
								<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
							</td>
						</tr>

					</xsl:when>

					<!-- BLOCKSTYLE: Tussenkop (Item (tussenkopje))
					Shows a subheader to separate items in groups-->
					<xsl:when test="contains(style, 'tussenkopje')">

						<tr>
							<!-- start block -->
							<td>
								<!-- ##JWDB 26 march 2020: added class logic for featured subheader style -->
								<xsl:attribute name="class">
									<xsl:choose>
										<xsl:when test="contains(style, 'uitgelicht')">ctSubhMainBlockFeat</xsl:when>
										<xsl:otherwise>ctSubhMainBlock</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>

								<!-- The data attributes for the BLOKKEN EDITOR -->
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
									<tr>
										<td>
											<!-- ##JWDB 26 march 2020: added class logic for featured subheader style -->
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="contains(style, 'uitgelicht')">ctSubhOuterContFeat</xsl:when>
													<xsl:otherwise>ctSubhOuterCont</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>

											<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
												<tr>
													<td>
														<!-- ##JWDB 26 march 2020: added class logic for featured subheader style -->
														<xsl:attribute name="class">
															<xsl:choose>
																<xsl:when test="contains(style, 'uitgelicht')">ctSubhInnerContFeat</xsl:when>
																<xsl:otherwise>ctSubhInnerCont</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>

														<h2><xsl:value-of select="title" /></h2>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>

						<!-- Create a table-row to generate margin between two item blocks -->
						<tr>
							<td class="ctBottomMargin">
								<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
							</td>
						</tr>

					</xsl:when>

					<!-- Item (agenda) / Item (agenda kop) style
					## TODO COMMENT
					This will override the Agenda block below
					Allows possibility to move Agenda block between normal Items
					You have still to create Agenda items-->
					<xsl:when test="contains(style, 'agenda')">
						<tr>
							<td class="ctMainBlockItem">
								<xsl:call-template name="agenda_container">
									<xsl:with-param name="with_data">1</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>

			</xsl:for-each>

			<!-- Loop through block names starting with AGENDA
			Except when Item (agenda kop) block is created
			By default the agenda will be displayed below ITEMS, but if you create an  (agenda kop) you can place the AGENDA anywhere -->
			<xsl:if test="count(matches/match[contains(style, 'Agenda')]) != 0 and count(matches/match[contains(style, 'Item (agenda')]) = 0">
				<xsl:call-template name="agenda_container">
					<xsl:with-param name="with_data">0</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

		</table>

	</xsl:template>

	<!--
	Central template for date text.
	When you empty the date fields in the content block details, then the dates will be saved as 1 january 2000.
	Or use the db.icon field (alernative date)
	-->
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

					<xsl:value-of select="$date_period_prefix" />

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
					<xsl:value-of select="$date_time_prefix" />
					<xsl:value-of select="substring($row/playdate_start, 12, 5)" />

					<xsl:if test="substring($row/playdate_end, 12, 5) != substring($row/playdate_start, 12, 5)">
						<xsl:value-of select="$date_time_period_prefix" />
						<xsl:value-of select="substring($row/playdate_end, 12, 5)" />
					</xsl:if>
				</xsl:if>

			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<!--
	Central template for the button container
	Dispplays buttons in a table-row below content
	-->
	<xsl:template name="button_container">
		<xsl:param name="row" />
		<xsl:param name="ignore_width">0</xsl:param>

		<xsl:variable name="button_width">
			<xsl:choose>
				<xsl:when test="contains($row/style, '1/2')"><xsl:value-of select="$width_12" /></xsl:when>
				<xsl:when test="contains($row/style, '1/3')"><xsl:value-of select="$width_13" /></xsl:when>
				<xsl:when test="contains($row/style, '2/3')"><xsl:value-of select="$width_23" /></xsl:when>
				<xsl:otherwise>700</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<td>
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$ignore_width = 1 and $row/extra1 != ''">width: 100%; background-color: <xsl:value-of select="$row/extra1" />;</xsl:when>
					<xsl:when test="$ignore_width = 1">width: 100%;</xsl:when>
					<xsl:when test="$row/extra1 != ''">width: <xsl:value-of select="$button_width" />px; background-color: <xsl:value-of select="$row/extra1" /></xsl:when>
					<xsl:otherwise>width: <xsl:value-of select="$button_width" />px;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="contains($row/style, 'banner')">ctButContBan</xsl:when>
					<xsl:when test="contains($row/style, 'uitgelicht') or $row/extra1 !=''">ctButContFeat</xsl:when>
					<xsl:otherwise>ctButCont</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<table cellspacing="0" cellpadding="0" class="ctButOuterTable">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="$ignore_width = 1">width: 100%</xsl:when>
						<xsl:otherwise>width: <xsl:value-of select="$button_width" />px;</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="width">
					<xsl:choose>
						<xsl:when test="$ignore_width = 1">100%</xsl:when>
						<xsl:otherwise><xsl:value-of select="$button_width" /></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<tr>

					<xsl:choose>
						<xsl:when test="($row/url != '' and not(contains($row/image_alt, 'NOBUTTON'))) or ($row/url2 != '' and not(contains($row/icon2, 'NOBUTTON')))">
							<td class="ctButInnerCont">
								<table cellpadding="0" cellspacing="0" class="ctButInnerTable">

									<!-- ##JWDB 31 march 2020: buttons can be aligned middle or right by adding 'button midden' or 'button rechts' in the style name -->
									<xsl:attribute name="align">
										<xsl:choose>
											<xsl:when test="contains($row/style, 'button midden')">center</xsl:when>
											<xsl:when test="contains($row/style, 'button rechts')">right</xsl:when>
											<xsl:otherwise>left</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<tr>
										<!-- Button 1 -->
										<xsl:if test="$row/url != '' and not(contains($row/image_alt, 'NOBUTTON'))">
											<td class="ctButBlock">
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
													<xsl:with-param name="class">ctBut</xsl:with-param>
													<xsl:with-param name="button_icon">
														<xsl:choose>
															<xsl:when test="contains($row/style, 'banner') or contains($row/style, 'uitgelicht') or $row/extra1 != ''"><xsl:value-of select="$button_icon_feature" /></xsl:when>
															<xsl:otherwise><xsl:value-of select="$button_icon" /></xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>

											</td>
											<xsl:if test="contains($row/style, '1/3') and $row/url2 != '' and not(contains($row/icon2, 'NOBUTTON'))">
												<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
											</xsl:if>
										</xsl:if>

										<!-- Button 2 -->
										<xsl:if test="$row/url2 != '' and not(contains($row/icon2, 'NOBUTTON'))">
											<xsl:if test="contains($row/style, '1/3') and $row/url != '' and not(contains($row/image_alt, 'NOBUTTON'))">
												<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
											</xsl:if>
											<td class="ctButBlock">
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
													<xsl:with-param name="class">ctBut2</xsl:with-param>
													<xsl:with-param name="button_icon">
														<xsl:choose>
															<xsl:when test="contains($row/style, 'banner') or contains($row/style, 'uitgelicht') or $row/extra1 != ''"><xsl:value-of select="$button2_icon_feature" /></xsl:when>
															<xsl:otherwise><xsl:value-of select="$button2_icon" /></xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>

											</td>
										</xsl:if>
									</tr>
								</table>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="tdButNoBut">
								<table cellpadding="0" cellspacing="0">
									<tr>
										<td style="font-size: 1px; line-height: 1px;">
											<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
										</td>
									</tr>
								</table>
							</td>
						</xsl:otherwise>
					</xsl:choose>

				</tr>
			</table>

		</td>

	</xsl:template>

	<!--
	Central template for buttons
	With hide param (1 or 0) you can determine if the button have to be hidden by default.
	Default buttons will be visible when viewing e-mail on mobile devices.
	##JWDB 31 march 2020: icon logic added, can be activated by filling in four variables above this XSLT
	##JWDB 10 april 2020: fixed bug with double buttons in Outlooks.
	##todo explain
	-->
	<xsl:template name="button">
		<xsl:param name="button_text" />
		<xsl:param name="button_default_text" />
		<xsl:param name="url" />
		<xsl:param name="class" />
		<xsl:param name="align">left</xsl:param>
		<xsl:param name="hide">0</xsl:param>
		<xsl:param name="button_icon" />

		<a target="_blank">
			<xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>

			<table cellpadding="0" cellspacing="0" class="ctButTable">
				<xsl:attribute name="align"><xsl:value-of select="$align" /></xsl:attribute>
				<xsl:if test="$hide = 1">
					<xsl:attribute name="style">display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;</xsl:attribute>
				</xsl:if>
				<tr>
					<td>
						<xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
						<table cellpadding="0" cellspacing="0" class="ctButTable">
							<xsl:if test="$hide = 1">
								<xsl:attribute name="style">display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;</xsl:attribute>
							</xsl:if>
							<tr>
								<td class="ctButIconText">
									<a target="_blank">
										<xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
										<xsl:choose>
											<xsl:when test="$button_text != ''"><xsl:value-of select="$button_text" /></xsl:when>
											<xsl:otherwise><xsl:value-of select="$button_default_text" /></xsl:otherwise>
										</xsl:choose>
									</a>
								</td>
								<xsl:if test="$button_icon != ''">
									<td class="ctButIconMargin">
										<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
									</td>
									<td class="ctButIcon">
										<img border="0" style="display: block;">
											<xsl:attribute name="src"><xsl:value-of select="$button_icon" /></xsl:attribute>
										</img>
									</td>
								</xsl:if>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</a>

	</xsl:template>

	<!--
	Central template for agenda container with header
	When with_data is 1, then this template is called from items block with Item (agenda) style
	Allows possibility to move agenda block between items instead of display below
	-->
	<xsl:template name="agenda_container">
		<xsl:param name="with_data">0</xsl:param>

		<tr>
			<td class="agMainBlock">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="agHeaderOuterCont">
							<xsl:choose>
								<xsl:when test="$with_data = 1">

									<table cellpadding="0" cellspacing="0" class="emItem emEditable emMoveable">
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
										<tr>
											<!-- ##JWDB 6 april 2020: Agenda icon implemented -->
											<xsl:if test="$agenda_icon != ''">
												<td class="agHeaderIcon" style="padding-right: 10px;">
													<img>
														<xsl:attribute name="src"><xsl:value-of select="$agenda_icon" /></xsl:attribute>
														<xsl:attribute name="title"><xsl:value-of select="$agenda_header_text" /></xsl:attribute>
														<xsl:attribute name="alt"><xsl:value-of select="$agenda_header_text" /></xsl:attribute>
														<xsl:attribute name="width"><xsl:value-of select="$agenda_icon_width" /></xsl:attribute>
														<xsl:attribute name="style">width: <xsl:value-of select="$agenda_icon_width" />px; display: block;</xsl:attribute>
													</img>
												</td>
											</xsl:if>
											<td class="agHeaderInnerCont">
												<xsl:value-of select="title" disable-output-escaping="yes" />
											</td>
										</tr>
									</table>

								</xsl:when>
								<xsl:otherwise>

									<table cellpadding="0" cellspacing="0">
										<tr>
											<!-- ##JWDB 6 april 2020: Agenda icon implemented -->
											<xsl:if test="$agenda_icon != ''">
												<td class="agHeaderIcon" style="padding-right: 10px;">
													<img>
														<xsl:attribute name="src"><xsl:value-of select="$agenda_icon" /></xsl:attribute>
														<xsl:attribute name="title"><xsl:value-of select="$agenda_header_text" /></xsl:attribute>
														<xsl:attribute name="alt"><xsl:value-of select="$agenda_header_text" /></xsl:attribute>
														<xsl:attribute name="width"><xsl:value-of select="$agenda_icon_width" /></xsl:attribute>
														<xsl:attribute name="style">width: <xsl:value-of select="$agenda_icon_width" />px; display: block;</xsl:attribute>
													</img>
												</td>
											</xsl:if>
											<td class="agHeaderInnerCont">
												<xsl:value-of select="$agenda_header_text" />
											</td>
										</tr>
									</table>

								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="agItemsCont">
							<xsl:for-each select="/matches/match[contains(style, 'Agenda')]">
								<xsl:call-template name="agenda" />
							</xsl:for-each>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<!-- Create a line to generate margin between two item blocks -->
		<tr>
			<td class="ctBottomMargin">
				<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
			</td>
		</tr>

	</xsl:template>

	<!--
	Central template for ONE agenda item
	-->
	<xsl:template name="agenda">

		<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%" class="emItem emEditable emMoveable">
			<xsl:attribute name="data-sort"><xsl:value-of select="sort_on" /></xsl:attribute>
			<xsl:attribute name="data-ID"><xsl:value-of select="merge_ID" /></xsl:attribute>
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
			<tr>
				<td class="agItemCont">
					<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
						<tr>
							<!-- trigger DATUMBLOK
							The date will be saved as 1 january 2000 when the date fields in the content block details are empty -->
							<xsl:if test="contains(style, 'datumblok') and not(contains(display_playdate_start, '1 januari 2000'))">
								<td class="agDateBlockCont">

									<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
										<tr>
											<td class="agDateBlockInnerCont">
												<xsl:variable name="start_month"><xsl:value-of select="substring(playdate_start, 6, 2)" /></xsl:variable>
												<xsl:variable name="start_day"><xsl:value-of select="substring(playdate_start, 9, 2)" /></xsl:variable>

												<table cellpadding="0" cellspacing="0">
													<tr>
														<td class="agDateBlockDay">
															<xsl:choose>
																<xsl:when test="substring($start_day, 1, 1) = '0'"><xsl:value-of select="substring($start_day, 2, 1)" /></xsl:when>
																<xsl:otherwise><xsl:value-of select="$start_day" /></xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
													<tr>
														<td class="agDateBlockMonth">
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
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>

								</td>
								<td class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</td>
							</xsl:if>

							<!-- trigger DATUM-PLAATJE-TEKST -->
							<xsl:if test="contains(style, 'datum-plaatje-tekst') and not(contains(display_playdate_start, '1 januari 2000'))">
								<td class="agDateTextCont">

									<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
										<tr>
											<td class="agDateTextInnerCont">
												<xsl:call-template name="date_subtitle">
													<xsl:with-param name="row" select="." />
												</xsl:call-template>
											</td>
										</tr>
									</table>

								</td>
								<td class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</td>
							</xsl:if>

							<!-- This will be displayed when using normal agenda block style name and image is set -->
							<xsl:if test="not(contains(style, 'datumblok')) and image != ''">
								<td class="agImgOuterCont">
									<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
										<tr>
											<td class="agImgInnerCont">
												<xsl:choose>
													<xsl:when test="url != ''">
														<a target="_blank">
															<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
															<img border="0">
																<xsl:attribute name="width"><xsl:value-of select="$image_width_agenda" /></xsl:attribute>
																<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width_agenda" />px;</xsl:attribute>
																<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
															</img>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<img>
															<xsl:attribute name="width"><xsl:value-of select="$image_width_agenda" /></xsl:attribute>
															<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width_agenda" />px;</xsl:attribute>
															<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
															<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
															<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
														</img>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</table>
								</td>
								<td class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</td>
							</xsl:if>

							<!-- Content container -->
							<td class="agCtCont">

								<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
									<tr>
										<td class="agCtInnerCont">
											<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

												<!-- Caption with same || option as in ITEMS -->
												<tr>
													<td class="agCapt">
														<xsl:variable name="title">
															<xsl:call-template name="double_pipes">
																<xsl:with-param name="input" select="title" />
															</xsl:call-template>
														</xsl:variable>

														<h2><xsl:value-of select="$title" disable-output-escaping="yes" /></h2>
													</td>
												</tr>

												<!-- Subtitle with same || option as in ITEMS -->
												<xsl:if test="location != ''">
													<tr>
														<td class="agSubt">

															<xsl:variable name="subtitle">
																<xsl:call-template name="double_pipes">
																	<xsl:with-param name="input" select="location" />
																</xsl:call-template>
															</xsl:variable>

															<h4><xsl:value-of select="$subtitle" disable-output-escaping="yes" /></h4>
														</td>
													</tr>
												</xsl:if>

												<!-- Show same date text as ITEMS blocks when no DATUMBLOK and DATUM-PLAATJE-TEKST is triggered -->
												<xsl:if test="not(contains(style, 'datumblok')) and not(contains(style, 'datum-plaatje-tekst'))">
													<tr>
														<td class="agDate">
															<xsl:call-template name="date_subtitle">
																<xsl:with-param name="row" select="." />
															</xsl:call-template>
														</td>
													</tr>
												</xsl:if>

												<!-- Show times when filled and using DATUMBLOK trigger -->
												<xsl:if test="contains(style, 'datumblok') and not(contains(display_playdate_start, '1 januari 2000')) and substring(playdate_start, 12, 5) != '00:00'">
													<tr>
														<td class="agTime">
															<xsl:value-of select="substring(playdate_start, 12, 5)" />

															<xsl:if test="substring(playdate_end, 12, 5) != substring(playdate_start, 12, 5)">
																<xsl:value-of select="$date_time_period_prefix" />
																<xsl:value-of select="substring(playdate_end, 12, 5)" />
															</xsl:if>
														</td>
													</tr>
												</xsl:if>

												<!-- ##JWDB 10 april 2020: content added -->
												<xsl:if test="content != ''">
													<tr>
														<td class="agContent">
															<xsl:value-of select="content" disable-output-escaping="yes" />

															<!-- Show text based readmore button when using DATUM-PLAATJE-TEKST trigger -->
															<xsl:if test="contains(style, 'datum-plaatje-tekst') and url != '' and not(contains(image_alt, 'NOBUTTON'))">
																<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
																<a target="_blank">
																	<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																	<xsl:choose>
																		<xsl:when test="image_alt != ''"><xsl:value-of select="image_alt" /></xsl:when>
																		<xsl:otherwise><xsl:value-of select="$button1_text" /></xsl:otherwise>
																	</xsl:choose>
																</a>
															</xsl:if>
														</td>
													</tr>
												</xsl:if>
											</table>
										</td>
									</tr>
								</table>
							</td>

							<!-- Button, hide when using DATUM-PLAATJE-TEKST trigger -->
							<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON')) and not(contains(style, 'datum-plaatje-tekst'))">
								<td class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</td>
								<td class="agButCont">

									<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
										<tr>
											<td style="agButInnerCont">
												<xsl:call-template name="button">
													<xsl:with-param name="align">right</xsl:with-param>
													<xsl:with-param name="button_default_text" select="$button1_text" />
													<xsl:with-param name="button_text" select="image_alt" />
													<xsl:with-param name="class">ctBut</xsl:with-param>
													<xsl:with-param name="url" select="details_url" />
													<xsl:with-param name="button_icon"><xsl:value-of select="$button_icon" /></xsl:with-param>
												</xsl:call-template>
											</td>
										</tr>
									</table>

								</td>
							</xsl:if>
						</tr>
					</table>
				</td>
			</tr>

		</table>

	</xsl:template>

	<!-- ##JWDB 31 march 2020: central template for replacing input string to multiple lines by replacing double pipes to enters -->
	<xsl:template name="double_pipes">
		<xsl:param name="input" />
		<xsl:param name="replace_with"><xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text></xsl:param>

		<xsl:choose>
			<xsl:when test="contains($input, ' || ')">
				<xsl:value-of select="normalize-space(substring-before($input, ' || '))" disable-output-escaping="yes" />
				<xsl:value-of select="$replace_with" disable-output-escaping="yes" />
				<xsl:choose>
					<xsl:when test="contains(substring-after($input, ' || '), ' || ')">
						<xsl:value-of select="normalize-space(substring-before(substring-after($input, ' || '), ' ||'))" disable-output-escaping="yes" />
						<xsl:value-of select="$replace_with" disable-output-escaping="yes" />
						<xsl:value-of select="normalize-space(substring-after(substring-after($input, ' || '), ' || '))" disable-output-escaping="yes" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(substring-after($input, ' || '))" disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input" disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ##JWDB 10 april 2020: container for the titles -->
	<xsl:template name="titles">

		<tr>
			<td>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="contains(style, 'titels boven') and not(contains(style, 'afb.'))">ctTitlesCont</xsl:when>
						<xsl:when test="contains(style, 'titels boven') and contains(style, 'afb.')">ctTitlesContAfbLr</xsl:when>
						<xsl:when test="content = ''">ctTitlesContNoContent</xsl:when>
						<xsl:otherwise>ctTitlesContBelow</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
					<!--
					Subtitle (db.location)
					You can add 2x double pipes to break subtitle in max 3 lines (||)
					Show this when the style name contains a trigger word 'ondertitel boven'
					-->
					<xsl:if test="location != '' and contains(style, 'ondertitel boven')">
						<tr>
							<td class="ctSubtAbove">

								<xsl:variable name="subtitle">
									<xsl:call-template name="double_pipes">
										<xsl:with-param name="input" select="location" />
									</xsl:call-template>
								</xsl:variable>

								<h4><xsl:value-of select="$subtitle" disable-output-escaping="yes" /></h4>
							</td>
						</tr>
					</xsl:if>

					<!--
                    Title (db.title)
                    You can add 2x double pipes to break title (max 2 double pipes)
                    -->
					<tr>
						<td>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="location != '' and contains(style, 'ondertitel boven')">ctCaptBelow</xsl:when>
									<xsl:otherwise>ctCapt</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>

							<xsl:variable name="title">
								<xsl:call-template name="double_pipes">
									<xsl:with-param name="input" select="title" />
								</xsl:call-template>
							</xsl:variable>

							<xsl:variable name="heading">
								<xsl:choose>
									<xsl:when test="contains(style, '1/3') or contains(style, '2/3')">
										<xsl:text disable-output-escaping="yes"><![CDATA[<h3>]]></xsl:text>
										<xsl:value-of select="$title" disable-output-escaping="yes" />
										<xsl:text disable-output-escaping="yes"><![CDATA[</h3>]]></xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text disable-output-escaping="yes"><![CDATA[<h2>]]></xsl:text>
										<xsl:value-of select="$title" disable-output-escaping="yes" />
										<xsl:text disable-output-escaping="yes"><![CDATA[</h2>]]></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<a>
								<xsl:attribute name="name"><xsl:value-of select="merge_ID" /></xsl:attribute>
								<xsl:value-of select="$heading" disable-output-escaping="yes" />
							</a>
						</td>
					</tr>

					<!--
                    Subtitle (db.location)
                    You can add 2x double pipes to break subtitle in max 3 lines (||)
                    Show this when the titles index are TS (title - subtitle), for banner style only
                    -->
					<xsl:if test="location != '' and not(contains(style, 'ondertitel boven'))">
						<tr>
							<td class="ctSubt">

								<xsl:variable name="subtitle">
									<xsl:call-template name="double_pipes">
										<xsl:with-param name="input" select="location" />
									</xsl:call-template>
								</xsl:variable>

								<h4><xsl:value-of select="$subtitle" disable-output-escaping="yes" /></h4>
							</td>
						</tr>
					</xsl:if>

					<!-- Date
                    When you empty the date fields in the content block details, then the dates will be saved as 1 january 2000.
                    Or you filled in the db.icon field.
                    Hide dates on banner blocks
                    -->
					<xsl:if test="(not(contains(display_playdate_start, '1 januari 2000')) or icon != '') and not(contains(style, 'banner'))">
						<tr>
							<td class="ctDate">
								<xsl:call-template name="date_subtitle">
									<xsl:with-param name="row" select="." />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
				</table>
			</td>
		</tr>

	</xsl:template>

	<!-- That's all folks !!
	kind regards from the DeBoer Cousins
	-->

</xsl:stylesheet>