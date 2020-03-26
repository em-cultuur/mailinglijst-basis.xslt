<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />

	<!-- Basis  v1
	XSLT for BLOCKS in MailingLijst-templates
	(c) EM-Cultuur, 2020

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

	<xsl:variable name="date_period_prefix"> t/m </xsl:variable>
	<xsl:variable name="date_time_prefix"> om </xsl:variable>
	<xsl:variable name="date_time_period_prefix"> - </xsl:variable>

	<xsl:template match="/">

		<!-- STYLE BLOCK
		This have to be copied with the final CSS from HTML.
		You can minify this on this website: https://cssminifier.com/
		-->
		<style typ="text/css">
			@import url(https://fonts.googleapis.com/css?family=Lato:400,400i,700,700i|Prata&amp;display=swap);html{width:100%;padding:0;margin:0}body{width:100%;margin:0;padding:0;background-color:#f5f5f5}.content a,a,td{font-family:Lato,sans-serif;color:#696969;font-size:14px;line-height:20px}h1,h2,h3,h4{font-family:Prata,serif;color:#cd5c5c;margin:0}.hdCont{background-color:#a9a9a9;padding:15px}.hdShow,.hdShow a{color:#fff}.hdShow{text-align:right}.hdShow a{text-decoration:underline}.headShow a:hover{text-decoration:none}.hdLogo{padding-bottom:15px}.hdEdition h1{color:#cd5c5c;font-size:24px;line-height:30px}.ftCont{padding:15px;text-align:center;background-color:#a9a9a9}.ftCont a{color:#696969;text-decoration:underline}.ftCont a:hover{text-decoration:none}.ftCont a img{border:0}.ctInnerCont,.ctMainBlock,.ctMainBlockItem{background-color:#fff;vertical-align:top}.ctInnerContFeat,.ctMainBlockFeat,.ctMainBlockItemFeat{background-color:#696969;vertical-align:top}.ctInnerContBan,.ctMainBlockBan{background-color:#cd5c5c}.ctBottomMargin{height:20px;font-size:1px;line-height:1px}.ctBlockMargin{width:20px;font-size:1px;line-height:1px}.ctCapt{padding:15px;padding-bottom:0}.ctCapt h2,.ctCapt h3{font-size:20px;line-height:28px;color:#cd5c5c;font-weight:700}.ctCapt h3{font-size:16px;line-height:24px}.ctInnerContFeat .ctCapt h2,.ctInnerContFeat .ctCapt h3{color:#fff}.ctInnerContBan .ctCapt{padding-top:0}.ctInnerContBan .ctCapt h2,.ctInnerContBan .ctCapt h3{color:#fff;font-size:28px;line-height:36px}.ctSubt{padding:15px;padding-top:0;padding-bottom:0}.ctSubt h4{color:gray;font-size:16px;line-height:24px;font-weight:400}.ctInnerContBan .ctSubt h4,.ctInnerContFeat .ctSubt h4{color:#fff}.ctDate{padding:15px;padding-top:0;padding-bottom:0;color:silver;font-size:14px;line-height:20px;font-weight:400}.ctInnerContFeat .ctDate{color:#fff}.content,.content a{font-size:14px;line-height:20px}.content{padding:15px}.content a{text-decoration:underline}.content a:hover{text-decoration:none}.ctInnerContFeat .content,.ctInnerContFeat .content a{color:#fff}.ctOuterBlock{vertical-align:top}.ctInnerContBan .ctOuterBlock{vertical-align:middle}.ctInnerContBan .ctInnerBlock{padding-top:15px;padding-bottom:15px}.ctImgLeftOuterBlock,.ctImgRightOuterBlock{width:235px;vertical-align:top}.ctImgLeftOuterBlockBan,.ctImgRightOuterBlockBan{width:220px;vertical-align:top}.ctImgLeftInnerBlock,.ctImgRightInnerBlock{padding:15px}.ctImgRightInnerBlock{padding-left:0}.ctImgLeftInnerBlock{padding-right:0}.ctImgSubt{font-size:12px;line-height:16px;padding:15px;padding-bottom:0;padding-top:5px}.ctInnerContBan .ctImgSubt,.ctInnerContFeat .ctImgSubt{color:#fff}.ctImgLeftInnerBlock .ctImgSubt,.ctImgRightInnerBlock .ctImgSubt{padding-left:5px;text-align:left}.ctImgLeftInnerBlockBan .ctImgSubt,.ctImgRightInnerBlockBan .ctImgSubt{padding-left:5px;padding-bottom:5px;text-align:left}.ctButCont{background-color:#fff;vertical-align:top}.ctButContFeat{background-color:#696969;vertical-align:top}.ctButContBan{background-color:#cd5c5c;vertical-align:top}.ctButInnerCont{padding:15px;padding-top:0}.ctButContBan .ctButInnerCont{padding-top:15px;padding-bottom:0}.ctBut{background-color:#696969;color:#fff;font-size:14px;padding:20px;padding-top:10px;padding-bottom:10px}.ctBut:hover{background-color:#000}.ctBut2{background-color:#cd5c5c;color:#fff;font-size:14px;padding:20px;padding-top:10px;padding-bottom:10px}.ctBut2:hover{background-color:red}.ctButBlock a{color:#fff;text-decoration:none}.ctButContBan .ctBut,.ctButContBan .ctBut2,.ctButContBan .ctBut2:hover,.ctButContBan .ctBut:hover,.ctButContFeat .ctBut,.ctButContFeat .ctBut2,.ctButContFeat .ctBut2:hover,.ctButContFeat .ctBut:hover,.ctMobButContBan .ctBut,.ctMobButContBan .ctBut2,.ctMobButContBan .ctBut2:hover,.ctMobButContBan .ctBut:hover,.ctMobButContFeat .ctBut,.ctMobButContFeat .ctBut2,.ctMobButContFeat .ctBut2:hover,.ctMobButContFeat .ctBut:hover{background-color:#fff}.ctButContBan .ctButBlock a,.ctButContFeat .ctButBlock a,.ctMobButContBan .ctButBlock a,.ctMobButContFeat .ctButBlock a{color:#696969}.ctCallInnerCont{background-color:#696969;text-align:center;padding:15px;padding-top:10px;padding-bottom:10px}.ctCallInnerCont h2{color:#fff;font-size:20px;line-height:28px;font-family:Lato,sans-serif;font-weight:400}.ctCallInnerCont h2 a{font-size:20px;line-height:28px}.ctCallOuterCont a{text-decoration:none;color:#fff}.ctSubhInnerCont,.ctSubhInnerContFeat{border-bottom:2px solid #cd5c5c;padding-bottom:10px}.ctSubhInnerContFeat{border-bottom:2px solid #696969}.ctSubhInnerCont h2,.ctSubhInnerContFeat h2{color:#cd5c5c;font-size:20px;line-height:28px;font-family:Lato,sans-serif;font-weight:400}.ctSubhInnerContFeat h2{color:#696969}.agHeaderOuterCont{background-color:#fff;padding:15px;padding-bottom:0}.agHeaderInnerCont{font-size:20px;line-height:28px;color:#cd5c5c}.agItemsCont{background-color:#fff;padding:15px;padding-bottom:0}.agItemCont{padding-bottom:15px}.agDateBlockCont{width:65px;vertical-align:top}.agDateBlockDay,.agDateBlockMonth{background-color:#cd5c5c;padding:5px;text-align:center;width:40px;color:#fff;font-weight:700}.agDateBlockDay{padding-bottom:0;font-size:18px;line-height:22px}.agDateBlockMonth{padding-top:0}.agImgOuterCont{width:140px;vertical-align:top}.agCtCont{vertical-align:top}.agCapt h2{font-size:20px;line-height:28px;color:#696969;font-weight:700}.agSubt h4{color:gray;font-size:16px;line-height:24px;font-weight:400}.agDate,.agTime{color:silver;font-size:14px;line-height:20px;font-weight:400}.agButCont a{color:#fff;text-decoration:none}
		</style>

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

																								<!-- Hide title when item.style.name contains "GEENTITEL", or content of db.title contains 'NOTITLE' (case sensitive)
																								The titles in banner styles cannot be hidden -->
																								<xsl:if test="(not(contains(style, 'GEENTITEL')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">

																									<!--
                                                                                                    Title (db.title)
                                                                                                    You can add 2x double pipes to break title (max 2 double pipes)
                                                                                                    -->
																									<tr>
																										<td class="ctCapt">

																											<xsl:variable name="title">
																												<xsl:choose>
																													<xsl:when test="contains(title, ' || ')">
																														<xsl:value-of select="normalize-space(substring-before(title, ' || '))" disable-output-escaping="yes" />
																														<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																														<xsl:choose>
																															<xsl:when test="contains(substring-after(title, ' || '), ' || ')">
																																<xsl:value-of select="normalize-space(substring-before(substring-after(title, ' || '), ' ||'))" disable-output-escaping="yes" />
																																<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																																<xsl:value-of select="normalize-space(substring-after(substring-after(title, ' || '), ' || '))" disable-output-escaping="yes" />
																															</xsl:when>
																															<xsl:otherwise>
																																<xsl:value-of select="normalize-space(substring-after(title, ' || '))" disable-output-escaping="yes" />
																															</xsl:otherwise>
																														</xsl:choose>
																													</xsl:when>
																													<xsl:otherwise>
																														<xsl:value-of select="title" disable-output-escaping="yes" />
																													</xsl:otherwise>
																												</xsl:choose>
																											</xsl:variable>

																											<xsl:choose>
																												<xsl:when test="contains(style, '1/3') or contains(style, '2/3')">
																													<h3><xsl:value-of select="$title" disable-output-escaping="yes" /></h3>
																												</xsl:when>
																												<xsl:otherwise>
																													<h2><xsl:value-of select="$title" disable-output-escaping="yes" /></h2>
																												</xsl:otherwise>
																											</xsl:choose>
																										</td>
																									</tr>

																									<!--
                                                                                                    Subtitle (db.location)
                                                                                                    You can add 2x double pipes to break subtitle in max 3 lines (||)
                                                                                                    -->
																									<xsl:if test="location != ''">
																										<tr>
																											<td class="ctSubt">

																												<xsl:variable name="subtitle">
																													<xsl:choose>
																														<xsl:when test="contains(location, ' || ')">
																															<xsl:value-of select="normalize-space(substring-before(location, ' || '))" disable-output-escaping="yes" />
																															<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																															<xsl:choose>
																																<xsl:when test="contains(substring-after(location, ' || '), ' || ')">
																																	<xsl:value-of select="normalize-space(substring-before(substring-after(location, ' || '), ' ||'))" disable-output-escaping="yes" />
																																	<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																																	<xsl:value-of select="normalize-space(substring-after(substring-after(location, ' || '), ' || '))" disable-output-escaping="yes" />
																																</xsl:when>
																																<xsl:otherwise>
																																	<xsl:value-of select="normalize-space(substring-after(location, ' || '))" disable-output-escaping="yes" />
																																</xsl:otherwise>
																															</xsl:choose>
																														</xsl:when>
																														<xsl:otherwise>
																															<xsl:value-of select="location" disable-output-escaping="yes" />
																														</xsl:otherwise>
																													</xsl:choose>
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

																								</xsl:if>

																								<!-- Content
																								Hide this part when using banner blocks -->
																								<xsl:if test="not(contains(style, 'banner'))">
																									<tr>
																										<td class="content">
																											<xsl:value-of select="content" disable-output-escaping="yes" />
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
																								<xsl:if test="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON')))) and contains(style, 'afb.')">
																									<tr>
																										<xsl:call-template name="button_container">
																											<xsl:with-param name="row" select="." />
																											<xsl:with-param name="ignore_width">1</xsl:with-param>
																										</xsl:call-template>
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
	##todo explain
	-->
	<xsl:template name="button">
		<xsl:param name="button_text" />
		<xsl:param name="button_default_text" />
		<xsl:param name="url" />
		<xsl:param name="class" />
		<xsl:param name="align">left</xsl:param>
		<xsl:param name="hide">0</xsl:param>

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
											<td class="agHeaderInnerCont">
												<xsl:value-of select="title" disable-output-escaping="yes" />
											</td>
										</tr>
									</table>

								</xsl:when>
								<xsl:otherwise>

									<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
										<tr>
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
							</xsl:if>

							<!-- Content container -->
							<td class="agCtCont">
								<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

									<!-- Caption with same || option as in ITEMS -->
									<tr>
										<td class="agCapt">
											<xsl:variable name="title">
												<xsl:choose>
													<xsl:when test="contains(title, ' || ')">
														<xsl:value-of select="normalize-space(substring-before(title, ' || '))" disable-output-escaping="yes" />
														<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
														<xsl:choose>
															<xsl:when test="contains(substring-after(title, ' || '), ' || ')">
																<xsl:value-of select="normalize-space(substring-before(substring-after(title, ' || '), ' ||'))" disable-output-escaping="yes" />
																<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																<xsl:value-of select="normalize-space(substring-after(substring-after(title, ' || '), ' || '))" disable-output-escaping="yes" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="normalize-space(substring-after(title, ' || '))" disable-output-escaping="yes" />
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="title" disable-output-escaping="yes" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>

											<h2><xsl:value-of select="$title" disable-output-escaping="yes" /></h2>
										</td>
									</tr>

									<!-- Subtitle with same || option as in ITEMS -->
									<xsl:if test="location != ''">
										<tr>
											<td class="agSubt">

												<xsl:variable name="subtitle">
													<xsl:choose>
														<xsl:when test="contains(location, ' || ')">
															<xsl:value-of select="normalize-space(substring-before(location, ' || '))" disable-output-escaping="yes" />
															<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
															<xsl:choose>
																<xsl:when test="contains(substring-after(location, ' || '), ' || ')">
																	<xsl:value-of select="normalize-space(substring-before(substring-after(location, ' || '), ' ||'))" disable-output-escaping="yes" />
																	<xsl:text disable-output-escaping="yes"><![CDATA[<br />]]></xsl:text>
																	<xsl:value-of select="normalize-space(substring-after(substring-after(location, ' || '), ' || '))" disable-output-escaping="yes" />
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="normalize-space(substring-after(location, ' || '))" disable-output-escaping="yes" />
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="location" disable-output-escaping="yes" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

												<h4><xsl:value-of select="$subtitle" disable-output-escaping="yes" /></h4>
											</td>
										</tr>
									</xsl:if>

									<!-- Show same date text as ITEMS blocks when no DATUMBLOK is triggered -->
									<xsl:if test="not(contains(style, 'datumblok'))">
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
								</table>
							</td>

							<!-- Button -->
							<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON'))">
								<td class="agButCont">
									<xsl:call-template name="button">
										<xsl:with-param name="align">right</xsl:with-param>
										<xsl:with-param name="button_default_text" select="$button1_text" />
										<xsl:with-param name="button_text" select="image_alt" />
										<xsl:with-param name="class">ctBut</xsl:with-param>
										<xsl:with-param name="url" select="details_url" />
									</xsl:call-template>
								</td>
							</xsl:if>
						</tr>
					</table>
				</td>
			</tr>

		</table>
		<!-- That's all folks !!
		kind regards from the DeBoer Cousins
		-->

	</xsl:template>

</xsl:stylesheet>