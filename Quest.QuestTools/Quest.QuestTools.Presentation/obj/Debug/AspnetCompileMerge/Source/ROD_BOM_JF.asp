<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath.asp"-->
<!-- Bill of Material Summary Page by Job and Floor-->
<!-- Sends Job and Floor to ROD_BOM_REPORT.asp and uses ROD_BOM_FINDER.asp in 172.18.13.31\quest to determine totals-->
<!-- Created September 27th, by Michael Bernholtz - For Jody Cash and Daniel Zalcman-->
<!-- Report to be used by Kirk Campbell and Carlos to get correct Hardware -->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>iUI Theaters</title>
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
<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a class="button leftButton" type="cancel" href="index.html#_Report" target="_self">Reports</a>
        </div>

		<form id="colour" title="Edit Details" class="panel" name="Colour" action="ROD_BOM_REPORT.asp" method="GET" target="_self" selected="true">
        <h2>Select Job Floor</h2>
		<fieldset>
			<div class="row">
				<label>JOB</Label>
				<select name="Job">
<%

Set rs = Server.CreateObject("adodb.recordset")
strSQL = "SELECT JOB FROM Z_JOBS ORDER BY JOB ASC"
rs.Cursortype = 2
rs.Locktype = 3
rs.Open strSQL, DBConnection

rs.movefirst
Do While Not rs.eof

Response.Write "<option value='"
Response.Write rs("JOB")
Response.Write "'>"
Response.Write rs("JOB")
Response.write "</option>"

rs.movenext

loop
rs.close
set rs=nothing
%></select>
            </div>
			<div class="row">
                <label>Floor</label>
                <input type="text" name='Floor' id='Floor' >
            </div>
	
			
			</fieldset>
        <BR>
        <a class="whiteButton" href="javascript:colour.submit()">Submit</a>
            
            
            
            </form>			 

   <%
DBConnection.close
set DBConnection = nothing
%>            
</body>
</html>
