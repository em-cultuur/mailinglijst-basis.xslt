<?xml version="1.0" encoding="iso-8859-15" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" />

	<!-- Basis  v1
	XSLT for BLOCKS in MailingLijst-templates
	(c) EM-Cultuur, 2020
	Last change: JWDB 20 August 2020 (v1.8)

	BLOCKSTYLE-names determine grouping
	blockdeails (db.fiesds) determine content, design of the blocks
	design is set in the CSS of the template (few exceptions)

	for xslt-fieldnames (db.fieldnames, block-names) reference :
    https://docs.google.com/spreadsheets/d/1YH9x9XHwB_tUU6pUYobAH4UFw3eY7HIlSVqLEHc6ySU/edit?usp=sharing
	-->

	<!-- DEFAULTS/CONSTANTS -->
	<!--
	Image widths must be defined in CSS and XSLT
	And are used for style and width-parameters
	JWDB June 2020: double image logic implemented
	JWDB August 2020: sidebar implementation
	-->
	<xsl:variable name="sidebar_active">
		<xsl:choose>
			<xsl:when test="count(/matches/match[contains(style, 'Sidebar')]) != 0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sidebar_width">184</xsl:variable>

	<xsl:variable name="width_13">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">152</xsl:when>
			<xsl:otherwise>220</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="width_12">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">238</xsl:when>
			<xsl:otherwise>340</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="width_23">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">324</xsl:when>
			<xsl:otherwise>460</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="width_full">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">496</xsl:when>
			<xsl:otherwise>700</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="header_width">700</xsl:variable>

	<xsl:variable name="image_width_double_wide">60</xsl:variable>
	<xsl:variable name="image_width_double_small">40</xsl:variable>
	<xsl:variable name="image_height_double_full">300</xsl:variable>
	<xsl:variable name="image_height_double_12">200</xsl:variable>
	<xsl:variable name="image_height_double_13_23">200</xsl:variable>

	<xsl:variable name="image_width_lr">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">220</xsl:when>
			<xsl:otherwise>220</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="image_width_agenda">
		<xsl:choose>
			<xsl:when test="$sidebar_active = 1">125</xsl:when>
			<xsl:otherwise>125</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- options for borders -->
	<xsl:variable name="border_width">5</xsl:variable>

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

		<style type="text/css">
			/* Custom fonts from Google, or use downloaded fonts and font-face*/
			@import url('https://fonts.googleapis.com/css?family=Lato:400,400i,700,700i|Prata&amp;display=swap');

			td, th, a, .content a, .agContent a {
			font-family: Lato, sans-serif;
			color: dimgray;
			font-size: 14px;
			line-height: 20px;
			}
			a, .content a, .agContent a {
			color: dimgray !important; /* Outlook compatibility */
			}
			th {
			text-align: left;
			font-weight: normal;
			}
			/*Headings*/
			h1, h2, h3, h4, h5, h6 {
			font-family: Prata, serif;
			color: indianred;
			margin: 0;
			font-size: 14px;
			line-height: 20px;
			}
			.content h5, .content h6 {
			color: dimgray;
			font-family: Lato, sans-serif;
			}
			h1 {
			font-size: 24px;
			line-height: 30px;
			}
			h2 {
			font-size: 20px;
			line-height: 28px;
			}
			h3 {
			font-size: 16px;
			line-height: 24px;
			}
			h4 {
			font-size: 16px;
			line-height: 24px;
			color: gray;
			font-weight: normal;
			}
			h6 {
			font-size: 12px;
			line-height: 18px;
			}
			.content h1, .content h2, .content h3, .content h4, .content h5, .content h6 {
			margin-top: 15px;
			}

			/*HEADER*/
			.hdCont {
			background-color: darkgray;
			padding: 15px;
			}
			.hdShow, .hdShow a {
			color: white !important; /*outlook compatibility*/
			color: white;
			}
			.hdShow {
			text-align: right;
			}
			.hdShow a {
			text-decoration: underline;
			}
			.hdShow a:hover {
			text-decoration: none;
			}
			.hdLogo {
			padding-bottom: 15px;
			}
			.hdEdition h1 {}

			/*FOOTER STYLES*/
			.ftCont {
			padding: 10px;
			background-color: darkgray;
			}

			.ftInnerCont {
			vertical-align: top;
			width: 50%;
			padding: 5px;
			}

			.ftCont a, .ftUnsubscribe a {
			color: dimgray !important; /* Outlook compatibility */
			color: dimgray;
			text-decoration: underline;
			}

			.ftCont a:hover, .ftUnsubscribe a:hover {
			text-decoration: none;
			}

			.ftCont a img {
			border: 0;
			}

			/*
			CONTENT STYLES
			*/
			/*Containers*/
			.ctMainBlock, .ctMainBlockNoBorder, .ctMainBlockItem, .ctInnerCont {
			background-color: white;
			vertical-align: top;
			}
			.ctMainBlockFeat, .ctMainBlockFeatNoBorder, .ctMainBlockItemFeat, .ctInnerContFeat {
			background-color: dimgray;
			vertical-align: top;
			}
			.ctMainBlockBan, .ctInnerContBan {
			background-color: indianred;
			}
			.ctBottomMargin, .ctEndingCont, .ctEndingContNoBorder {
			height: 20px;
			font-size: 1px;
			line-height: 1px;
			}
			.ctBlockMargin, .ctEndingMargin {
			width: 20px;
			font-size: 1px;
			line-height: 1px;
			}

			/*Title*/
			.ctTitlesCont, .ctTitlesContNoContent {
			padding-bottom: 15px;
			}
			.ctTitlesContAfbLr, .ctTitlesContBelow {
			padding-bottom: 0;
			}
			.ctCapt, .ctCaptBelow {
			padding: 15px;
			padding-bottom: 0;
			}
			.ctCaptBelow {
			padding-top: 0;
			}
			.ctCapt h2, .ctCapt h3, .ctCapt a,
			.ctCaptBelow h2, .ctCaptBelow h3, .ctCaptBelow a {
			color: indianred;
			font-weight: bold;
			text-decoration: none;
			}
			.ctCapt a, .ctCaptBelow a {
			font-size: 20px;
			line-height: 28px;
			}
			.ctCapt h3, .ctCaptBelow h3 {
			}
			.ctInnerContFeat .ctCapt h2, .ctInnerContFeat .ctCapt h3, .ctInnerContFeat .ctCapt a,
			.ctInnerContFeat .ctCaptBelow h2, .ctInnerContFeat .ctCaptBelow h3, .ctInnerContFeat .ctCaptBelow a{
			color: white;
			}
			.ctInnerContBan .ctCapt, .ctInnerContBan .ctCaptBelow {
			padding-top: 0;
			}
			.ctInnerContBan .ctCapt h2, .ctInnerContBan .ctCapt h3, .ctInnerContBan .ctCapt a,
			.ctInnerContBan .ctCaptBelow h2, .ctInnerContBan .ctCaptBelow h3, .ctInnerContBan .ctCaptBelow a{
			color: white;
			font-size: 28px;
			line-height: 36px;
			}

			/*Subtitle*/
			.ctSubt, .ctSubtAbove {
			padding: 15px;
			padding-top: 0;
			padding-bottom: 0;
			}
			.ctSubtAbove {
			padding-top: 15px;
			}
			.ctInnerContBan .ctSubtAbove {
			padding-top: 0;
			}
			.ctSubt h4, .ctSubtAbove h4 {
			}
			.ctInnerContFeat .ctSubt h4,
			.ctInnerContBan .ctSubt h4,
			.ctInnerContFeat .ctSubtAbove h4,
			.ctInnerContBan .ctSubtAbove h4{
			color: white;
			}

			/*Date*/
			.ctDate {
			padding: 15px;
			padding-top: 0;
			padding-bottom: 0;
			color: silver;
			font-size: 14px;
			line-height: 20px;
			font-weight: normal;
			}
			.ctDate a {
			color: silver !important; /* outlook compatibilty*/
			color: silver;
			text-decoration: none;
			}
			.ctInnerContFeat .ctDate {
			color: white;
			}

			/*Content*/
			.content, .content a {
			font-size: 14px;
			line-height: 20px;
			}
			.content {
			padding: 15px;
			}
			.content a {
			text-decoration: underline;
			}
			.content a:hover {
			text-decoration: none;
			}
			.ctInnerContFeat .content, .ctInnerContFeat .content a {
			color: white !important; /* Outlook compatibility */
			color: white;
			}
			.ctOuterBlock, .ctOuterBlockAfbLr {
			vertical-align: top;
			}
			.ctInnerContBan .ctOuterBlock,
			.ctInnerContBan .ctOuterBlockAfbLr {
			vertical-align: middle;
			}
			.ctInnerContBan .ctInnerBlock {
			padding-top: 15px;
			padding-bottom: 15px;
			}

			/*Images*/
			.ctImgRightOuterBlock, .ctImgLeftOuterBlock {
			width: 235px;
			vertical-align: top;
			}
			.ctImgRightOuterBlockBan, .ctImgLeftOuterBlockBan {
			width: 220px;
			vertical-align: top;
			}
			.ctImgRightInnerBlock, .ctImgLeftInnerBlock {
			padding: 15px;
			}
			.ctImgRightInnerBlock {
			padding-left: 0;
			}
			.ctImgLeftInnerBlock {
			padding-right: 0;
			}
			.ctImgSubt {
			font-size: 12px;
			line-height: 16px;
			padding: 15px;
			padding-bottom: 0;
			padding-top: 5px;
			}
			.ctInnerContFeat .ctImgSubt,
			.ctInnerContBan .ctImgSubt {
			color: white;
			}
			.ctImgLeftInnerBlock .ctImgSubt,
			.ctImgRightInnerBlock .ctImgSubt {
			padding-left: 5px;
			text-align: left;
			}
			.ctImgLeftInnerBlockBan .ctImgSubt,
			.ctImgRightInnerBlockBan .ctImgSubt {
			padding-left: 5px;
			padding-bottom: 5px;
			text-align: left;
			}

			/*Buttons*/
			.ctButCont, .ctButContNoBorder {
			background-color: white;
			vertical-align: top;
			}
			.ctButContFeat, .ctButContFeatNoBorder {
			background-color: dimgray;
			vertical-align: top;
			}
			.ctButContBan, .ctButContBanNoBorder {
			background-color: indianred;
			vertical-align: top;
			}
			.ctButInnerCont {
			padding: 15px;
			padding-top: 0;
			}
			.ctButContBan .ctButInnerCont,
			.ctButContBanNoBorder .ctButInnerCont {
			padding-top: 15px;
			padding-bottom: 0;
			}
			.ctBut {
			background-color: dimgray;
			color: white;
			font-size: 14px;
			padding: 20px;
			padding-top: 10px;
			padding-bottom: 10px;
			}
			.ctBut:hover {
			background-color: black;
			}
			.ctBut2 {
			background-color: indianred;
			color: white;
			font-size: 14px;
			padding: 20px;
			padding-top: 10px;
			padding-bottom: 10px;
			}
			.ctBut2:hover {
			background-color: red;
			}
			.ctButBlock a {
			color: white !important; /*this is for compatibility with outlook.app*/
			color: white;
			text-decoration: none;
			}
			.ctButContFeat .ctBut, .ctButContFeat .ctBut2,
			.ctButContBan .ctBut, .ctButContBan .ctBut2,
			.ctButContFeatNoBorder .ctBut, .ctButContFeatNoBorder .ctBut2,
			.ctButContBanNoBorder .ctBut, .ctButContBanNoBorder .ctBut2,
			.ctMobButContFeat .ctBut, .ctMobButContFeat .ctBut2,
			.ctMobButContBan .ctBut, .ctMobButContBan .ctBut2 {
			background-color: white;
			}
			.ctButContFeat .ctBut:hover, .ctButContFeat .ctBut2:hover,
			.ctButContBan .ctBut:hover, .ctButContBan .ctBut2:hover,
			.ctButContFeatNoBorder .ctBut:hover, .ctButContFeatNoBorder .ctBut2:hover,
			.ctButContBanNoBorder .ctBut:hover, .ctButContBanNoBorder .ctBut2:hover,
			.ctMobButContFeat .ctBut:hover, .ctMobButContFeat .ctBut2:hover,
			.ctMobButContBan .ctBut:hover, .ctMobButContBan .ctBut2:hover {
			background-color: white;
			}
			.ctButContFeat .ctButBlock a,
			.ctButContBan .ctButBlock a,
			.ctButContFeatNoBorder .ctButBlock a,
			.ctButContBanNoBorder .ctButBlock a,
			.ctMobButContFeat .ctButBlock a,
			.ctMobButContBan .ctButBlock a {
			color: dimgray !important; /* Outlook compatibility */
			color: dimgray;
			}
			.ctButIconMargin {
			font-size: 1px;
			line-height: 1px;
			width: 5px;
			}

			/*Call2action*/
			.ctCallInnerCont {
			background-color: dimgray;
			text-align: center;
			padding: 15px;
			padding-top: 10px;
			padding-bottom: 10px;
			}
			.ctCallInnerCont h2 {
			color: white;
			font-size: 20px;
			line-height: 28px;
			font-family: Lato, sans-serif;
			font-weight: normal;
			}
			.ctCallInnerCont h2 a {
			font-size: 20px;
			line-height: 28px;
			}
			.ctCallOuterCont a {
			text-decoration: none;
			color: white !important; /* Outlook compatibility*/
			color: white;
			}

			/*Tussenkop*/
			.ctSubhInnerCont, .ctSubhInnerContFeat {
			border-bottom: 2px solid indianred;
			padding-bottom: 10px;
			}
			.ctSubhInnerContFeat {
			border-bottom: 2px solid dimgray;
			}
			.ctSubhInnerCont h2, .ctSubhInnerContFeat h2 {
			color: indianred;
			font-size: 20px;
			line-height: 28px;
			font-family: Lato, sans-serif;
			font-weight: normal;
			}
			.ctSubhInnerContFeat h2 {
			color: dimgray;
			}

			/*Agenda*/
			.agHeaderOuterCont {
			background-color: white;
			padding: 15px;
			padding-bottom: 0;
			}
			.agHeaderInnerCont {
			font-size: 20px;
			line-height: 28px;
			color: indianred;
			}
			.agItemsCont {
			background-color: white;
			padding: 15px;
			padding-bottom: 0;
			}
			.agItemCont {
			padding-bottom: 15px;
			}
			.agColMargin {
			font-size: 1px;
			line-height: 1px;
			}
			.agDateBlockCont {
			width: 65px;
			vertical-align: top;
			}
			.agDateBlockInnerCont {}
			.agDateBlockDay, .agDateBlockMonth {
			background-color: indianred;
			padding: 5px;
			text-align: center;
			width: 40px;
			color: white;
			font-weight: bold;
			}
			.agDateBlockDay {
			padding-bottom: 0;
			font-size: 18px;
			line-height: 22px;
			}
			.agDateBlockMonth {
			padding-top: 0;
			}
			.agDateTextCont {
			vertical-align: top;
			width: 140px;
			}
			.agDateTextInnerCont {
			padding-right: 5px;
			}
			.agImgOuterCont {
			width: 140px;
			vertical-align: top;
			}
			.agCtCont {
			vertical-align: top;
			}
			.agCapt h2 {
			font-size: 20px;
			line-height: 28px;
			color: dimgray;
			font-weight: bold;
			}
			.agCapt a {
			text-decoration: none;
			}
			.agSubt h4 {
			color: gray;
			font-size: 16px;
			line-height: 24px;
			font-weight: normal;
			}
			.agDate, .agTime, .agDateTextInnerCont {
			color: silver;
			font-size: 14px;
			line-height: 20px;
			font-weight: normal;
			}
			.agDate a, .agTime a, .agDateTextInnerCont a {
			color: silver !important; /*outlook compatibility*/
			color: silver;
			text-decoration: none;
			}
			.agContent {
			padding-top: 10px;
			}
			.agContent a {
			color: dimgray;
			text-decoration: underline;
			}
			.agContent a:hover {
			text-decoration: none;
			}
			.agButCont a {
			color: white !important; /*this is for compatibility with outlook.app*/
			color: white;
			text-decoration: none;
			}

			/* RESPONSIVE CODE */
			@media only screen and (max-width: 480px) {
			.ctMainTable {
			width: 100% !important;
			}
			.bodyMainTable {
			width: 100% !important;
			}
			.ctImg img {
			width: 100% !important;
			height: auto !important;
			-ms-interpolation-mode: bicubic;
			}
			.ctImgSmall {
			text-align: center;
			}
			.ctImgSmall img {
			/*margin-left: auto;
			margin-right: auto;*/
			}
			.ctImgSmall .ctImgSubt {
			text-align: left;
			}
			.ctMainBlock, .ctMainBlockNoBorder, .ctMainBlockItem, .ctMainBlockFeat, .ctMainBlockFeatNoBorder, .ctMainBlockItemFeat {
			display: block;
			width: 100% !important;
			}
			.ctBlockMargin {
			display: block;
			width: 100% !important;
			padding-bottom: 20px;
			}
			.ctCapt h2, .ctCapt h3,
			.ctCaptBelow h2, .ctCaptBelow h3{
			font-size: 20px !important;
			line-height: 28px !important;
			}
			.ctSubhInnerCont, .ctSubhInnerContFeat {
			padding-left: 15px;
			padding-right: 15px;
			}
			.ctButCont, .ctButContFeat, .ctButContBan, .ctDeskButCont,
			.ctButContNoBorder, .ctButContFeatNoBorder, .ctButContBanNoBorder,
			.ctButCont table, .ctButContFeat table, .ctButContBan table, .ctDeskButCont table,
			.ctButContNoBorder table, .ctButContFeatNoBorder table, .ctButContBanNoBorder table {
			display: none !important;
			mso-hide: all !important;
			}
			.ctMobButCont, .ctMobButContFeat, .ctMobButContBan {
			display: table-row !important;
			max-height: none !important;
			height: auto !important;
			font-size: inherit !important;
			line-height: normal !important;
			margin: auto !important;
			width: 100% !important;
			overflow: auto !important;
			}
			.ctMobButBlock {
			padding: 15px;
			padding-top: 0;
			}
			.ctMobButContBan .ctMobButBlock {
			padding-top: 15px;
			padding-bottom: 0;
			}
			.ctMobInnerCont {
			display: table !important;
			max-height: none !important;
			height: auto !important;
			font-size: inherit !important;
			line-height: normal !important;
			margin: auto !important;
			width: auto !important;
			overflow: auto !important;
			}
			.ctButTable {
			display: block !important;
			max-height: none !important;
			height: auto !important;
			font-size: inherit !important;
			line-height: normal !important;
			margin: auto !important;
			width: 100% !important;
			overflow: auto !important;
			}
			.ctImgLeftOuterBlock, .ctImgRightOuterBlock, .ctImgRightOuterBlockBan, .ctImgLeftOuterBlockBan {
			display: block !important;
			width: 100%;
			}
			.ctImgLeftInnerBlock, .ctImgRightInnerBlock, .ctImgRightInnerBlockBan, .ctImgLeftInnerBlockBan {
			padding: 0 !important;
			text-align: center;
			}
			.ctImgLeftOuterBlock img, .ctImgRightOuterBlock img, .ctImgRightOuterBlockBan img, .ctImgLeftOuterBlockBan img {
			/*margin-left: auto;
			margin-right: auto;*/
			float: left;
			}
			.ctImgLeftInnerBlock .ctImgSubt, .ctImgRightInnerBlock .ctImgSubt {
			padding-left: 15px;
			}
			.ctOuterBlock, .ctOuterBlockAfbLr {
			display: block !important;
			width: 100%;
			}
			.agImgOuterCont {
			width: 100% !important;
			display: block;
			padding-bottom: 10px;
			}
			.agImgOuterCont img {
			/*margin-left: auto;
			margin-right: auto;*/
			}
			.agCtCont {
			width: 100% !important;
			display: block;
			}
			.agButCont {
			width: 100% !important;
			display: block;
			padding-top: 10px;
			}
			.agColMargin {
			width: 100% !important;
			display: block;
			}
			.agDateTextCont {
			width: 100% !important;
			display: block;
			padding-bottom: 10px;
			}
			.ctEndingCont, .ctEndingContNoBorder, .ctEndingContBan, .ctEndingContBanNoBorder,
			.ctEndingContFeat, .ctEndingContFeatNoBorder {
			width: 100% !important;
			}
			.ctCont {
			padding: 10px;
			}
			.hdImage img {
			width: 100% !important;
			height: auto !important;
			}
			.ftBanner img {
			width: 100% !important;
			height: auto !important;
			}
			.ftInnerCont {
			width: 100% !important;
			display: block;
			padding: 0 !important;
			padding-bottom: 5px !important;
			padding-top: 5px !important;
			}
			}
		</style>

		<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">

			<!-- HEADER ITEMS SECTION
			This section contains items with style beginning with Headeritem.
			This items will be displayed above normal items + sidebar.
			-->
			<xsl:if test="count(/matches/match[contains(style, 'Headeritem')]) != 0">
				<tr>

					<td class="ctMainUpperCont">

						<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;" class="ctMainTable">

							<!-- Blocks are grouped on blockstyle-name-first-word
							Loop through block-styles starting with 'Headeritem' -->
							<xsl:for-each select="matches/match[contains(style, 'Headeritem')]">

								<!-- ##JWDB 24 July 2020: pick colors from db.extra1 field -->
								<xsl:variable name="background-color">
									<xsl:call-template name="color">
										<xsl:with-param name="colors" select="extra1" />
										<xsl:with-param name="part">achtergrond</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>

								<!-- ##JWDB 8 may 2020: Extra validation to check if the entire content (titles, content and url) is needed to be shown -->
								<xsl:variable name="hide_content">
									<xsl:choose>
										<xsl:when test="contains(title, 'NOTITLE') and content = '' and url = '' and not(contains(style, 'afb.'))">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<!-- Default widths of blocks, set in the header of this document -->
								<xsl:variable name="width"><xsl:value-of select="$header_width" /></xsl:variable>

								<!-- Start rule for each block, determine it on the position or rule_end of previous item -->
								<xsl:if test="position() = 1 or preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'true'">
									<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
									<xsl:choose>
										<xsl:when test="contains(extra3, 'NOBORDER') and not(contains(style, '1/2')) and not(contains(style, '1/3')) and not(contains(style, '2/3'))"><xsl:text disable-output-escaping="yes"><![CDATA[<tr class="ctNoBorder">]]></xsl:text></xsl:when>
										<xsl:otherwise><xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text></xsl:otherwise>
									</xsl:choose>
								</xsl:if>

								<xsl:if test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (position() = 1 or preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'true')">
									<xsl:text disable-output-escaping="yes"><![CDATA[<td><table cellpadding="0" cellspacing="0"><tr><td class="ctBlockCont"><table cellpadding="0" cellspacing="0"><tr>]]></xsl:text>
								</xsl:if>

								<!-- BLOCKSTYLE: ITEM-->
								<th>
									<!--
									When using HIGHLIGHTED (uitgelicht) styles, we need to swap the classes to Featured which haves alternative background color by default.
									When db.extra1 is filled, then the alternative background color is set, sets the classes to Featured as well.
									-->
									<xsl:attribute name="class">
										<xsl:choose>
											<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">ctMainBlockItemFeat</xsl:when>
											<xsl:otherwise>ctMainBlockItem</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>

									<!--
									When db.extra1 is filled, then a custom background color is set.
									-->
									<xsl:if test="$background-color != ''">
										<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
									</xsl:if>

									<!-- JWDB June 2020: border color can be configured per item -->
									<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
										<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
									</xsl:if>

									<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
									<xsl:variable name="bordered_width">
										<xsl:choose>
											<xsl:when test="contains(style, 'afb.')"><xsl:value-of select="$width" /></xsl:when>
											<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and image = ''"><xsl:value-of select="$width" /></xsl:when>
											<xsl:when test="$border_width > 0 and not(contains(extra3, 'NOBORDER'))"><xsl:value-of select="$width - ($border_width * 2)" /></xsl:when>
											<xsl:otherwise><xsl:value-of select="$width" /></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>

									<table cellpadding="0" cellspacing="0" class="ctMainTable">
										<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
										<xsl:attribute name="style">width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
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
																	<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">ctInnerContFeat</xsl:when>
																	<xsl:otherwise>ctInnerCont</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>

															<!--
															When db.extra1 is filled, then a custom background color is set.
															This logic is double with the TD above, but it is needed for the BLOKKEN_EDITOR
															-->
															<xsl:if test="$background-color != ''">
																<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
															</xsl:if>

															<!-- JWDB June 2020: border color can be configured per item -->
															<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
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
																Hide this part when using image left/right styles
																JWDB June 2020: double left and right logic implemented -->
																<xsl:if test="image != '' and not(contains(style, 'afb.'))">
																	<tr>
																		<td>
																			<!-- ##JWDB 26 march 2020: when the image width is smaller than 480, then don't stretch out on mobile. So add other class to them -->
																			<!-- ##JWDB June 2020: changed 460px to 400 to be sure 2/3 items will be expanded to 100% width due responsive issue in iPhones -->
																			<xsl:attribute name="class">
																				<xsl:choose>
																					<xsl:when test="$width &lt; 400">ctImgSmall</xsl:when>
																					<xsl:otherwise>ctImg</xsl:otherwise>
																				</xsl:choose>
																			</xsl:attribute>

																			<!-- JWDB June 2020: double images logic implemented -->
																			<xsl:variable name="imagewidth_wide"><xsl:value-of select="format-number(($bordered_width div 100) * $image_width_double_wide, '####')" /></xsl:variable>
																			<xsl:variable name="imagewidth_small"><xsl:value-of select="format-number(($bordered_width div 100) * $image_width_double_small, '####')" /></xsl:variable>

																			<xsl:variable name="imageleft_width">
																				<xsl:choose>
																					<xsl:when test="not(contains(style, 'dubbel'))"><xsl:value-of select="$bordered_width" /></xsl:when>
																					<xsl:when test="contains(style, 'dubbel links') and icon != ''"><xsl:value-of select="$imagewidth_wide" /></xsl:when>
																					<xsl:otherwise><xsl:value-of select="$imagewidth_small" /></xsl:otherwise>
																				</xsl:choose>
																			</xsl:variable>

																			<xsl:variable name="imageright_width">
																				<xsl:choose>
																					<xsl:when test="not(contains(style, 'dubbel'))"><xsl:value-of select="$bordered_width" /></xsl:when>
																					<xsl:when test="contains(style, 'dubbel links') and icon != ''"><xsl:value-of select="$imagewidth_small" /></xsl:when>
																					<xsl:otherwise><xsl:value-of select="$imagewidth_wide" /></xsl:otherwise>
																				</xsl:choose>
																			</xsl:variable>

																			<xsl:variable name="image_height">
																				<xsl:choose>
																					<xsl:when test="contains(style, 'dubbel')">
																						<xsl:choose>
																							<xsl:when test="contains(style, '1/2')"><xsl:value-of select="$image_height_double_12" /></xsl:when>
																							<xsl:when test="contains(style, '2/3') or contains(style, '1/3')"><xsl:value-of select="$image_height_double_13_23" /></xsl:when>
																							<xsl:otherwise><xsl:value-of select="$image_height_double_full" /></xsl:otherwise>
																						</xsl:choose>
																					</xsl:when>
																					<xsl:otherwise>0</xsl:otherwise>
																				</xsl:choose>
																			</xsl:variable>

																			<xsl:choose>
																				<xsl:when test="url != ''">

																					<table cellpadding="0" cellspacing="0" width="100%" class="ctImgInnerCont">
																						<tr>
																							<td style="vertical-align: top;" class="ctImgInnerLeft">
																								<a target="_blank">
																									<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																									<img border="0">
																										<xsl:attribute name="width"><xsl:value-of select="$imageleft_width" /></xsl:attribute>
																										<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageleft_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																										<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																										<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																										<xsl:attribute name="src">
																											<xsl:choose>
																												<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																												<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																											</xsl:choose>
																										</xsl:attribute>
																										<xsl:if test="$image_height &gt; 0">
																											<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																										</xsl:if>
																									</img>
																								</a>
																							</td>
																							<xsl:if test="icon != '' and contains(style, 'dubbel')">
																								<td style="vertical-align: top;" class="ctImgInnerRight">
																									<a target="_blank">
																										<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																										<img border="0">
																											<xsl:attribute name="width"><xsl:value-of select="$imageright_width" /></xsl:attribute>
																											<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageright_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																											<xsl:attribute name="alt"><xsl:value-of select="icon_alt" /></xsl:attribute>
																											<xsl:attribute name="title"><xsl:value-of select="icon_title" /></xsl:attribute>
																											<xsl:attribute name="src">
																												<xsl:choose>
																													<xsl:when test="contains(icon, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																													<xsl:otherwise><xsl:value-of select="icon" /></xsl:otherwise>
																												</xsl:choose>
																											</xsl:attribute>
																											<xsl:if test="$image_height &gt; 0">
																												<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																											</xsl:if>
																										</img>
																									</a>
																								</td>
																							</xsl:if>
																						</tr>
																					</table>

																				</xsl:when>
																				<xsl:otherwise>

																					<table cellpadding="0" cellspacing="0" width="100%" class="ctImgInnerCont">
																						<tr>
																							<td style="vertical-align: top;" class="ctImgInnerLeft">
																								<img border="0">
																									<xsl:attribute name="width"><xsl:value-of select="$imageleft_width" /></xsl:attribute>
																									<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageleft_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																									<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																									<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																									<xsl:attribute name="src">
																										<xsl:choose>
																											<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																											<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																										</xsl:choose>
																									</xsl:attribute>
																									<xsl:if test="$image_height &gt; 0">
																										<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																									</xsl:if>
																								</img>
																							</td>
																							<xsl:if test="icon != '' and contains(style, 'dubbel')">
																								<td style="vertical-align: top;" class="ctImgInnerRight">
																									<img border="0">
																										<xsl:attribute name="width"><xsl:value-of select="$imageright_width" /></xsl:attribute>
																										<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageright_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																										<xsl:attribute name="alt"><xsl:value-of select="icon_alt" /></xsl:attribute>
																										<xsl:attribute name="title"><xsl:value-of select="icon_title" /></xsl:attribute>
																										<xsl:attribute name="src">
																											<xsl:choose>
																												<xsl:when test="contains(icon, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																												<xsl:otherwise><xsl:value-of select="icon" /></xsl:otherwise>
																											</xsl:choose>
																										</xsl:attribute>
																										<xsl:if test="$image_height &gt; 0">
																											<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																										</xsl:if>
																									</img>
																								</td>
																							</xsl:if>
																						</tr>
																					</table>

																				</xsl:otherwise>
																			</xsl:choose>

																			<!-- when db.extra2 field is filled, show it as image subtitle / photo credits -->
																			<xsl:if test="extra2 != ''">

																				<xsl:variable name="photocredits-color">
																					<xsl:call-template name="color">
																						<xsl:with-param name="colors" select="extra1" />
																						<xsl:with-param name="part">fotocredits</xsl:with-param>
																					</xsl:call-template>
																				</xsl:variable>

																				<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																					<tr>
																						<td class="ctImgSubt">
																							<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																							<xsl:if test="contains(style, 'gecentreerd') or $photocredits-color != ''">
																								<xsl:attribute name="style">
																									<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																									<xsl:if test="$photocredits-color">color: <xsl:value-of select="$photocredits-color" /></xsl:if>
																								</xsl:attribute>
																							</xsl:if>

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
																<xsl:if test="not(contains(style, '(afbeelding)')) and $hide_content = 0">
																	<tr>
																		<td>
																			<!-- ##JWDB 8 may 2020: Added extra class for border logic, with this you can check of the middle line between image and content is needed -->
																			<xsl:attribute name="class">
																				<xsl:choose>
																					<xsl:when test="image = '' and not(contains(style, 'afb.'))">ctInnerContNoImg</xsl:when>
																					<xsl:otherwise>ctInnerContImg</xsl:otherwise>
																				</xsl:choose>
																			</xsl:attribute>

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
																					##JWDB 8 may 2010: Fixed bug with empty image field (image != '' validation added)
																					-->
																					<xsl:if test="image != '' and contains(style, 'afb.')">
																						<th>
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

																										<!-- JWDB June 2020: border color can be configured per item -->
																										<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																											<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																										</xsl:if>

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

																														<xsl:variable name="photocredits-color">
																															<xsl:call-template name="color">
																																<xsl:with-param name="colors" select="extra1" />
																																<xsl:with-param name="part">fotocredits</xsl:with-param>
																															</xsl:call-template>
																														</xsl:variable>

																														<xsl:if test="$photocredits-color != ''">
																															<xsl:attribute name="style">color: <xsl:value-of select="$photocredits-color" /></xsl:attribute>
																														</xsl:if>

																														<xsl:value-of select="extra2" />
																													</td>
																												</tr>
																											</table>
																										</xsl:if>
																									</td>
																								</tr>
																							</table>
																						</th>
																					</xsl:if>
																					<!-- Content and buttons container -->
																					<th dir="ltr">
																						<xsl:attribute name="class">
																							<xsl:choose>
																								<xsl:when test="contains(style, 'afb.')">ctOuterBlockAfbLr</xsl:when>
																								<xsl:otherwise>ctOuterBlock</xsl:otherwise>
																							</xsl:choose>
																						</xsl:attribute>

																						<!-- JWDB June 2020: border color can be configured per item -->
																						<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																							<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																						</xsl:if>

																						<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
																							<tr>
																								<!-- BLOCK CONTENT (title, subtitle, date) with text and buttons -->
																								<td class="ctInnerBlock" style="vertical-align: top;">

																									<!-- JWDB August 2020: moved all visibility checks to here, so we can hide the entire table if needed -->
																									<xsl:variable name="hide_title">
																										<xsl:choose>
																											<xsl:when test="not(contains(style, 'titels boven'))">
																												<xsl:choose>
																													<xsl:when test="(not(contains(style, 'geen titel')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">0</xsl:when>
																													<xsl:otherwise>1</xsl:otherwise>
																												</xsl:choose>
																											</xsl:when>
																											<xsl:otherwise>1</xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:variable name="hide_innercontent">
																										<xsl:choose>
																											<xsl:when test="not(contains(style, 'banner')) and content != ''">0</xsl:when>
																											<xsl:otherwise>1</xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:variable name="hide_buttons">
																										<xsl:choose>
																											<xsl:when test="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON'))))">0</xsl:when>
																											<xsl:otherwise>1</xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:if test="$hide_title = 0 or $hide_innercontent = 0 or $hide_buttons = 0">
																										<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

																											<!-- Hide title when item.style.name contains "geen titel", or content of db.title contains 'NOTITLE' (case sensitive)
																											The titles in banner styles cannot be hidden
																											Hide this part when the style name contains trigger words 'titels boven' -->
																											<xsl:if test="$hide_title = 0">
																												<xsl:call-template name="titles" />
																											</xsl:if>

																											<!-- Content
																											Hide this part when using banner blocks
																											##JWDB 31 march 2020: when using index item style, show a list with all items in this newsletter with some exceptions (sub headers, this item, full image items, call2action and items with NOTITLE)
																											The validation on ending <br> in content is to prevent we're adding too many enters
																											-->
																											<xsl:if test="$hide_innercontent = 0">
																												<tr>
																													<td class="content">

																														<xsl:variable name="content-color">
																															<xsl:call-template name="color">
																																<xsl:with-param name="colors" select="extra1" />
																																<xsl:with-param name="part">content</xsl:with-param>
																															</xsl:call-template>
																														</xsl:variable>

																														<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																														<xsl:if test="contains(style, 'gecentreerd') or $content-color != ''">
																															<xsl:attribute name="style">
																																<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																																<xsl:if test="$content-color != ''">color: <xsl:value-of select="$content-color" /> !important; color: <xsl:value-of select="$content-color" />;</xsl:if>
																															</xsl:attribute>
																														</xsl:if>

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

																											<!-- Buttons  -->
																											<xsl:if test="$hide_buttons = 0">
																												<tr>
																													<xsl:call-template name="button_container">
																														<xsl:with-param name="row" select="." />
																														<xsl:with-param name="ignore_width">1</xsl:with-param>
																													</xsl:call-template>
																												</tr>
																											</xsl:if>
																										</table>
																									</xsl:if>
																								</td>
																							</tr>
																						</table>
																					</th>
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
								</th>

								<!-- End of block -->
								<xsl:if test="rule_end = 'true' or position() = last()">
									<xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>

									<!-- ##JWDB april 2020: Ending row, used for very specified styles as bordered items -->
									<tr>
										<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="contains(extra3, 'NOBORDER')">ctNoBorder</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>

										<td>
											<!-- JWDB June 2020: better classes for ctEndingOuterCont -->
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="position() = last()">
														<xsl:choose>
															<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and (contains(style, 'uitgelicht') or $background-color != '')">ctEndingOuterContFeatLast</xsl:when>
															<xsl:when test="contains(style, 'banner')">ctEndingOuterContBanLast</xsl:when>
															<xsl:otherwise>ctEndingOuterContLast</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and (contains(style, 'uitgelicht') or $background-color != '')">ctEndingOuterContFeat</xsl:when>
															<xsl:when test="contains(style, 'banner')">ctEndingOuterContBan</xsl:when>
															<xsl:otherwise>ctEndingOuterCont</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>

											<table cellpadding="0" cellspacing="0">
												<tr>
													<xsl:if test="preceding-sibling::*[contains(style, 'Item')][2]/rule_end != 'true' and preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
														<xsl:call-template name="ending_container">
															<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][2]" />
														</xsl:call-template>

														<th class="ctEndingMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
													</xsl:if>

													<xsl:if test="preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
														<xsl:call-template name="ending_container">
															<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][1]" />
														</xsl:call-template>

														<th class="ctEndingMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
													</xsl:if>

													<xsl:call-template name="ending_container">
														<xsl:with-param name="row" select="." />
													</xsl:call-template>
												</tr>
											</table>
										</td>
									</tr>

								</xsl:if>

							</xsl:for-each>

						</table>

					</td>

				</tr>
			</xsl:if>

			<!-- ITEMS and SIDEBAR SECTION -->
			<tr>

				<td class="ctMainLowerCont">

					<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;" class="ctMainTable">

						<tr>
							<th class="ctMainContentCont">

								<xsl:choose>
									<xsl:when test="count(matches/match[contains(style, 'Item')]) != 0 or count(matches/match[contains(style, 'Agenda')]) != 0">

										<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">

											<!-- Blocks are grouped on blockstyle-name-first-word (Item, Agenda)
                                            Loop through block-styles starting with 'Item' -->
											<xsl:for-each select="matches/match[contains(style, 'Item')]">

												<!-- ##JWDB 24 July 2020: pick colors from db.extra1 field -->
												<xsl:variable name="background-color">
													<xsl:call-template name="color">
														<xsl:with-param name="colors" select="extra1" />
														<xsl:with-param name="part">achtergrond</xsl:with-param>
													</xsl:call-template>
												</xsl:variable>

												<!-- ##JWDB 8 may 2020: Extra validation to check if the entire content (titles, content and url) is needed to be shown -->
												<xsl:variable name="hide_content">
													<xsl:choose>
														<xsl:when test="contains(title, 'NOTITLE') and content = '' and url = '' and not(contains(style, 'afb.'))">1</xsl:when>
														<xsl:otherwise>0</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>

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
														<xsl:if test="position() = 1 or preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'true'">
															<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
															<xsl:choose>
																<xsl:when test="contains(extra3, 'NOBORDER') and not(contains(style, '1/2')) and not(contains(style, '1/3')) and not(contains(style, '2/3'))"><xsl:text disable-output-escaping="yes"><![CDATA[<tr class="ctNoBorder">]]></xsl:text></xsl:when>
																<xsl:otherwise><xsl:text disable-output-escaping="yes"><![CDATA[<tr>]]></xsl:text></xsl:otherwise>
															</xsl:choose>
														</xsl:if>

														<xsl:if test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (position() = 1 or preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'true')">
															<xsl:text disable-output-escaping="yes"><![CDATA[<td><table cellpadding="0" cellspacing="0"><tr><td class="ctBlockCont"><table cellpadding="0" cellspacing="0"><tr>]]></xsl:text>
														</xsl:if>

														<!-- BLOCKSTYLE: ITEM-->
														<th>
															<!--
                                                            When using HIGHLIGHTED (uitgelicht) styles, we need to swap the classes to Featured which haves alternative background color by default.
                                                            When db.extra1 is filled, then the alternative background color is set, sets the classes to Featured as well.
                                                            -->
															<xsl:attribute name="class">
																<xsl:choose>
																	<xsl:when test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and not(contains(style, 'uitgelicht')) and $background-color = ''">
																		<xsl:choose>
																			<xsl:when test="contains(extra3, 'NOBORDER')">ctMainBlockNoBorder</xsl:when>
																			<xsl:otherwise>ctMainBlock</xsl:otherwise>
																		</xsl:choose>
																	</xsl:when>
																	<xsl:when test="(contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')) and (contains(style, 'uitgelicht') or $background-color != '')">
																		<xsl:choose>
																			<xsl:when test="contains(extra3, 'NOBORDER')">ctMainBlockFeatNoBorder</xsl:when>
																			<xsl:otherwise>ctMainBlockFeat</xsl:otherwise>
																		</xsl:choose>
																	</xsl:when>
																	<xsl:when test="contains(style, 'banner')">ctMainBlockBan</xsl:when>
																	<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">ctMainBlockItemFeat</xsl:when>
																	<xsl:otherwise>ctMainBlockItem</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>

															<!--
                                                            When db.extra1 is filled, then a custom background color is set.
                                                            -->
															<xsl:if test="$background-color != ''">
																<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
															</xsl:if>

															<!-- JWDB June 2020: border color can be configured per item -->
															<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
															</xsl:if>

															<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
															<xsl:variable name="bordered_width">
																<xsl:choose>
																	<xsl:when test="contains(style, 'afb.')"><xsl:value-of select="$width" /></xsl:when>
																	<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and image = ''"><xsl:value-of select="$width" /></xsl:when>
																	<xsl:when test="$border_width > 0 and not(contains(extra3, 'NOBORDER'))"><xsl:value-of select="$width - ($border_width * 2)" /></xsl:when>
																	<xsl:otherwise><xsl:value-of select="$width" /></xsl:otherwise>
																</xsl:choose>
															</xsl:variable>

															<table cellpadding="0" cellspacing="0" class="ctMainTable">
																<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
																<xsl:attribute name="style">width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
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
																							<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">ctInnerContFeat</xsl:when>
																							<xsl:otherwise>ctInnerCont</xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<!--
                                                                                    When db.extra1 is filled, then a custom background color is set.
                                                                                    This logic is double with the TD above, but it is needed for the BLOKKEN_EDITOR
                                                                                    -->
																					<xsl:if test="$background-color != ''">
																						<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
																					</xsl:if>

																					<!-- JWDB June 2020: border color can be configured per item -->
																					<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																						<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
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
                                                                                        Hide this part when using image left/right styles
                                                                                        JWDB June 2020: double left and right logic implemented -->
																						<xsl:if test="image != '' and not(contains(style, 'afb.'))">
																							<tr>
																								<td>
																									<!-- ##JWDB 26 march 2020: when the image width is smaller than 480, then don't stretch out on mobile. So add other class to them -->
																									<!-- ##JWDB June 2020: changed 460px to 400 to be sure 2/3 items will be expanded to 100% width due responsive issue in iPhones -->
																									<xsl:attribute name="class">
																										<xsl:choose>
																											<xsl:when test="$width &lt; 400">ctImgSmall</xsl:when>
																											<xsl:otherwise>ctImg</xsl:otherwise>
																										</xsl:choose>
																									</xsl:attribute>

																									<!-- JWDB June 2020: double images logic implemented -->
																									<xsl:variable name="imagewidth_wide"><xsl:value-of select="format-number(($bordered_width div 100) * $image_width_double_wide, '####')" /></xsl:variable>
																									<xsl:variable name="imagewidth_small"><xsl:value-of select="format-number(($bordered_width div 100) * $image_width_double_small, '####')" /></xsl:variable>

																									<xsl:variable name="imageleft_width">
																										<xsl:choose>
																											<xsl:when test="not(contains(style, 'dubbel'))"><xsl:value-of select="$bordered_width" /></xsl:when>
																											<xsl:when test="contains(style, 'dubbel links') and icon != ''"><xsl:value-of select="$imagewidth_wide" /></xsl:when>
																											<xsl:otherwise><xsl:value-of select="$imagewidth_small" /></xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:variable name="imageright_width">
																										<xsl:choose>
																											<xsl:when test="not(contains(style, 'dubbel'))"><xsl:value-of select="$bordered_width" /></xsl:when>
																											<xsl:when test="contains(style, 'dubbel links') and icon != ''"><xsl:value-of select="$imagewidth_small" /></xsl:when>
																											<xsl:otherwise><xsl:value-of select="$imagewidth_wide" /></xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:variable name="image_height">
																										<xsl:choose>
																											<xsl:when test="contains(style, 'dubbel')">
																												<xsl:choose>
																													<xsl:when test="contains(style, '1/2')"><xsl:value-of select="$image_height_double_12" /></xsl:when>
																													<xsl:when test="contains(style, '2/3') or contains(style, '1/3')"><xsl:value-of select="$image_height_double_13_23" /></xsl:when>
																													<xsl:otherwise><xsl:value-of select="$image_height_double_full" /></xsl:otherwise>
																												</xsl:choose>
																											</xsl:when>
																											<xsl:otherwise>0</xsl:otherwise>
																										</xsl:choose>
																									</xsl:variable>

																									<xsl:choose>
																										<xsl:when test="url != ''">

																											<table cellpadding="0" cellspacing="0" width="100%" class="ctImgInnerCont">
																												<tr>
																													<td style="vertical-align: top;" class="ctImgInnerLeft">
																														<a target="_blank">
																															<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																															<img border="0">
																																<xsl:attribute name="width"><xsl:value-of select="$imageleft_width" /></xsl:attribute>
																																<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageleft_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																																<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																																<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																																<xsl:attribute name="src">
																																	<xsl:choose>
																																		<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																																		<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																																	</xsl:choose>
																																</xsl:attribute>
																																<xsl:if test="$image_height &gt; 0">
																																	<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																																</xsl:if>
																															</img>
																														</a>
																													</td>
																													<xsl:if test="icon != '' and contains(style, 'dubbel')">
																														<td style="vertical-align: top;" class="ctImgInnerRight">
																															<a target="_blank">
																																<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																																<img border="0">
																																	<xsl:attribute name="width"><xsl:value-of select="$imageright_width" /></xsl:attribute>
																																	<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageright_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																																	<xsl:attribute name="alt"><xsl:value-of select="icon_alt" /></xsl:attribute>
																																	<xsl:attribute name="title"><xsl:value-of select="icon_title" /></xsl:attribute>
																																	<xsl:attribute name="src">
																																		<xsl:choose>
																																			<xsl:when test="contains(icon, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																																			<xsl:otherwise><xsl:value-of select="icon" /></xsl:otherwise>
																																		</xsl:choose>
																																	</xsl:attribute>
																																	<xsl:if test="$image_height &gt; 0">
																																		<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																																	</xsl:if>
																																</img>
																															</a>
																														</td>
																													</xsl:if>
																												</tr>
																											</table>

																										</xsl:when>
																										<xsl:otherwise>

																											<table cellpadding="0" cellspacing="0" width="100%" class="ctImgInnerCont">
																												<tr>
																													<td style="vertical-align: top;" class="ctImgInnerLeft">
																														<img border="0">
																															<xsl:attribute name="width"><xsl:value-of select="$imageleft_width" /></xsl:attribute>
																															<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageleft_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																															<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																															<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																															<xsl:attribute name="src">
																																<xsl:choose>
																																	<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																																	<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																																</xsl:choose>
																															</xsl:attribute>
																															<xsl:if test="$image_height &gt; 0">
																																<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																															</xsl:if>
																														</img>
																													</td>
																													<xsl:if test="icon != '' and contains(style, 'dubbel')">
																														<td style="vertical-align: top;" class="ctImgInnerRight">
																															<img border="0">
																																<xsl:attribute name="width"><xsl:value-of select="$imageright_width" /></xsl:attribute>
																																<xsl:attribute name="style">display: block; width: <xsl:value-of select="$imageright_width" />px;<xsl:if test="$image_height &gt; 0"> height: <xsl:value-of select="$image_height" />px;</xsl:if></xsl:attribute>
																																<xsl:attribute name="alt"><xsl:value-of select="icon_alt" /></xsl:attribute>
																																<xsl:attribute name="title"><xsl:value-of select="icon_title" /></xsl:attribute>
																																<xsl:attribute name="src">
																																	<xsl:choose>
																																		<xsl:when test="contains(icon, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$width" />x300</xsl:when>
																																		<xsl:otherwise><xsl:value-of select="icon" /></xsl:otherwise>
																																	</xsl:choose>
																																</xsl:attribute>
																																<xsl:if test="$image_height &gt; 0">
																																	<xsl:attribute name="height"><xsl:value-of select="$image_height" /></xsl:attribute>
																																</xsl:if>
																															</img>
																														</td>
																													</xsl:if>
																												</tr>
																											</table>

																										</xsl:otherwise>
																									</xsl:choose>

																									<!-- when db.extra2 field is filled, show it as image subtitle / photo credits -->
																									<xsl:if test="extra2 != ''">

																										<xsl:variable name="photocredits-color">
																											<xsl:call-template name="color">
																												<xsl:with-param name="colors" select="extra1" />
																												<xsl:with-param name="part">fotocredits</xsl:with-param>
																											</xsl:call-template>
																										</xsl:variable>

																										<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																											<tr>
																												<td class="ctImgSubt">
																													<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																													<xsl:if test="contains(style, 'gecentreerd') or $photocredits-color != ''">
																														<xsl:attribute name="style">
																															<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																															<xsl:if test="$photocredits-color">color: <xsl:value-of select="$photocredits-color" /></xsl:if>
																														</xsl:attribute>
																													</xsl:if>

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
																						<xsl:if test="not(contains(style, '(afbeelding)')) and $hide_content = 0">
																							<tr>
																								<td>
																									<!-- ##JWDB 8 may 2020: Added extra class for border logic, with this you can check of the middle line between image and content is needed -->
																									<xsl:attribute name="class">
																										<xsl:choose>
																											<xsl:when test="image = '' and not(contains(style, 'afb.'))">ctInnerContNoImg</xsl:when>
																											<xsl:otherwise>ctInnerContImg</xsl:otherwise>
																										</xsl:choose>
																									</xsl:attribute>

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
                                                                                                            ##JWDB 8 may 2010: Fixed bug with empty image field (image != '' validation added)
                                                                                                            -->
																											<xsl:if test="image != '' and contains(style, 'afb.')">
																												<th>
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

																																<!-- JWDB June 2020: border color can be configured per item -->
																																<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																																	<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																																</xsl:if>

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

																																				<xsl:variable name="photocredits-color">
																																					<xsl:call-template name="color">
																																						<xsl:with-param name="colors" select="extra1" />
																																						<xsl:with-param name="part">fotocredits</xsl:with-param>
																																					</xsl:call-template>
																																				</xsl:variable>

																																				<xsl:if test="$photocredits-color != ''">
																																					<xsl:attribute name="style">color: <xsl:value-of select="$photocredits-color" /></xsl:attribute>
																																				</xsl:if>

																																				<xsl:value-of select="extra2" />
																																			</td>
																																		</tr>
																																	</table>
																																</xsl:if>
																															</td>
																														</tr>
																													</table>
																												</th>
																											</xsl:if>
																											<!-- Content and buttons container -->
																											<th dir="ltr">
																												<xsl:attribute name="class">
																													<xsl:choose>
																														<xsl:when test="contains(style, 'afb.')">ctOuterBlockAfbLr</xsl:when>
																														<xsl:otherwise>ctOuterBlock</xsl:otherwise>
																													</xsl:choose>
																												</xsl:attribute>

																												<!-- JWDB June 2020: border color can be configured per item -->
																												<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																													<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																												</xsl:if>

																												<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
																													<tr>
																														<!-- BLOCK CONTENT (title, subtitle, date) with text and buttons -->
																														<td class="ctInnerBlock" style="vertical-align: top;">

																															<!-- JWDB August 2020: moved all visibility checks to here, so we can hide the entire table if needed -->
																															<xsl:variable name="hide_title">
																																<xsl:choose>
																																	<xsl:when test="not(contains(style, 'titels boven'))">
																																		<xsl:choose>
																																			<xsl:when test="(not(contains(style, 'geen titel')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">0</xsl:when>
																																			<xsl:otherwise>1</xsl:otherwise>
																																		</xsl:choose>
																																	</xsl:when>
																																	<xsl:otherwise>1</xsl:otherwise>
																																</xsl:choose>
																															</xsl:variable>

																															<xsl:variable name="hide_innercontent">
																																<xsl:choose>
																																	<xsl:when test="not(contains(style, 'banner')) and content != ''">0</xsl:when>
																																	<xsl:otherwise>1</xsl:otherwise>
																																</xsl:choose>
																															</xsl:variable>

																															<xsl:variable name="hide_buttons">
																																<xsl:choose>
																																	<xsl:when test="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON'))))">0</xsl:when>
																																	<xsl:otherwise>1</xsl:otherwise>
																																</xsl:choose>
																															</xsl:variable>

																															<xsl:if test="$hide_title = 0 or $hide_innercontent = 0 or $hide_buttons = 0">
																																<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

																																	<!-- Hide title when item.style.name contains "geen titel", or content of db.title contains 'NOTITLE' (case sensitive)
                                                                                                                                    The titles in banner styles cannot be hidden
                                                                                                                                    Hide this part when the style name contains trigger words 'titels boven' -->
																																	<xsl:if test="$hide_title = 0">
																																		<xsl:call-template name="titles" />
																																	</xsl:if>

																																	<!-- Content
                                                                                                                                    Hide this part when using banner blocks
                                                                                                                                    ##JWDB 31 march 2020: when using index item style, show a list with all items in this newsletter with some exceptions (sub headers, this item, full image items, call2action and items with NOTITLE)
                                                                                                                                    The validation on ending <br> in content is to prevent we're adding too many enters
                                                                                                                                    -->
																																	<xsl:if test="$hide_innercontent = 0">
																																		<tr>
																																			<td class="content">

																																				<xsl:variable name="content-color">
																																					<xsl:call-template name="color">
																																						<xsl:with-param name="colors" select="extra1" />
																																						<xsl:with-param name="part">content</xsl:with-param>
																																					</xsl:call-template>
																																				</xsl:variable>

																																				<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																																				<xsl:if test="contains(style, 'gecentreerd') or $content-color != ''">
																																					<xsl:attribute name="style">
																																						<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																																						<xsl:if test="$content-color != ''">color: <xsl:value-of select="$content-color" /> !important; color: <xsl:value-of select="$content-color" />;</xsl:if>
																																					</xsl:attribute>
																																				</xsl:if>

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
																																	<xsl:if test="$hide_buttons = 0">
																																		<tr style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">
																																			<xsl:attribute name="class">
																																				<xsl:choose>
																																					<xsl:when test="contains(style, 'banner')">ctMobButContBan</xsl:when>
																																					<xsl:when test="contains(style, 'uitgelicht') or $background-color !=''">ctMobButContFeat</xsl:when>
																																					<xsl:otherwise>ctMobButCont</xsl:otherwise>
																																				</xsl:choose>
																																			</xsl:attribute>
																																			<td class="ctMobButBlock">

																																				<table cellpadding="0" cellspacing="0" class="ctMobInnerCont" style="display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;">

																																					<!-- ##JWDB 31 march 2020: buttons can be aligned middle or right by adding 'button midden' or 'button rechts' in the style name -->
																																					<xsl:attribute name="align">
																																						<xsl:choose>
																																							<xsl:when test="contains(style, 'button midden') or contains(style, 'gecentreerd')">center</xsl:when>
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
																																											<xsl:when test="contains(style, 'banner') or contains(style, 'uitgelicht') or $background-color != ''"><xsl:value-of select="$button_icon_feature" /></xsl:when>
																																											<xsl:otherwise><xsl:value-of select="$button_icon" /></xsl:otherwise>
																																										</xsl:choose>
																																									</xsl:with-param>
																																									<xsl:with-param name="row" select="." />
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
																																											<xsl:when test="contains(style, 'banner') or contains(style, 'uitgelicht') or $background-color != ''"><xsl:value-of select="$button2_icon_feature" /></xsl:when>
																																											<xsl:otherwise><xsl:value-of select="$button2_icon" /></xsl:otherwise>
																																										</xsl:choose>
																																									</xsl:with-param>
																																									<xsl:with-param name="row" select="." />
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
																																	<xsl:if test="$hide_buttons = 0">

																																		<!-- check if the following or previous 1/2, 1/3 or 2/3 items have buttons
                                                                                                                                        If not, then show this part to prevent unwanted white spaces between text and buttons -->
																																		<xsl:variable name="previous_buttons_2" select="((preceding-sibling::*[contains(style, 'Item')][2]/url != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][2]/image_alt, 'NOBUTTON'))) or (preceding-sibling::*[contains(style, 'Item')][2]/url2 != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][2]/icon2, 'NOBUTTON'))))" />
																																		<xsl:variable name="previous_buttons_1" select="((preceding-sibling::*[contains(style, 'Item')][1]/url != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][1]/image_alt, 'NOBUTTON'))) or (preceding-sibling::*[contains(style, 'Item')][1]/url2 != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][1]/icon2, 'NOBUTTON'))))" />
																																		<xsl:variable name="next_buttons_1" select="((following-sibling::*[contains(style, 'Item')][1]/url != '' and not(contains(following-sibling::*[contains(style, 'Item')][1]/image_alt, 'NOBUTTON'))) or (following-sibling::*[contains(style, 'Item')][1]/url2 != '' and not(contains(following-sibling::*[contains(style, 'Item')][1]/icon2, 'NOBUTTON'))))" />
																																		<xsl:variable name="next_buttons_2" select="((following-sibling::*[contains(style, 'Item')][2]/url != '' and not(contains(following-sibling::*[contains(style, 'Item')][2]/image_alt, 'NOBUTTON'))) or (following-sibling::*[contains(style, 'Item')][2]/url2 != '' and not(contains(following-sibling::*[contains(style, 'Item')][2]/icon2, 'NOBUTTON'))))" />

																																		<xsl:variable name="show_buttons">
																																			<xsl:choose>
																																				<!-- As first 1/2 item in the block -->
																																				<xsl:when test="contains(style, '1/2') and rule_end = 'false' and not($next_buttons_1) and
																														contains(following-sibling::*[contains(style, 'Item')][1]/style, '1/2')">1</xsl:when>

																																				<!-- As second 1/2 item in the block -->
																																				<xsl:when test="contains(style, '1/2') and rule_end = 'true' and not($previous_buttons_1) and
																														contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/2')">1</xsl:when>

																																				<!-- As first 2/3 item in the block -->
																																				<xsl:when test="contains(style, '2/3') and rule_end = 'false' and not($next_buttons_1)">1</xsl:when>

																																				<!-- As second 2/3 item in the block -->
																																				<xsl:when test="contains(style, '2/3') and rule_end = 'true' and not($previous_buttons_1)">1</xsl:when>

																																				<!-- As first 1/3 item in the block in combination with a 2/3 item -->
																																				<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($next_buttons_1) and
																														contains(following-sibling::*[contains(style, 'Item')][1]/style, '2/3') and
																														following-sibling::*[contains(style, 'Item')][1]/rule_end = 'true'">1</xsl:when>

																																				<!-- As last 1/3 item in the block in combination with a 2/3 item -->
																																				<xsl:when test="contains(style, '1/3') and rule_end = 'true' and not($previous_buttons_1) and
																														contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '2/3') and
																														preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false'">1</xsl:when>

																																				<!-- As first 1/3 item in the block in combination with two other 1/3 items -->
																																				<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($next_buttons_1) and not($next_buttons_2) and
																														contains(following-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
																														following-sibling::*[contains(style, 'Item')][1]/rule_end = 'false' and
																														contains(following-sibling::*[contains(style, 'Item')][2]/style, '1/3') and
																														following-sibling::*[contains(style, 'Item')][2]/rule_end = 'true'">1</xsl:when>

																																				<!-- As second 1/3 item in the block in combination with two other 1/3 items -->
																																				<xsl:when test="contains(style, '1/3') and rule_end = 'false' and not($previous_buttons_1) and not($next_buttons_1) and
																														contains(following-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
																														following-sibling::*[contains(style, 'Item')][1]/rule_end = 'true' and
																														contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
																														preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false'">1</xsl:when>

																																				<!-- As third 1/3 item in the block in combination with two other 1/3 items -->
																																				<xsl:when test="contains(style, '1/3') and rule_end = 'true' and not($previous_buttons_1) and not($previous_buttons_2) and
																														contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
																														preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false' and
																														contains(preceding-sibling::*[contains(style, 'Item')][2]/style, '1/3') and
																														preceding-sibling::*[contains(style, 'Item')][2]/rule_end = 'false'">1</xsl:when>

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
																															</xsl:if>
																														</td>
																													</tr>
																												</table>
																											</th>
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
														</th>

														<!-- End of block -->
														<xsl:choose>
															<xsl:when test="contains(style, '1/2') or contains(style, '1/3') or contains(style, '2/3')">
																<xsl:if test="rule_end != 'true'"><xsl:text disable-output-escaping="yes"><![CDATA[<th class="ctBlockMargin">&nbsp;</th>]]></xsl:text></xsl:if>

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
																<xsl:variable name="previous_buttons_2" select="((preceding-sibling::*[contains(style, 'Item')][2]/url != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][2]/image_alt, 'NOBUTTON'))) or (preceding-sibling::*[contains(style, 'Item')][2]/url2 != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][2]/icon2, 'NOBUTTON'))))" />
																<xsl:variable name="previous_buttons_1" select="((preceding-sibling::*[contains(style, 'Item')][1]/url != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][1]/image_alt, 'NOBUTTON'))) or (preceding-sibling::*[contains(style, 'Item')][1]/url2 != '' and not(contains(preceding-sibling::*[contains(style, 'Item')][1]/icon2, 'NOBUTTON'))))" />
																<xsl:variable name="current_buttons" select="((url != '' and not(contains(image_alt, 'NOBUTTON'))) or (url2 != '' and not(contains(icon2, 'NOBUTTON'))))"></xsl:variable>

																<xsl:variable name="show_buttons">
																	<xsl:choose>
																		<!-- First 1/2 haves buttons and second one not -->
																		<xsl:when test="contains(style, '1/2') and not($current_buttons) and $previous_buttons_1 and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/2')">0</xsl:when>

																		<!-- Second 1/2 haves buttons and first one not -->
																		<xsl:when test="contains(style, '1/2') and $current_buttons and not($previous_buttons_1) and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/2')">0</xsl:when>

																		<!-- First 2/3 haves buttons and second 1/3 not -->
																		<xsl:when test="contains(style, '1/3') and not($current_buttons) and $previous_buttons_1 and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '2/3') and
												preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false'">0</xsl:when>

																		<!-- Second 2/3 haves buttons and first 1/3 not -->
																		<xsl:when test="contains(style, '2/3') and $current_buttons and not($previous_buttons_1) and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false'">0</xsl:when>

																		<!-- first 1/3 haves buttons and other 1/3 items not -->
																		<xsl:when test="contains(style, '1/3') and not($current_buttons) and not($previous_buttons_1) and $previous_buttons_2 and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false' and
												contains(preceding-sibling::*[contains(style, 'Item')][2]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][2]/rule_end = 'false'">0</xsl:when>

																		<!-- second 1/3 haves buttons and other 1/3 items not -->
																		<xsl:when test="contains(style, '1/3') and not($current_buttons) and $previous_buttons_1 and not($previous_buttons_2) and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false' and
												contains(preceding-sibling::*[contains(style, 'Item')][2]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][2]/rule_end = 'false'">0</xsl:when>

																		<!-- third 1/3 haves buttons and other 1/3 items not -->
																		<xsl:when test="contains(style, '1/3') and $current_buttons and not($previous_buttons_1) and not($previous_buttons_2) and
												contains(preceding-sibling::*[contains(style, 'Item')][1]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][1]/rule_end = 'false' and
												contains(preceding-sibling::*[contains(style, 'Item')][2]/style, '1/3') and
												preceding-sibling::*[contains(style, 'Item')][2]/rule_end = 'false'">0</xsl:when>

																		<xsl:otherwise>1</xsl:otherwise>
																	</xsl:choose>
																</xsl:variable>

																<xsl:if test="$show_buttons = 1 and $hide_content = 0">
																	<tr>
																		<td class="ctDeskButCont">
																			<table cellpadding="0" cellspacing="0">
																				<tr>
																					<!-- BUTTON 1 -->
																					<xsl:if test="preceding-sibling::*[contains(style, 'Item')][2]/rule_end != 'true' and preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
																						<xsl:call-template name="button_container">
																							<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][2]" />
																						</xsl:call-template>

																						<th class="ctBlockMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
																					</xsl:if>

																					<!-- BUTTON 2 -->
																					<xsl:if test="preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
																						<xsl:call-template name="button_container">
																							<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][1]" />
																						</xsl:call-template>

																						<th class="ctBlockMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
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

															<!-- ##JWDB april 2020: Ending row, used for very specified styles as bordered items -->
															<tr>
																<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
																<xsl:attribute name="class">
																	<xsl:choose>
																		<xsl:when test="contains(extra3, 'NOBORDER')">ctNoBorder</xsl:when>
																		<xsl:otherwise></xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>

																<td>
																	<!-- JWDB June 2020: better classes for ctEndingOuterCont -->
																	<xsl:attribute name="class">
																		<xsl:choose>
																			<xsl:when test="position() = last()">
																				<xsl:choose>
																					<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and (contains(style, 'uitgelicht') or $background-color != '')">ctEndingOuterContFeatLast</xsl:when>
																					<xsl:when test="contains(style, 'banner')">ctEndingOuterContBanLast</xsl:when>
																					<xsl:otherwise>ctEndingOuterContLast</xsl:otherwise>
																				</xsl:choose>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:choose>
																					<xsl:when test="not(contains(style, '1/')) and not(contains(style, '2/')) and (contains(style, 'uitgelicht') or $background-color != '')">ctEndingOuterContFeat</xsl:when>
																					<xsl:when test="contains(style, 'banner')">ctEndingOuterContBan</xsl:when>
																					<xsl:otherwise>ctEndingOuterCont</xsl:otherwise>
																				</xsl:choose>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>

																	<table cellpadding="0" cellspacing="0">
																		<tr>
																			<xsl:if test="preceding-sibling::*[contains(style, 'Item')][2]/rule_end != 'true' and preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
																				<xsl:call-template name="ending_container">
																					<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][2]" />
																				</xsl:call-template>

																				<th class="ctEndingMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
																			</xsl:if>

																			<xsl:if test="preceding-sibling::*[contains(style, 'Item')][1]/rule_end != 'true'">
																				<xsl:call-template name="ending_container">
																					<xsl:with-param name="row" select="preceding-sibling::*[contains(style, 'Item')][1]" />
																				</xsl:call-template>

																				<th class="ctEndingMargin"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></th>
																			</xsl:if>

																			<xsl:call-template name="ending_container">
																				<xsl:with-param name="row" select="." />
																			</xsl:call-template>
																		</tr>
																	</table>
																</td>
															</tr>

														</xsl:if>

													</xsl:when>

													<!-- BLOCKSTYLE: Call2action -->
													<xsl:when test="contains(style, 'call2action')">

														<tr>
															<!-- Basic block -->
															<td>
																<!-- JWDB June 2020: With or without border based on db.extra3 field -->
																<xsl:attribute name="class">
																	<xsl:choose>
																		<xsl:when test="$border_width &gt; 0 and contains(extra3, 'NOBORDER')">ctCallMainBlockNoBorder</xsl:when>
																		<xsl:otherwise>ctCallMainBlock</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>

																<!-- JWDB June 2020: Custom border color -->
																<xsl:if test="extra3 != '' and not(contains(style, 'NOBORDER'))">
																	<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																</xsl:if>

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
																									<xsl:if test="$background-color != ''">
																										<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
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
																								<xsl:if test="$background-color != ''">
																									<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
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
                                                    You have still to create Agenda items
                                                    JWDB June 2020: deleted ctMainBlockItem container
                                                    -->
													<xsl:when test="contains(style, 'agenda')">
														<xsl:call-template name="agenda_container">
															<xsl:with-param name="with_data">1</xsl:with-param>
														</xsl:call-template>
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

									</xsl:when>
									<xsl:otherwise>
										<xsl:text disable-output-escaping="yes"> </xsl:text>
									</xsl:otherwise>
								</xsl:choose>

							</th>
							<xsl:if test="$sidebar_active = 1">
								<th class="sbMainOuterCont">

									<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">
										<tr>
											<td class="sbMainInnerCont">

												<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">
													<tr>
														<td class="sbMainContentCont">

															<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%" class="ctMainTable">

																<!-- Blocks are grouped on blockstyle-name-first-word (Item, Agenda, Sidebar)
                                                                Loop through block-styles starting with 'Sidebar' -->
																<xsl:for-each select="matches/match[contains(style, 'Sidebar')]">

																	<!-- ##JWDB 24 July 2020: pick colors from db.extra1 field -->
																	<xsl:variable name="background-color">
																		<xsl:call-template name="color">
																			<xsl:with-param name="colors" select="extra1" />
																			<xsl:with-param name="part">achtergrond</xsl:with-param>
																		</xsl:call-template>
																	</xsl:variable>

																	<xsl:choose>

																		<xsl:when test="not(contains(style, 'tussenkopje'))">

																			<tr>
																				<th>
																					<xsl:attribute name="class">
																						<xsl:choose>
																							<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">sbMainBlockFeat</xsl:when>
																							<xsl:otherwise>sbMainBlock</xsl:otherwise>
																						</xsl:choose>
																					</xsl:attribute>

																					<!--
                                                                                    When db.extra1 is filled, then a custom background color is set.
                                                                                    -->
																					<xsl:if test="$background-color != ''">
																						<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
																					</xsl:if>

																					<!-- JWDB June 2020: border color can be configured per item -->
																					<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																						<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
																					</xsl:if>

																					<!-- ##JWDB 8 may 2020: borders can be hidden by putting NOBORDER in extra3 field -->
																					<xsl:variable name="bordered_width">
																						<xsl:choose>
																							<xsl:when test="contains(style, 'afb.')"><xsl:value-of select="$sidebar_width" /></xsl:when>
																							<xsl:when test="$border_width > 0 and not(contains(extra3, 'NOBORDER'))"><xsl:value-of select="$sidebar_width - ($border_width * 2)" /></xsl:when>
																							<xsl:otherwise><xsl:value-of select="$sidebar_width" /></xsl:otherwise>
																						</xsl:choose>
																					</xsl:variable>

																					<table cellpadding="0" cellspacing="0" class="ctMainTable">
																						<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
																						<xsl:attribute name="style">width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
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
																													<xsl:when test="contains(style, 'uitgelicht') or $background-color != ''">sbInnerContFeat</xsl:when>
																													<xsl:otherwise>sbInnerCont</xsl:otherwise>
																												</xsl:choose>
																											</xsl:attribute>

																											<!--
                                                                                                            When db.extra1 is filled, then a custom background color is set.
                                                                                                            This logic is double with the TD above, but it is needed for the BLOKKEN_EDITOR
                                                                                                            -->
																											<xsl:if test="$background-color != ''">
																												<xsl:attribute name="style">background-color: <xsl:value-of select="$background-color" />;</xsl:attribute>
																											</xsl:if>

																											<!-- JWDB June 2020: border color can be configured per item -->
																											<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																												<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;<xsl:if test="$background-color != ''">background-color: <xsl:value-of select="$background-color" />;</xsl:if></xsl:attribute>
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
                                                                                                                Hide this part when using image left/right styles
                                                                                                                JWDB June 2020: double left and right logic implemented -->
																												<xsl:if test="image != '' and not(contains(style, 'afb.'))">
																													<tr>
																														<td>
																															<!-- ##JWDB 26 march 2020: when the image width is smaller than 480, then don't stretch out on mobile. So add other class to them -->
																															<!-- ##JWDB June 2020: changed 460px to 400 to be sure 2/3 items will be expanded to 100% width due responsive issue in iPhones -->
																															<xsl:attribute name="class">
																																<xsl:choose>
																																	<xsl:when test="$sidebar_width &lt; 400">sbImgSmall</xsl:when>
																																	<xsl:otherwise>sbImg</xsl:otherwise>
																																</xsl:choose>
																															</xsl:attribute>

																															<xsl:choose>
																																<xsl:when test="url != ''">

																																	<table cellpadding="0" cellspacing="0" width="100%" class="sbImgInnerCont">
																																		<tr>
																																			<td style="vertical-align: top;" class="sbImgInner">
																																				<a target="_blank">
																																					<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>

																																					<img border="0">
																																						<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
																																						<xsl:attribute name="style">display: block; width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
																																						<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																																						<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																																						<xsl:attribute name="src">
																																							<xsl:choose>
																																								<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$bordered_width" />x300</xsl:when>
																																								<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																																							</xsl:choose>
																																						</xsl:attribute>
																																					</img>
																																				</a>
																																			</td>

																																		</tr>
																																	</table>

																																</xsl:when>
																																<xsl:otherwise>

																																	<table cellpadding="0" cellspacing="0" width="100%" class="sbImgInnerCont">
																																		<tr>
																																			<td style="vertical-align: top;" class="sbImgInner">
																																				<img border="0">
																																					<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
																																					<xsl:attribute name="style">display: block; width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
																																					<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																																					<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																																					<xsl:attribute name="src">
																																						<xsl:choose>
																																							<xsl:when test="contains(image, 'placeholder.png')">https://via.placeholder.com/<xsl:value-of select="$bordered_width" />x300</xsl:when>
																																							<xsl:otherwise><xsl:value-of select="image" /></xsl:otherwise>
																																						</xsl:choose>
																																					</xsl:attribute>
																																				</img>
																																			</td>
																																		</tr>
																																	</table>

																																</xsl:otherwise>
																															</xsl:choose>

																															<!-- when db.extra2 field is filled, show it as image subtitle / photo credits -->
																															<xsl:if test="extra2 != ''">

																																<xsl:variable name="photocredits-color">
																																	<xsl:call-template name="color">
																																		<xsl:with-param name="colors" select="extra1" />
																																		<xsl:with-param name="part">fotocredits</xsl:with-param>
																																	</xsl:call-template>
																																</xsl:variable>

																																<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																																	<tr>
																																		<td class="sbImgSubt">
																																			<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																																			<xsl:if test="contains(style, 'gecentreerd') or $photocredits-color != ''">
																																				<xsl:attribute name="style">
																																					<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																																					<xsl:if test="$photocredits-color">color: <xsl:value-of select="$photocredits-color" /></xsl:if>
																																				</xsl:attribute>
																																			</xsl:if>

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
																														<td class="sbImg">
																															<img>
																																<xsl:attribute name="width"><xsl:value-of select="$bordered_width" /></xsl:attribute>
																																<xsl:attribute name="style">display: block; width: <xsl:value-of select="$bordered_width" />px;</xsl:attribute>
																																<xsl:attribute name="alt"><xsl:value-of select="image_alt1" /></xsl:attribute>
																																<xsl:attribute name="title"><xsl:value-of select="image_title" /></xsl:attribute>
																																<xsl:attribute name="src">https://via.placeholder.com/<xsl:value-of select="$bordered_width" />x300?text=GEEN AFBEELDING</xsl:attribute>
																															</img>
																														</td>
																													</tr>
																												</xsl:if>

																												<!-- Hide entire content container when using image only block style -->
																												<xsl:if test="not(contains(style, '(afbeelding)'))">
																													<tr>
																														<td>
																															<!-- ##JWDB 8 may 2020: Added extra class for border logic, with this you can check of the middle line between image and content is needed -->
																															<xsl:attribute name="class">
																																<xsl:choose>
																																	<xsl:when test="image = '' and not(contains(style, 'afb.'))">sbInnerContNoImg</xsl:when>
																																	<xsl:otherwise>sbInnerContImg</xsl:otherwise>
																																</xsl:choose>
																															</xsl:attribute>

																															<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
																																<tr>
																																	<!-- Content and buttons container -->
																																	<th class="sbOuterBlock">

																																		<!-- JWDB June 2020: border color can be configured per item -->
																																		<xsl:if test="$border_width > 0 and extra3 != '' and not(contains(extra3, 'NOBORDER'))">
																																			<xsl:attribute name="style">border-color: <xsl:value-of select="extra3" />;</xsl:attribute>
																																		</xsl:if>

																																		<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%;">
																																			<tr>
																																				<!-- BLOCK CONTENT (title, subtitle, date) with text and buttons -->
																																				<td class="sbInnerBlock" style="vertical-align: top;">

																																					<!-- JWDB August 2020: moved all visibility checks to here, so we can hide the entire table if needed -->
																																					<xsl:variable name="hide_title">
																																						<xsl:choose>
																																							<xsl:when test="not(contains(style, 'titels boven'))">
																																								<xsl:choose>
																																									<xsl:when test="(not(contains(style, 'geen titel')) and not(contains(title, 'NOTITLE'))) or contains(style, 'banner')">0</xsl:when>
																																									<xsl:otherwise>1</xsl:otherwise>
																																								</xsl:choose>
																																							</xsl:when>
																																							<xsl:otherwise>1</xsl:otherwise>
																																						</xsl:choose>
																																					</xsl:variable>

																																					<xsl:variable name="hide_innercontent">
																																						<xsl:choose>
																																							<xsl:when test="content != ''">0</xsl:when>
																																							<xsl:otherwise>1</xsl:otherwise>
																																						</xsl:choose>
																																					</xsl:variable>

																																					<xsl:variable name="hide_buttons">
																																						<xsl:choose>
																																							<xsl:when test="url != '' and not(contains(image_alt, 'NOBUTTON'))">0</xsl:when>
																																							<xsl:otherwise>1</xsl:otherwise>
																																						</xsl:choose>
																																					</xsl:variable>

																																					<xsl:if test="$hide_title = 0 or $hide_innercontent = 0 or $hide_buttons = 0">
																																						<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">

																																							<!-- Hide title when item.style.name contains "geen titel", or content of db.title contains 'NOTITLE' (case sensitive)
                                                                                                                                                            The titles in banner styles cannot be hidden
                                                                                                                                                            Hide this part when the style name contains trigger words 'titels boven' -->
																																							<xsl:if test="$hide_title = 0">
																																								<xsl:call-template name="titles">
																																									<xsl:with-param name="classPrefix">sb</xsl:with-param>
																																								</xsl:call-template>
																																							</xsl:if>

																																							<!-- Content
                                                                                                                                                            Hide this part when using banner blocks
                                                                                                                                                            ##JWDB 31 march 2020: when using index item style, show a list with all items in this newsletter with some exceptions (sub headers, this item, full image items, call2action and items with NOTITLE)
                                                                                                                                                            The validation on ending <br> in content is to prevent we're adding too many enters
                                                                                                                                                            -->
																																							<xsl:if test="$hide_innercontent = 0">
																																								<tr>
																																									<td class="sbContent">

																																										<xsl:variable name="content-color">
																																											<xsl:call-template name="color">
																																												<xsl:with-param name="colors" select="extra1" />
																																												<xsl:with-param name="part">content</xsl:with-param>
																																											</xsl:call-template>
																																										</xsl:variable>

																																										<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
																																										<xsl:if test="contains(style, 'gecentreerd') or $content-color != ''">
																																											<xsl:attribute name="style">
																																												<xsl:if test="contains(style, 'gecentreerd')">text-align: center;</xsl:if>
																																												<xsl:if test="$content-color != ''">color: <xsl:value-of select="$content-color" /> !important; color: <xsl:value-of select="$content-color" />;</xsl:if>
																																											</xsl:attribute>
																																										</xsl:if>

																																										<xsl:value-of select="content" disable-output-escaping="yes" />

																																										<xsl:if test="$hide_buttons = 0">
																																											<xsl:variable name="buttontext-color">
																																												<xsl:call-template name="color">
																																													<xsl:with-param name="colors" select="extra1" />
																																													<xsl:with-param name="part">buttontekst</xsl:with-param>
																																												</xsl:call-template>
																																											</xsl:variable>

																																											<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
																																											<a target="_blank">
																																												<xsl:if test="$buttontext-color != ''">
																																													<xsl:attribute name="style">color: <xsl:value-of select="$buttontext-color" /> !important; color: <xsl:value-of select="$buttontext-color" /></xsl:attribute>
																																												</xsl:if>
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
																																					</xsl:if>
																																				</td>
																																			</tr>
																																		</table>
																																	</th>
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
																				</th>

																				<!-- End of block -->
																			</tr>

																		</xsl:when>

																		<!-- BLOCKSTYLE: Tussenkop
                                                                        Shows a subheader to separate items in groups-->
																		<xsl:when test="contains(style, 'tussenkopje')">

																			<tr>
																				<!-- start block -->
																				<td>
																					<!-- ##JWDB 26 march 2020: added class logic for featured subheader style -->
																					<xsl:attribute name="class">
																						<xsl:choose>
																							<xsl:when test="contains(style, 'uitgelicht')">sbSubhMainBlockFeat</xsl:when>
																							<xsl:otherwise>sbSubhMainBlock</xsl:otherwise>
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
																										<xsl:when test="contains(style, 'uitgelicht')">sbSubhOuterContFeat</xsl:when>
																										<xsl:otherwise>sbSubhOuterCont</xsl:otherwise>
																									</xsl:choose>
																								</xsl:attribute>

																								<table width="100%" cellpadding="0" cellspacing="0" style="width: 100%">
																									<tr>
																										<td>
																											<!-- ##JWDB 26 march 2020: added class logic for featured subheader style -->
																											<xsl:attribute name="class">
																												<xsl:choose>
																													<xsl:when test="contains(style, 'uitgelicht')">sbSubhInnerContFeat</xsl:when>
																													<xsl:otherwise>sbSubhInnerCont</xsl:otherwise>
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

																		</xsl:when>

																	</xsl:choose>

																</xsl:for-each>

															</table>

														</td>
													</tr>
												</table>

											</td>
										</tr>
									</table>

								</th>
							</xsl:if>
						</tr>

					</table>

				</td>

			</tr>
			<!-- END ITEMS and SIDEBAR SECTION -->

		</table>

	</xsl:template>

	<!--
	Central template for date text.
	When you empty the date fields in the content block details, then the dates will be saved as 1 january 2000.
	Or use the db.extra4 field (alernative date)
	-->
	<xsl:template name="date_subtitle">
		<xsl:param name="row" />

		<xsl:choose>
			<xsl:when test="$row/extra4 != ''">
				<xsl:value-of select="$row/extra4" disable-output-escaping="yes" />
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
				<xsl:otherwise><xsl:value-of select="$width_full" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="button_width_bordered">
			<xsl:choose>
				<xsl:when test="$border_width > 0 and not(contains($row/extra3, 'NOBORDER'))"><xsl:value-of select="$button_width - ($border_width * 2)" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$button_width" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="background-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="$row/extra1" />
				<xsl:with-param name="part">achtergrond</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<td>
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$ignore_width = 1 and $background-color != ''">width: 100%; background-color: <xsl:value-of select="$background-color" />;</xsl:when>
					<xsl:when test="$ignore_width = 1">width: 100%;</xsl:when>
					<xsl:when test="$background-color != ''">width: <xsl:value-of select="$button_width_bordered" />px; background-color: <xsl:value-of select="$background-color" />;</xsl:when>
					<xsl:otherwise>width: <xsl:value-of select="$button_width_bordered" />px;</xsl:otherwise>
				</xsl:choose>

				<!-- JWDB June 2020: border color can be configured per item -->
				<xsl:if test="$border_width > 0 and $row/extra3 != '' and not(contains($row/extra3, 'NOBORDER'))">border-color: <xsl:value-of select="$row/extra3" />;</xsl:if>
			</xsl:attribute>

			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="contains($row/extra3, 'NOBORDER')">
						<xsl:choose>
							<xsl:when test="contains($row/style, 'banner')">ctButContBanNoBorder</xsl:when>
							<xsl:when test="contains($row/style, 'uitgelicht') or $background-color !=''">ctButContFeatNoBorder</xsl:when>
							<xsl:otherwise>ctButContNoBorder</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="contains($row/style, 'banner')">ctButContBan</xsl:when>
							<xsl:when test="contains($row/style, 'uitgelicht') or $background-color !=''">ctButContFeat</xsl:when>
							<xsl:otherwise>ctButCont</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<table cellspacing="0" cellpadding="0" class="ctButOuterTable">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="$ignore_width = 1">width: 100%</xsl:when>
						<xsl:otherwise>width: <xsl:value-of select="$button_width_bordered" />px;</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="width">
					<xsl:choose>
						<xsl:when test="$ignore_width = 1">100%</xsl:when>
						<xsl:otherwise><xsl:value-of select="$button_width_bordered" /></xsl:otherwise>
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
											<xsl:when test="contains($row/style, 'button midden') or contains($row/style, 'gecentreerd')">center</xsl:when>
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
															<xsl:when test="contains($row/style, 'banner') or contains($row/style, 'uitgelicht') or $background-color != ''"><xsl:value-of select="$button_icon_feature" /></xsl:when>
															<xsl:otherwise><xsl:value-of select="$button_icon" /></xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="row" select="$row" />
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
															<xsl:when test="contains($row/style, 'banner') or contains($row/style, 'uitgelicht') or $background-color != ''"><xsl:value-of select="$button2_icon_feature" /></xsl:when>
															<xsl:otherwise><xsl:value-of select="$button2_icon" /></xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="row" select="$row" />
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
	##JWDB april 2020 Central template for ending row
	Used for bottom margin of normal items and used for specific styles for bordered items
	-->
	<xsl:template name="ending_container">
		<xsl:param name="row" />

		<xsl:variable name="width">
			<xsl:choose>
				<xsl:when test="contains($row/style, '1/2')"><xsl:value-of select="$width_12" /></xsl:when>
				<xsl:when test="contains($row/style, '1/3')"><xsl:value-of select="$width_13" /></xsl:when>
				<xsl:when test="contains($row/style, '2/3')"><xsl:value-of select="$width_23" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$width_full" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<th>
			<xsl:attribute name="style">width: <xsl:value-of select="$width" />px;
				<!-- JWDB June 2020: border color can be configured per item -->
				<xsl:if test="$border_width > 0 and $row/extra3 != '' and not(contains($row/extra3, 'NOBORDER'))">border-color: <xsl:value-of select="$row/extra3" />;</xsl:if>
			</xsl:attribute>

			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="contains($row/extra3, 'NOBORDER')">
						<xsl:choose>
							<xsl:when test="contains($row/style, 'banner')">ctEndingContBanNoBorder</xsl:when>
							<xsl:when test="contains($row/style, 'uitgelicht') or $row/extra1 !=''">ctEndingContFeatNoBorder</xsl:when>
							<xsl:otherwise>ctEndingContNoBorder</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="contains($row/style, 'banner')">ctEndingContBan</xsl:when>
							<xsl:when test="contains($row/style, 'uitgelicht') or $row/extra1 !=''">ctEndingContFeat</xsl:when>
							<xsl:otherwise>ctEndingCont</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
		</th>

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
		<xsl:param name="row" />

		<xsl:variable name="button-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="$row/extra1" />
				<xsl:with-param name="part"><xsl:choose><xsl:when test="$class = 'ctBut'">button</xsl:when><xsl:otherwise>button2</xsl:otherwise></xsl:choose></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="buttontext-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="$row/extra1" />
				<xsl:with-param name="part"><xsl:choose><xsl:when test="$class = 'ctBut'">buttontekst</xsl:when><xsl:otherwise>buttontekst2</xsl:otherwise></xsl:choose></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

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
						<xsl:if test="$button-color != ''">
							<xsl:attribute name="style">background-color: <xsl:value-of select="$button-color" /></xsl:attribute>
						</xsl:if>
						<table cellpadding="0" cellspacing="0" class="ctButTable">
							<xsl:if test="$hide = 1">
								<xsl:attribute name="style">display:none;width:0px;max-height:0px;overflow:hidden;mso-hide:all;height:0;font-size:0;max-height:0;line-height:0;margin:0 auto;</xsl:attribute>
							</xsl:if>
							<tr>
								<td class="ctButIconText">
									<a target="_blank">
										<xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
										<xsl:if test="$buttontext-color != ''">
											<xsl:attribute name="style">color: <xsl:value-of select="$buttontext-color" /> !important; color: <xsl:value-of select="$buttontext-color" /></xsl:attribute>
										</xsl:if>
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

					<xsl:variable name="title-color">
						<xsl:call-template name="color">
							<xsl:with-param name="colors" select="extra1" />
							<xsl:with-param name="part">titel</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="subtitle-color">
						<xsl:call-template name="color">
							<xsl:with-param name="colors" select="extra1" />
							<xsl:with-param name="part">sub</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="content-color">
						<xsl:call-template name="color">
							<xsl:with-param name="colors" select="extra1" />
							<xsl:with-param name="part">content</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="date-color">
						<xsl:call-template name="color">
							<xsl:with-param name="colors" select="extra1" />
							<xsl:with-param name="part">datum</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="buttontext-color">
						<xsl:call-template name="color">
							<xsl:with-param name="colors" select="extra1" />
							<xsl:with-param name="part">buttontekst</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
						<tr>
							<!-- trigger DATUMBLOK
							The date will be saved as 1 january 2000 when the date fields in the content block details are empty -->
							<xsl:if test="contains(style, 'datumblok') and not(contains(display_playdate_start, '1 januari 2000'))">
								<th class="agDateBlockCont">

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

								</th>
								<th class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</th>
							</xsl:if>

							<!-- trigger DATUM-PLAATJE-TEKST -->
							<xsl:if test="contains(style, 'datum-plaatje-tekst') and not(contains(display_playdate_start, '1 januari 2000'))">
								<th class="agDateTextCont">

									<table cellpadding="0" cellspacing="0" width="100%" style="width: 100%">
										<tr>
											<td class="agDateTextInnerCont">

												<xsl:if test="$date-color != ''">
													<xsl:attribute name="style">color: <xsl:value-of select="$date-color" /></xsl:attribute>
												</xsl:if>

												<xsl:call-template name="date_subtitle">
													<xsl:with-param name="row" select="." />
												</xsl:call-template>
											</td>
										</tr>
									</table>

								</th>
								<th class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</th>
							</xsl:if>

							<!-- This will be displayed when using normal agenda block style name and image is set -->
							<xsl:if test="not(contains(style, 'datumblok')) and image != ''">
								<th class="agImgOuterCont">
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
								</th>
								<th class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</th>
							</xsl:if>

							<!-- Content container -->
							<th class="agCtCont">

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

														<!-- ##JWDB 20 august 2020: title clickable when the url is filled -->
														<xsl:choose>
															<xsl:when test="url != ''">
																<a target="_blank" class="agTitleLink">
																	<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																	<h2>
																		<xsl:if test="$title-color != ''">
																			<xsl:attribute name="style">color: <xsl:value-of select="$title-color" /></xsl:attribute>
																		</xsl:if>
																		<xsl:value-of select="$title" disable-output-escaping="yes" />
																	</h2>
																</a>
															</xsl:when>
															<xsl:otherwise>
																<h2>
																	<xsl:if test="$title-color != ''">
																		<xsl:attribute name="style">color: <xsl:value-of select="$title-color" /></xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="$title" disable-output-escaping="yes" />
																</h2>
															</xsl:otherwise>
														</xsl:choose>
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

															<h4>
																<xsl:if test="$subtitle-color != ''">
																	<xsl:attribute name="style">color: <xsl:value-of select="$subtitle-color" /></xsl:attribute>
																</xsl:if>
																<xsl:value-of select="$subtitle" disable-output-escaping="yes" />
															</h4>
														</td>
													</tr>
												</xsl:if>

												<!-- Show same date text as ITEMS blocks when no DATUMBLOK and DATUM-PLAATJE-TEKST is triggered -->
												<xsl:if test="not(contains(style, 'datumblok')) and not(contains(style, 'datum-plaatje-tekst'))">
													<tr>
														<td class="agDate">
															<xsl:if test="$date-color != ''">
																<xsl:attribute name="style">color: <xsl:value-of select="$date-color" /></xsl:attribute>
															</xsl:if>

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
															<xsl:if test="$date-color != ''">
																<xsl:attribute name="style">color: <xsl:value-of select="$date-color" /></xsl:attribute>
															</xsl:if>

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
															<xsl:if test="$content-color != ''">
																<xsl:attribute name="style">color: <xsl:value-of select="$content-color" /></xsl:attribute>
															</xsl:if>

															<xsl:value-of select="content" disable-output-escaping="yes" />

															<!-- Show text based readmore button when using DATUM-PLAATJE-TEKST trigger -->
															<!-- ##JWDB Juli 2020: link button will always be used instead of a button -->
															<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON'))">
																<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
																<a target="_blank">
																	<xsl:if test="$buttontext-color != ''">
																		<xsl:attribute name="style">color: <xsl:value-of select="$buttontext-color" /> !important; color: <xsl:value-of select="$buttontext-color" /></xsl:attribute>
																	</xsl:if>
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

												<!-- ##JWDB Juli 2020: show text based readmore button when content is empty -->
												<xsl:if test="url != '' and not(contains(image_alt, 'NOBUTTON')) and content = ''">
													<tr>
														<td class="agContent">
															<a target="_blank">
																<xsl:if test="$buttontext-color != ''">
																	<xsl:attribute name="style">color: <xsl:value-of select="$buttontext-color" /> !important; color: <xsl:value-of select="$buttontext-color" /></xsl:attribute>
																</xsl:if>
																<xsl:attribute name="href"><xsl:value-of select="details_url" /></xsl:attribute>
																<xsl:choose>
																	<xsl:when test="image_alt != ''"><xsl:value-of select="image_alt" /></xsl:when>
																	<xsl:otherwise><xsl:value-of select="$button1_text" /></xsl:otherwise>
																</xsl:choose>
															</a>
														</td>
													</tr>
												</xsl:if>
											</table>
										</td>
									</tr>
								</table>
							</th>

							<!-- Button, hide when using DATUM-PLAATJE-TEKST trigger -->
							<!-- ##JWDB July 2020: button logic deleted, link button in content will be used -->
							<xsl:if test="1=0 and url != '' and not(contains(image_alt, 'NOBUTTON')) and not(contains(style, 'datum-plaatje-tekst'))">
								<th class="agColMargin">
									<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
								</th>
								<th class="agButCont">

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
													<xsl:with-param name="row" select="." />
												</xsl:call-template>
											</td>
										</tr>
									</table>

								</th>
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
	<!-- ##JWDB 24 July 2020: custom colors implemented -->
	<xsl:template name="titles">

		<xsl:param name="classPrefix">ct</xsl:param>

		<xsl:variable name="title-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="extra1" />
				<xsl:with-param name="part">titel</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="subtitle-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="extra1" />
				<xsl:with-param name="part">sub</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="date-color">
			<xsl:call-template name="color">
				<xsl:with-param name="colors" select="extra1" />
				<xsl:with-param name="part">datum</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<tr>
			<td>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="contains(style, 'titels boven') and not(contains(style, 'afb.'))"><xsl:value-of select="$classPrefix" />TitlesCont</xsl:when>
						<xsl:when test="contains(style, 'titels boven') and contains(style, 'afb.')"><xsl:value-of select="$classPrefix" />TitlesContAfbLr</xsl:when>
						<xsl:when test="content = ''"><xsl:value-of select="$classPrefix" />TitlesContNoContent</xsl:when>
						<xsl:otherwise><xsl:value-of select="$classPrefix" />TitlesContBelow</xsl:otherwise>
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
							<td>
								<xsl:attribute name="class"><xsl:value-of select="$classPrefix" />SubtAbove</xsl:attribute>

								<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
								<xsl:if test="contains(style, 'gecentreerd')">
									<xsl:attribute name="style">text-align: center;</xsl:attribute>
								</xsl:if>

								<xsl:variable name="subtitle">
									<xsl:call-template name="double_pipes">
										<xsl:with-param name="input" select="location" />
									</xsl:call-template>
								</xsl:variable>

								<h4>
									<xsl:if test="$subtitle-color != ''">
										<xsl:attribute name="style">color: <xsl:value-of select="$subtitle-color" /></xsl:attribute>
									</xsl:if>
									<xsl:value-of select="$subtitle" disable-output-escaping="yes" />
								</h4>
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
									<xsl:when test="location != '' and contains(style, 'ondertitel boven')"><xsl:value-of select="$classPrefix" />CaptBelow</xsl:when>
									<xsl:otherwise><xsl:value-of select="$classPrefix" />Capt</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>

							<xsl:variable name="title">
								<xsl:call-template name="double_pipes">
									<xsl:with-param name="input" select="title" />
								</xsl:call-template>
							</xsl:variable>

							<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
							<xsl:if test="contains(style, 'gecentreerd')">
								<xsl:attribute name="style">text-align: center;</xsl:attribute>
							</xsl:if>

							<xsl:variable name="heading">
								<xsl:choose>
									<!-- JWDB June 2020: all 1/, 2/ and afb. styles will get H3 as heading -->
									<xsl:when test="contains(style, '1/3') or contains(style, '2/3') or contains(style, '1/2') or contains(style, 'afb.')">
										<xsl:text disable-output-escaping="yes"><![CDATA[<h3]]></xsl:text>
										<xsl:if test="$title-color != ''">
											<xsl:text disable-output-escaping="yes"><![CDATA[ style="color: ]]></xsl:text><xsl:value-of select="$title-color" /><xsl:text disable-output-escaping="yes"><![CDATA["]]></xsl:text>
										</xsl:if>
										<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>

										<xsl:value-of select="$title" disable-output-escaping="yes" />
										<xsl:text disable-output-escaping="yes"><![CDATA[</h3>]]></xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text disable-output-escaping="yes"><![CDATA[<h2]]></xsl:text>
										<xsl:if test="$title-color != ''">
											<xsl:text disable-output-escaping="yes"><![CDATA[ style="color: ]]></xsl:text><xsl:value-of select="$title-color" /><xsl:text disable-output-escaping="yes"><![CDATA["]]></xsl:text>
										</xsl:if>
										<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
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
							<td>
								<xsl:attribute name="class"><xsl:value-of select="$classPrefix" />Subt</xsl:attribute>

								<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
								<xsl:if test="contains(style, 'gecentreerd')">
									<xsl:attribute name="style">text-align: center;</xsl:attribute>
								</xsl:if>

								<xsl:variable name="subtitle">
									<xsl:call-template name="double_pipes">
										<xsl:with-param name="input" select="location" />
									</xsl:call-template>
								</xsl:variable>

								<h4>
									<xsl:if test="$subtitle-color != ''">
										<xsl:attribute name="style">color: <xsl:value-of select="$subtitle-color" /></xsl:attribute>
									</xsl:if>
									<xsl:value-of select="$subtitle" disable-output-escaping="yes" />
								</h4>
							</td>
						</tr>
					</xsl:if>

					<!-- Date
                    When you empty the date fields in the content block details, then the dates will be saved as 1 january 2000.
                    Or you filled in the db.extra4 field.
                    Hide dates on banner blocks
                    -->
					<xsl:if test="(not(contains(display_playdate_start, '1 januari 2000')) or extra4 != '') and not(contains(style, 'banner'))">
						<tr>
							<td>
								<xsl:attribute name="class"><xsl:value-of select="$classPrefix" />Date</xsl:attribute>

								<!-- JWDB June 2020: set all texts to center when style contains trigger word gecentreerd -->
								<xsl:choose>
									<xsl:when test="contains(style, 'gecentreerd') and $date-color != ''">
										<xsl:attribute name="style">text-align: center; color: <xsl:value-of select="$date-color" /></xsl:attribute>
									</xsl:when>
									<xsl:when test="contains(style, 'gecentreerd')">
										<xsl:attribute name="style">text-align: center;</xsl:attribute>
									</xsl:when>
									<xsl:when test="$date-color != ''">
										<xsl:attribute name="style">color: <xsl:value-of select="$date-color" /></xsl:attribute>
									</xsl:when>
								</xsl:choose>

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

	<!-- ##JWDB 24 July 2020: get color from extra2 field -->
	<xsl:template name="color">
		<xsl:param name="colors" />
		<xsl:param name="part" />

		<xsl:variable name="search"><![CDATA[ ]]><xsl:value-of select="$part" />:</xsl:variable>

		<xsl:choose>
			<xsl:when test="contains($colors, $search)">
				<xsl:variable name="color_part" select="normalize-space(substring-after($colors, $search))" />
				<xsl:choose>
					<xsl:when test="contains($color_part, ' ')">
						<xsl:value-of select="substring-before($color_part, ' ')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$color_part" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$part = 'achtergrond' and $colors != '' and not(contains($colors, ' ')) and not(contains($colors, ':'))">
				<xsl:value-of select="$colors" />
			</xsl:when>
			<xsl:when test="$part = 'achtergrond' and $colors != '' and contains($colors, ' ')">
				<xsl:variable name="subpart" select="substring-before($colors, ' ')" />
				<xsl:if test="not(contains($subpart, ':'))">
					<xsl:value-of select="$subpart" />
				</xsl:if>
			</xsl:when>
		</xsl:choose>


	</xsl:template>

	<!-- That's all folks !!
	kind regards from the DeBoer Cousins
	-->

</xsl:stylesheet>