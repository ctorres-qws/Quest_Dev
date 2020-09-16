<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath.asp"-->
<!-- Created April 2014, by Michael Bernholtz - Set a New Truck to Active-->
<!-- Entry page for ShippingTruckCompare.asp report -->
<!-- Collects information for Scanning of Jobs not listed in Truck name-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Compare Scanned Windows to DB</title>
  <meta name="viewport" content="width=devicewidth; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
  <link rel="apple-touch-icon" href="/iui/iui-logo-touch-icon.png" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <link rel="stylesheet" href="/iui/iui.css" type="text/css" />

  <link rel="stylesheet" title="Default" href="/iui/t/default/default-theme.css"  type="text/css"/>
  <script type="application/x-javascript" src="/iui/iui.js"></script>
  <script src="sorttable.js"></script>
  <script type="text/javascript">
    iui.animOn = true;
  </script>
   

</head>

<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a class="button leftButton" type="cancel" href="Index.Html#_Report" target="_self">Report</a>
        </div>
   
   <!--New Form to collect the Job and Floor fields-->
    <form id="AddTruck" title="Add Truck" class="panel" name="AddTruck" action="ShippingTruckCompare.asp" method="GET" selected="true">
        
        <h2>Input Job and Floor of the New Truck </h2>
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
                <input type="text" name='floor' id='floor' >
        </div>
		</fieldset>
	
		<a class="whiteButton" onClick="AddTruck.submit()">Submit</a><BR>
            </form>
		

<%

DBConnection.close
set DBConnection = nothing
%>	

</body>
</html>