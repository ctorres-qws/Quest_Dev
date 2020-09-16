<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath.asp"-->
<!-- Created at Request of Socol, in the rare event a truck is closed and then called back  -->
<!-- Created April 2014, by Michael Bernholtz - ReOpen a Closed truck-->
<!-- Dropdown of Shipped Trucks to select  -->
<!-- Shows Close Data and Truck Manifest for truck to re-open-->
<!-- Confirms to ShippingTruckReopenConf.asp-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Re-Open Truck</title>
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

   
<%

truck = trim(Request.Querystring("truck"))

%>

</head>

<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a class="button leftButton" type="cancel" href="ShippingHome.HTML" target="_self">Scan</a>
        </div>
   
   <!--New Form to collect the Job and Floor fields-->
    <form id="ReOpenTruck" title="Re-Open Truck" class="panel" name="ReOpenTruck" action="ShippingTruckReopenConf.asp" method="GET" selected="true">
        
        <h2>Select Active Truck for Closing</h2>
       <fieldset>

        <div class="row">
            <label>Truck</label>
            <select name="truck" id="truck">
<%

	'All Trucks (Active and Inactive)
	Set rs = Server.CreateObject("adodb.recordset")
	strSQL = "SELECT * FROM X_Shipping_Truck  ORDER BY dockNum ASC"
	rs.Cursortype = 2
	rs.Locktype = 3
	rs.Open strSQL, DBConnection

if truck <> "" and truck <> "0" then
	rs.filter = "ID = " & truck
	if rs("truckName") <> "" then
		activeTruck = rs("truckName") & " - "
	end if
	activeTruck = activeTruck & rs("Job") & rs("Floor") & "-" & rs("truckNum")
	response.write " <option value = '" & rs("id") & "'>" & activeTruck & "</option>"
else
	response.write " <option value = ''>Choose a Truck</option>"
end if

rs.filter = ""
rs.filter = "Active = FALSE"
rs.movefirst
do while not rs.eof
	Response.Write "<option value = '"
	Response.Write rs("id")
	Response.Write "'>"
	if rs("truckName") <> "" then
		Response.write rs("truckName") & " - "
	end if
	Response.Write rs("Job") & rs("Floor") & "-" & rs("truckNum")
	rs.movenext
loop

	' Determine the Active Docks, so Re-Opened Truck does not conflict	
		rs.filter = "active = TRUE"
		' Note for Adding Dock, to not add where another truck already is sitting
		if rs.eof then
			Docklimit = "All Docks Available"
		else
			rs.movefirst
			Docklimit = trim(rs("dockNum"))
			rs.movenext
			do while not rs.eof
				Docklimit = Docklimit & ", " & trim(rs("dockNum"))
				rs.movenext
			loop
		end if
		rs.filter = ""

%>
</select>
	
	    </div>
		
		</fieldset>
			 <h2>The following docks are Unavailable: <b><% Response.Write Docklimit %></b></h2>
		<fieldset>
			<div class="row" >
				<label>Dock #</label>
				<input type="number" name='dockNum' id='dockNum' >
			</div>	
				
        </fieldset>
        <BR>
			<a class="redButton" onClick="ReOpenTruck.action='ShippingTruckReOpenConf.asp'; ReOpenTruck.submit()">Re-Open Truck</a><BR>
		   </form>
<%
rs.close
set rs = nothing
DBConnection.close
set DBConnection = nothing
%>
</body>
</html>