<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--Page Created August 21st, 2014 - by Michael Bernholtz --> 
<!--Remove Items Confirmation page - from GlassReportCompleted.asp Requested by Sasha and Eric Bedeov-->
		 <!--#include file="dbpath.asp"-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Glass Edited </title>
  <meta name="viewport" content="width=devicewidth; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
  <link rel="apple-touch-icon" href="/iui/iui-logo-touch-icon.png" />
  <meta name="apple-mobile-web-app-capable" content="yes" />

  <link rel="stylesheet" href="/iui/iui.css" type="text/css" />

  <link rel="stylesheet" title="Default" href="/iui/t/default/default-theme.css"  type="text/css"/>
  <script type="application/x-javascript" src="/iui/iui.js"></script>
  <script type="text/javascript">
    iui.animOn = true;
  </script>
	</head>
<body >

    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
		<%
		ticket = request.querystring("ticket")
	Select Case ticket
	Case "Completed"
		ReturnSite = "GlassReportCompleted.asp"
		%>
		<a class="button leftButton" type="cancel" href="GlassReportCompleted.asp" target="_self">Completed</a>
		<%
	Case "Commercial"
		ReturnSite = "GlassReportCommercial.asp"
		%>
		<a class="button leftButton" type="cancel" href="GlassReportCommercial.asp" target="_self">Commercial</a>
		<%
	Case "Service"
		ReturnSite = "GlassReportService.asp"
		%>
		<a class="button leftButton" type="cancel" href="GlassReportService.asp" target="_self">Service</a>
		<%
	Case Else
		ReturnSite = "GlassReportCompleted.asp"
		%>
		<a class="button leftButton" type="cancel" href="GlassReportCompleted.asp" target="_self">Complete</a>
		<%
	End Select
	%>

    </div>

<form id="conf" title="Glass Edited" class="panel" name="conf" action= "<%Response.write ReturnSite%>" method="GET" target="_self" selected="true" >              

        <h2>Glass Removed</h2>

<%
	GIDList = ""

	Select Case(gi_Mode)
		Case c_MODE_ACCESS
			Process(false)
		Case c_MODE_HYBRID
			Process(false)
			Process(true)
		Case c_MODE_SQL_SERVER
			Process(true)
	End Select


Function Process(isSQLServer)

	DBOpen DBConnection, isSQLServer

	For Each item in Request.QueryString("GID")
		GID = item
		If Instr(1, GIDList, GID) < 1 Then GIDList = GIDList & GID & ", "

		'Set Glass Inventory Update Statement
		StrSQL = "UPDATE Z_GLASSDB  SET [HIDE]= 'COMPLETED', [SHIPDATE] = '" & MONTH(DATE) & "/" & DAY(DATE) & "/" &YEAR(DATE) & "'  WHERE ID = " & GID
		Set RS = DBConnection.Execute(strSQL)
	Next

	DbCloseAll

End Function

%>

<ul id="Report" title="Added" selected="true">

<%

		Response.Write "<li>Items Marked Complete and Hidden from Future lists:</li>"
		Response.Write "<li> Notes Added to : " & GIDList & "</li>"

%>

        <BR>

         <a class="whiteButton" href="javascript:conf.submit()">Back to <%Response.write ticket%> Items Select</a>

            </form>

<% 
'DBConnection.close
'set DBConnection=nothing
%>

</body>
</html>
