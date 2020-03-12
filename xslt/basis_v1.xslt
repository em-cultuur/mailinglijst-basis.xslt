<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />
	<xsl:template match="/">

		<!-- EM-Cultuur (c) 2020
		Basis XSLT for building new templates -->

		<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="tblMain">

			<!-- BASIC STYLES FOR ALL ITEMS -->
			<!-- Marge between each rows -->
			<xsl:variable name="block_marge">25</xsl:variable>

			<!-- AGENDA -->
			<!-- Header style -->
			<xsl:variable name="agendaheader_style">color: #333333; font-family: Arial; font-weight: bold; padding: 25px; padding-bottom: 0px; border-top: 3px solid #333333; font-size: 24px; line-height: 27px; padding-bottom: 25px;</xsl:variable>

			<!-- Items container style -->
			<xsl:variable name="agendacontainer_style">background-color: #FFFFFF; padding: 25px; padding-bottom: 10px;</xsl:variable>

			<!-- END STYLES -->

			<!-- Loop through every items with styles starting with Item (normal items) -->
			<xsl:for-each select="matches/match[contains(style, 'Item')]">

				<!-- SPECIFIC STYLES -->

				<!-- Basic widths of column, the widths below are based on basic and ideal width of 700px -->
				<xsl:variable name="width">
					<xsl:choose>
						<xsl:when test="contains(style, '1/2')">337</xsl:when>
						<xsl:when test="contains(style, '1/3')">216</xsl:when>
						<xsl:when test="contains(style, '2/3')">458</xsl:when>
						<xsl:otherwise>700</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Image widths and styles for afb. links and afb. rechts styles -->
				<xsl:variable name="image_width">335</xsl:variable>
				<xsl:variable name="imagecolumn_style">vertical-align: top; width: <xsl:value-of select="$image_width + 15" />;</xsl:variable> <!-- Plus padding size -->
				<xsl:variable name="imageleftcolumn_style">padding: 15px; padding-right: 0px;</xsl:variable>
				<xsl:variable name="imagerightcolumn_style">padding: 15px; padding-left: 0px;</xsl:variable>

				<!-- Marge between columns with 1/2, 1/3 and 2/3 styles -->
				<xsl:variable name="column_marge">
					<xsl:choose>
						<xsl:when test="contains(style, '1/2')">26</xsl:when>
						<xsl:otherwise>26</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Body/column background-color -->
				<xsl:variable name="column_background_color">
					<xsl:choose>
						<xsl:when test="extra1 != ''"><xsl:value-of select="extra1" /></xsl:when>
						<xsl:when test="contains(style, 'uitgelicht')">#333333</xsl:when>
						<xsl:otherwise>#FFFFFF</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Custom title size in each style -->
				<xsl:variable name="title_size">
					<xsl:choose>
						<xsl:when test="contains(style, '1/2')">24</xsl:when>
						<xsl:when test="contains(style, '1/3')">16</xsl:when>
						<xsl:when test="contains(style, '2/3')">24</xsl:when>
						<xsl:otherwise>24</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="title_lineheight">
					<xsl:choose>
						<xsl:when test="contains(style, '1/2')">27</xsl:when>
						<xsl:when test="contains(style, '1/3')">19</xsl:when>
						<xsl:when test="contains(style, '2/3')">27</xsl:when>
						<xsl:otherwise>27</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Styles for header style -->
				<xsl:variable name="header_style">color: #333333; font-family: Arial; font-weight: bold; padding: 25px; padding-bottom: 0px; border-top: 3px solid #333333; font-size: <xsl:value-of select="$title_size" />px; line-height: <xsl:value-of select="$title_lineheight" />px;</xsl:variable>

				<!-- Styles for call2action style -->
				<xsl:variable name="call2action_style">
					<xsl:choose>
						<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">background-color: #FFFFFF; color: #FFFFFF; font-family: Arial; font-size: 16px; padding: 20px; padding-top: 10px; padding-bottom: 10px; font-weight: bold;</xsl:when>
						<xsl:otherwise>background-color: #333333; color: #FFFFFF; font-family: Arial; font-size: 16px; padding: 20px; padding-top: 10px; padding-bottom: 10px; font-weight: bold;</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Styles for buttons -->
				<xsl:variable name="buttonscontainer_style">padding: 25px; padding-top: 0px;</xsl:variable>
				<xsl:variable name="buttonlink_style">
					<xsl:choose>
						<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">color: #333333; text-decoration: none;</xsl:when>
						<xsl:otherwise>color: #FFFFFF; text-decoration: none;</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="button_style">
					<xsl:choose>
						<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">background-color: #FFFFFF; color: #FFFFFF; font-family: Arial; font-size: 14px; padding: 20px; padding-top: 10px; padding-bottom: 10px;</xsl:when>
						<xsl:otherwise>background-color: #333333; color: #FFFFFF; font-family: Arial; font-size: 14px; padding: 20px; padding-top: 10px; padding-bottom: 10px;</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="button2link_style">
					<xsl:choose>
						<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">color: #333333; text-decoration: none;</xsl:when>
						<xsl:otherwise>color: #FFFFFF; text-decoration: none;</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="button2_style">
					<xsl:choose>
						<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">background-color: #FFFFFF; color: #FFFFFF; font-family: Arial; font-size: 14px; padding: 20px; padding-top: 10px; padding-bottom: 10px;</xsl:when>
						<xsl:otherwise>background-color: #666666; color: #FFFFFF; font-family: Arial; font-size: 14px; padding: 20px; padding-top: 10px; padding-bottom: 10px;</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- END SPECIFIC STYLES -->

				<!-- Start rule for each row, determite it on the position or rule_end of previous item -->
				<xsl:if test="position() = 1 or preceding-sibling::*[1]/rule_end = 'true'">
					<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
				</xsl:if>

				<xsl:if test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (position() = 1 or preceding-sibling::*[1]/rule_end = 'true')">
					<xsl:text disable-output-escaping="yes"><![CDATA[<td><table cellpadding="0" cellspacing="0"><tr><td style="padding-bottom: ]]></xsl:text><xsl:value-of select="$block_marge" /><xsl:text disable-output-escaping="yes"><![CDATA[px;"><table cellpadding="0" cellspacing="0"><tr>]]></xsl:text>
				</xsl:if>

				<!-- Basic column -->
				<xsl:choose>
					<!-- Item (header) style -->
					<xsl:when test="contains(style, 'header')">
						<td class="tdColumn">
							<xsl:attribute name="style">vertical-align: top; padding-bottom: <xsl:value-of select="$block_marge" />px;</xsl:attribute>

							<table cellpadding="0" cellspacing="0" class="tblMain">
								<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
								<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;</xsl:attribute>
								<tr>
									<td>

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
												<td>
													<xsl:attribute name="style"><xsl:value-of select="$header_style" /></xsl:attribute>
													<xsl:value-of select="title" disable-output-escaping="yes" />
												</td>
											</tr>

										</table>
									</td>
								</tr>
							</table>
						</td>
					</xsl:when>

					<!-- Item (call2action) style -->
					<xsl:when test="contains(style, 'call2action')">
						<td class="tdColumn">
							<xsl:attribute name="style">vertical-align: top; padding-bottom: <xsl:value-of select="$block_marge" />px;</xsl:attribute>

							<table cellpadding="0" cellspacing="0" class="tblMain">
								<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
								<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;</xsl:attribute>
								<tr>
									<td>

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
												<td>

													<xsl:choose>
														<xsl:when test="url != ''">

															<a target="_blank" class="White">
																<xsl:attribute name="style"><xsl:value-of select="$buttonlink_style" /></xsl:attribute>
																<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
																	<tr>
																		<td>
																			<xsl:attribute name="style"><xsl:value-of select="$call2action_style" /></xsl:attribute>

																			<center>
																				<a target="_blank" class="White">
																					<xsl:attribute name="style"><xsl:value-of select="$buttonlink_style" /></xsl:attribute>
																					<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																					<xsl:value-of select="title" />
																				</a>
																			</center>

																		</td>
																	</tr>
																</table>
															</a>

														</xsl:when>
														<xsl:otherwise>

															<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
																<tr>
																	<td>
																		<xsl:attribute name="style"><xsl:value-of select="$call2action_style" /></xsl:attribute>
																		<center><xsl:value-of select="title" /></center>
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
							</table>
						</td>
					</xsl:when>

					<!-- Item (agenda) style
					This will override the Agenda block below
					Allows possibility to move Agenda block between normal Items
					You have still to create Agenda items-->
					<xsl:when test="contains(style, 'agenda')">

						<td class="tdColumn">
							<xsl:attribute name="style">vertical-align: top; padding-bottom: <xsl:value-of select="$block_marge" />px;</xsl:attribute>

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
										<xsl:attribute name="style"><xsl:value-of select="$agendaheader_style" /></xsl:attribute>
										<xsl:value-of select="title" />
									</td>
								</tr>
							</table>
							<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
								<tr>
									<td>
										<xsl:attribute name="style"><xsl:value-of select="$agendacontainer_style" /></xsl:attribute>

										<xsl:for-each select="/matches/match[contains(style, 'Agenda')]">

											<xsl:call-template name="agenda" />

										</xsl:for-each>

									</td>
								</tr>
							</table>

						</td>

					</xsl:when>

					<xsl:otherwise>

						<td class="tdColumn">
							<xsl:attribute name="style">
								<xsl:choose>
									<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">vertical-align: top; background-color: <xsl:value-of select="$column_background_color" />;</xsl:when>
									<xsl:otherwise>vertical-align: top; padding-bottom: <xsl:value-of select="$block_marge" />px;</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>

							<table cellpadding="0" cellspacing="0" class="tblMain">
								<xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
								<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;</xsl:attribute>
								<tr>
									<td>
										<xsl:attribute name="style">background-color: <xsl:value-of select="$column_background_color" />;</xsl:attribute>

										<!-- Used for link colors -->
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="contains(style, 'uitgelicht') or extra1 != ''">tdWhite</xsl:when>
												<xsl:otherwise>tdBlack</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>

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
                                            When a placeholder is used, then this item is created automatically after a new mailing were created
                                            The default placeholder is a square so 700x700 don't looks fancy... -->
											<xsl:if test="image != '' and not(contains(style, 'afb.'))">
												<tr>
													<td class="tdImage">
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
													</td>
												</tr>
											</xsl:if>

											<!-- When image only style is used and no image were choosed, show message to prevent the item block cannot be edited anymore -->
											<xsl:if test="image = '' and contains(style, 'afbeelding')">
												<tr>
													<td>
														GEEN AFBEELDING
													</td>
												</tr>
											</xsl:if>

											<!-- Content and buttons container
                                            When using Item (afbeelding) style, hide this entire part -->
											<xsl:if test="not(contains(style, '(afbeelding)'))">
												<tr>
													<td>
														<xsl:attribute name="style">background-color: <xsl:value-of select="$column_background_color" />;</xsl:attribute>

														<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
															<xsl:attribute name="dir">
																<xsl:choose>
																	<xsl:when test="contains(style, 'afb. rechts')">rtl</xsl:when>
																	<xsl:otherwise>ltr</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
															<tr>
																<!-- Image left or right
																 Using DIR logic, so both left and right will be shown above when viewing on mobile
																 -->
																<xsl:if test="(contains(style, 'afb. links') or contains(style, 'afb. rechts')) and image != ''">
																	<td class="tdImageColumn">
																		<xsl:attribute name="style"><xsl:value-of select="$imagecolumn_style" /></xsl:attribute>

																		<table width="100%" cellpadding="0" cellspacing="0">
																			<tr>
																				<td>
																					<xsl:attribute name="style">
																						<xsl:choose>
																							<xsl:when test="contains(style, 'afb. rechts')"><xsl:value-of select="$imagerightcolumn_style" /></xsl:when>
																							<xsl:otherwise><xsl:value-of select="$imageleftcolumn_style" /></xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<xsl:choose>
																						<xsl:when test="url != ''">
																							<a target="_blank">
																								<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																								<img border="0">
																									<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
																									<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																									<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																									<xsl:attribute name="width"><xsl:value-of select="$image_width" /></xsl:attribute>
																									<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width" />px;</xsl:attribute>
																								</img>
																							</a>
																						</xsl:when>
																						<xsl:otherwise>
																							<img>
																								<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
																								<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																								<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																								<xsl:attribute name="width"><xsl:value-of select="$image_width" /></xsl:attribute>
																								<xsl:attribute name="style">display: block; width: <xsl:value-of select="$image_width" />px;</xsl:attribute>
																							</img>
																						</xsl:otherwise>
																					</xsl:choose>
																				</td>
																			</tr>
																		</table>
																	</td>
																</xsl:if>

																<!-- Column with text content and buttons -->
																<td class="tdContentColumn" style="vertical-align: top;" dir="ltr">

																	<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

																		<!-- Hide entire title part when Item (zonder titel) style is used of NOTITLE in the title field is filled (case sensitive!!) -->
																		<xsl:if test="not(contains(style, 'zonder titel')) and not(contains(title, 'NOTITLE'))">

																			<!-- Title -->
																			<tr>
																				<td class="tdCaption">
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

																			<!-- Subtitle (the DB field location is used as subtitle mostly -->
																			<xsl:if test="location != ''">
																				<tr>
																					<td class="tdSubtitle">
																						<h4><xsl:value-of select="location" disable-output-escaping="yes" /></h4>
																					</td>
																				</tr>
																			</xsl:if>

																			<xsl:if test=""

																		</xsl:if>

																		<!-- Content -->
																		<tr>
																			<td class="tdContent">
																				<xsl:value-of select="content" disable-output-escaping="yes" />
																			</td>
																		</tr>

																		<!-- Two buttons
                                                                        image_alt DB column is used as alternative button text ('1e veld' name in ML)
                                                                        icon2 DB column is ised as alternative button text for second button
                                                                        When 1/3 style is used, seperate two buttons into two rows -->
																		<xsl:if test="url != '' or url2 != ''">
																			<tr>
																				<td>
																					<xsl:attribute name="style"><xsl:value-of select="$buttonscontainer_style" /></xsl:attribute>

																					<table cellpadding="0" cellspacing="0" class="tblReadMore">
																						<!-- Button 1 -->
																						<xsl:if test="url != ''">
																							<xsl:if test="contains(style, '1/3')">
																								<xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text>
																							</xsl:if>
																							<td class="tdButtonColumn">
																								<xsl:attribute name="style">
																									<xsl:choose>
																										<xsl:when test="url2 != '' and not(contains(style, '1/3'))">padding-right: 15px;</xsl:when>
																										<xsl:otherwise>padding-right: 0px;</xsl:otherwise>
																									</xsl:choose>
																								</xsl:attribute>
																								<a target="_blank" class="White">
																									<xsl:attribute name="style"><xsl:value-of select="$buttonlink_style" /></xsl:attribute>
																									<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																									<table cellpadding="0" cellspacing="0">
																										<tr>
																											<td>
																												<xsl:attribute name="style"><xsl:value-of select="$button_style" /></xsl:attribute>

																												<a target="_blank" class="White">
																													<xsl:attribute name="style"><xsl:value-of select="$buttonlink_style" /></xsl:attribute>
																													<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																													<xsl:choose>
																														<xsl:when test="image_alt != ''"><xsl:value-of select="image_alt" /></xsl:when>
																														<xsl:otherwise>Lees verder</xsl:otherwise>
																													</xsl:choose>
																												</a>
																											</td>
																										</tr>
																									</table>
																								</a>
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
																							<td class="tdButtonColumn">
																								<xsl:attribute name="style">
																									<xsl:choose>
																										<xsl:when test="contains(style, '1/3')">padding-top: 10px;</xsl:when>
																										<xsl:otherwise>padding-top: 0px;</xsl:otherwise>
																									</xsl:choose>
																								</xsl:attribute>
																								<a target="_blank" class="White">
																									<xsl:attribute name="style"><xsl:value-of select="$button2link_style" /></xsl:attribute>
																									<xsl:attribute name="href"><xsl:value-of select="details_url2" /></xsl:attribute>
																									<table cellpadding="0" cellspacing="0">
																										<tr>
																											<td>
																												<xsl:attribute name="style"><xsl:value-of select="$button2_style" /></xsl:attribute>
																												<a target="_blank" class="White">
																													<xsl:attribute name="style"><xsl:value-of select="$button2link_style" /></xsl:attribute>
																													<xsl:attribute name="href"><xsl:value-of select="details_url2" /></xsl:attribute>
																													<xsl:choose>
																														<xsl:when test="icon2 != ''"><xsl:value-of select="icon2" /></xsl:when>
																														<xsl:otherwise>Koop kaarten</xsl:otherwise>
																													</xsl:choose>
																												</a>
																											</td>
																										</tr>
																									</table>
																								</a>
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
											</xsl:if>

											<!-- Image below
                                            When a placeholder is used, then this item is created automatically after a new mailing were created
                                            The default placeholder is a square so 700x700 don't looks fancy... -->
											<xsl:if test="image != '' and contains(style, 'afb. onder')">
												<tr>
													<td class="tdImage">
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
													</td>
												</tr>
											</xsl:if>

										</table>
									</td>
								</tr>
							</table>
						</td>

					</xsl:otherwise>
				</xsl:choose>

				<!-- Ending rules -->
				<xsl:choose>
					<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">
						<xsl:if test="rule_end != 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<td class="tdColumnMarge" style="width: ]]></xsl:text><xsl:value-of select="$column_marge" /><xsl:text disable-output-escaping="yes"><![CDATA[px;">&nbsp;</td>]]></xsl:text></xsl:if>

						<xsl:if test="position() = last() or rule_end = 'true'">
							<xsl:text disable-output-escaping="yes"><![CDATA[</tr></table></td></tr></table></td>]]></xsl:text>
						</xsl:if>
					</xsl:when>
				</xsl:choose>

				<xsl:if test="rule_end = 'true' or position() = last()">
					<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
				</xsl:if>

			</xsl:for-each>

			<!-- AGENDA -->
			<xsl:if test="count(matches/match[contains(style, 'Agenda')]) != 0 and count(matches/match[style = 'Item (agenda)']) = 0">

				<tr>
					<td>

						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<xsl:attribute name="style"><xsl:value-of select="$agendaheader_style" /></xsl:attribute>
									In de agenda
								</td>
							</tr>
							<tr>
								<td>
									<xsl:attribute name="style"><xsl:value-of select="$agendacontainer_style" /></xsl:attribute>

									<xsl:for-each select="matches/match[contains(style, 'Agenda')]">

										<xsl:call-template name="agenda" />

									</xsl:for-each>

								</td>
							</tr>
						</table>
					</td>
				</tr>
			</xsl:if>
		</table>

	</xsl:template>

	<xsl:template name="agenda">

		<!-- AGENDA SPECIFIC STYLES -->

		<!-- Content style -->
		<xsl:variable name="agendacontent_style">color: #333333; font-family: Arial; padding-bottom: 15px; font-size: 14px; line-height: 20px;</xsl:variable>

		<!-- Button styles -->
		<xsl:variable name="agendabuttonlink_style">color: #FFFFFF; text-decoration: none;</xsl:variable>
		<xsl:variable name="agendabuttoncontainer_style">padding-bottom: 15px;</xsl:variable>
		<xsl:variable name="agendabutton_style">background-color: #333333; color: #FFFFFF; font-family: Arial; font-size: 14px; padding: 20px; padding-top: 10px; padding-bottom: 10px;</xsl:variable>
		<!-- END AGENDA SPECIFIC STYLES -->

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
				<td class="tdCaption">
					<xsl:attribute name="style"><xsl:value-of select="$agendacontent_style" /></xsl:attribute>

					<strong><xsl:value-of select="title" disable-output-escaping="yes" /></strong>
					<xsl:if test="location != ''">
						<br />
						<xsl:value-of select="location" disable-output-escaping="yes" />
					</xsl:if>

					<xsl:choose>
						<xsl:when test="icon != ''">
							<br />
							<xsl:value-of select="icon" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="start_date"><xsl:value-of select="substring-before(playdate_start, 'T')" /></xsl:variable>
							<xsl:variable name="start_year"><xsl:value-of select="substring-before($start_date,'-')" /></xsl:variable>
							<xsl:variable name="start_month"><xsl:value-of select="substring(playdate_start, 6, 2)" /></xsl:variable>
							<xsl:variable name="start_day"><xsl:value-of select="substring(playdate_start, 9, 2)" /></xsl:variable>

							<xsl:variable name="start_a" select="floor((14 - $start_month) div 12)"/>
							<xsl:variable name="start_y" select="$start_year - $start_a"/>
							<xsl:variable name="start_m" select="$start_month + 12 * $start_a - 2"/>

							<xsl:variable name="start_weekday" select="($start_day + $start_y + floor($start_y div 4) - floor($start_y div 100) + floor($start_y div 400) + floor((31 * $start_m) div 12)) mod 7" />

							<xsl:variable name="end_date"><xsl:value-of select="substring-before(playdate_end, 'T')" /></xsl:variable>
							<xsl:variable name="end_year"><xsl:value-of select="substring-before($end_date,'-')" /></xsl:variable>
							<xsl:variable name="end_month"><xsl:value-of select="substring(playdate_end, 6, 2)" /></xsl:variable>
							<xsl:variable name="end_day"><xsl:value-of select="substring(playdate_end, 9, 2)" /></xsl:variable>

							<xsl:variable name="end_a" select="floor((14 - $end_month) div 12)"/>
							<xsl:variable name="end_y" select="$end_year - $end_a"/>
							<xsl:variable name="end_m" select="$end_month + 12 * $end_a - 2"/>

							<xsl:variable name="end_weekday" select="($end_day + $end_y + floor($end_y div 4) - floor($end_y div 100) + floor($end_y div 400) + floor((31 * $end_m) div 12)) mod 7" />

							<xsl:if test="$start_year != '2000'">
								<br />
								<xsl:choose>
									<xsl:when test="display_playdate_start != display_playdate_end">

										<xsl:choose>
											<xsl:when test="$start_weekday = '0'">zo</xsl:when>
											<xsl:when test="$start_weekday = '1'">ma</xsl:when>
											<xsl:when test="$start_weekday = '2'">di</xsl:when>
											<xsl:when test="$start_weekday = '3'">wo</xsl:when>
											<xsl:when test="$start_weekday = '4'">do</xsl:when>
											<xsl:when test="$start_weekday = '5'">vr</xsl:when>
											<xsl:when test="$start_weekday = '6'">za</xsl:when>
										</xsl:choose>

										<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

										<xsl:choose>
											<xsl:when test="substring($start_day, 1, 1) = '0'"><xsl:value-of select="substring($start_day, 2, 1)" /></xsl:when>
											<xsl:otherwise><xsl:value-of select="$start_day" /></xsl:otherwise>
										</xsl:choose>

										<xsl:if test="$start_month != $end_month">

											<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

											<xsl:choose>
												<xsl:when test="$start_month = '01'">jan</xsl:when>
												<xsl:when test="$start_month = '02'">feb</xsl:when>
												<xsl:when test="$start_month = '03'">mrt</xsl:when>
												<xsl:when test="$start_month = '04'">apr</xsl:when>
												<xsl:when test="$start_month = '05'">mei</xsl:when>
												<xsl:when test="$start_month = '06'">jun</xsl:when>
												<xsl:when test="$start_month = '07'">jul</xsl:when>
												<xsl:when test="$start_month = '08'">aug</xsl:when>
												<xsl:when test="$start_month = '09'">sep</xsl:when>
												<xsl:when test="$start_month = '10'">okt</xsl:when>
												<xsl:when test="$start_month = '11'">nov</xsl:when>
												<xsl:when test="$start_month = '12'">dec</xsl:when>
											</xsl:choose>

											<!-- Find a better solution for hardcoded year -->
											<xsl:if test="$start_year != '2020'">
												<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>
												<xsl:value-of select="$start_year" />
											</xsl:if>

										</xsl:if>

										<xsl:if test="substring(playdate_start, 12, 5) != substring(playdate_end, 12, 5)">
											<xsl:text disable-output-escaping="yes"><![CDATA[ om ]]></xsl:text>
											<xsl:value-of select="substring(playdate_start, 12, 5)" />
										</xsl:if>

										<xsl:choose>
											<xsl:when test="$end_weekday = '0'">zo</xsl:when>
											<xsl:when test="$end_weekday = '1'">ma</xsl:when>
											<xsl:when test="$end_weekday = '2'">di</xsl:when>
											<xsl:when test="$end_weekday = '3'">wo</xsl:when>
											<xsl:when test="$end_weekday = '4'">do</xsl:when>
											<xsl:when test="$end_weekday = '5'">vr</xsl:when>
											<xsl:when test="$end_weekday = '6'">za</xsl:when>
										</xsl:choose>

										<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

										<xsl:choose>
											<xsl:when test="substring($end_day, 1, 1) = '0'"><xsl:value-of select="substring($end_day, 2, 1)" /></xsl:when>
											<xsl:otherwise><xsl:value-of select="$end_day" /></xsl:otherwise>
										</xsl:choose>

										<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

										<xsl:choose>
											<xsl:when test="$end_month = '01'">jan</xsl:when>
											<xsl:when test="$end_month = '02'">feb</xsl:when>
											<xsl:when test="$end_month = '03'">mrt</xsl:when>
											<xsl:when test="$end_month = '04'">apr</xsl:when>
											<xsl:when test="$end_month = '05'">mei</xsl:when>
											<xsl:when test="$end_month = '06'">jun</xsl:when>
											<xsl:when test="$end_month = '07'">jul</xsl:when>
											<xsl:when test="$end_month = '08'">aug</xsl:when>
											<xsl:when test="$end_month = '09'">sep</xsl:when>
											<xsl:when test="$end_month = '10'">okt</xsl:when>
											<xsl:when test="$end_month = '11'">nov</xsl:when>
											<xsl:when test="$end_month = '12'">dec</xsl:when>
										</xsl:choose>

										<xsl:if test="$end_year != '2020'">
											<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>
											<xsl:value-of select="$end_year" />
										</xsl:if>

										<xsl:if test="substring(playdate_end, 12, 5) != '00:00'">
											<xsl:text disable-output-escaping="yes"><![CDATA[ om ]]></xsl:text>
											<xsl:value-of select="substring(playdate_end, 12, 5)" />
										</xsl:if>

									</xsl:when>
									<xsl:otherwise>

										<xsl:choose>
											<xsl:when test="$start_weekday = '0'">zo</xsl:when>
											<xsl:when test="$start_weekday = '1'">ma</xsl:when>
											<xsl:when test="$start_weekday = '2'">di</xsl:when>
											<xsl:when test="$start_weekday = '3'">wo</xsl:when>
											<xsl:when test="$start_weekday = '4'">do</xsl:when>
											<xsl:when test="$start_weekday = '5'">vr</xsl:when>
											<xsl:when test="$start_weekday = '6'">za</xsl:when>
										</xsl:choose>

										<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

										<xsl:choose>
											<xsl:when test="substring($start_day, 1, 1) = '0'"><xsl:value-of select="substring($start_day, 2, 1)" /></xsl:when>
											<xsl:otherwise><xsl:value-of select="$start_day" /></xsl:otherwise>
										</xsl:choose>

										<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>

										<xsl:choose>
											<xsl:when test="$start_month = '01'">jan</xsl:when>
											<xsl:when test="$start_month = '02'">feb</xsl:when>
											<xsl:when test="$start_month = '03'">mrt</xsl:when>
											<xsl:when test="$start_month = '04'">apr</xsl:when>
											<xsl:when test="$start_month = '05'">mei</xsl:when>
											<xsl:when test="$start_month = '06'">jun</xsl:when>
											<xsl:when test="$start_month = '07'">jul</xsl:when>
											<xsl:when test="$start_month = '08'">aug</xsl:when>
											<xsl:when test="$start_month = '09'">sep</xsl:when>
											<xsl:when test="$start_month = '10'">okt</xsl:when>
											<xsl:when test="$start_month = '11'">nov</xsl:when>
											<xsl:when test="$start_month = '12'">dec</xsl:when>
										</xsl:choose>

										<!-- Find a better solution for hardcoded year -->
										<xsl:if test="$start_year != '2020'">
											<xsl:text disable-output-escaping="yes"><![CDATA[ ]]></xsl:text>
											<xsl:value-of select="$start_year" />
										</xsl:if>

										<xsl:if test="substring(playdate_start, 12, 5) != '00:00'">
											<xsl:text disable-output-escaping="yes"><![CDATA[ om ]]></xsl:text>
											<xsl:value-of select="substring(playdate_start, 12, 5)" />
										</xsl:if>

										<xsl:if test="substring(playdate_end, 12, 5) != '00:00' and substring(playdate_end, 12, 5) != substring(playdate_start, 12, 5)">
											<xsl:text disable-output-escaping="yes"><![CDATA[ t/m ]]></xsl:text>
											<xsl:value-of select="substring(playdate_end, 12, 5)" />
										</xsl:if>

									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>

				</td>
				<xsl:if test="url != ''">
					<td>
						<xsl:attribute name="style"><xsl:value-of select="$agendabuttoncontainer_style" /></xsl:attribute>
						<a target="_blank" class="White">
							<xsl:attribute name="style"><xsl:value-of select="$agendabuttonlink_style" /></xsl:attribute>
							<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

							<table cellpadding="0" cellspacing="0" align="right">
								<tr>
									<td>
										<xsl:attribute name="style"><xsl:value-of select="$agendabutton_style" /></xsl:attribute>
										<a target="_blank" style="color: #FFFFFF;" class="White">
											<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
											<xsl:attribute name="style"><xsl:value-of select="$agendabuttonlink_style" /></xsl:attribute>
											<xsl:choose>
												<xsl:when test="image_alt != ''"><xsl:value-of select="image_alt" /></xsl:when>
												<xsl:otherwise>Lees verder</xsl:otherwise>
											</xsl:choose>
										</a>
									</td>
								</tr>
							</table>
						</a>
					</td>
				</xsl:if>
			</tr>

		</table>

	</xsl:template>

</xsl:stylesheet>
