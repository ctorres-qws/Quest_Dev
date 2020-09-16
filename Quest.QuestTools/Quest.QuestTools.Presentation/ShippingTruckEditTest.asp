<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath.asp"-->
<!-- Created April 2014, by Michael Bernholtz - Edit List to Manage ALL trucks on the X_SHIPPING_Truck table-->
<!-- X_SHIPPING_LIBRARY, X_SHIPPING_TRUCK, and X_Shipping Tables created at Request of Jody Cash, Implemented by Michael Bernholtz-->  
<!-- Truck Maintainance allows Changing Docks, but must confirm Dock is open -->
<!-- Allows Truck details (not Number) to be edited - Dock, Job, Floor, Name
<!-- Inputs to ShippingTruckEditForm.asp-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Manage Truck</title>
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
		Set rs = Server.CreateObject("adodb.recordset")
		strSQL = "Select * FROM X_Shipping_truck_test ORDER BY ID ASC "
		rs.Cursortype = GetDBCursorType
		rs.Locktype = GetDBLockType
		rs.Open strSQL, DBConnection
%>
    </head>
<body>
    <div class="toolbar">
        <h1 id="pageTitle">Manage Truck</h1>
        <a class="button leftButton" type="cancel" href="ShippingHomeTest.HTML" target="_self">Scan</a>
    </div>
	<ul id='ShippingLibrary' title=' Select Truck to Edit' selected='true'>
	<li><table border='1' class='sortable'><tr><th>Manage</th><th>Truck Name</th><th>Job</th><th>Floor</th><th>Truck #</th><th>Active</th><th>Dock/Ship Date</th></tr>
<%
		do while not rs.eof

				Response.write "<tr>"
				Response.write "<td><a class='whiteButton' target='_self' href='ShippingTruckEditFormTest.asp?tid=" & trim(rs("id")) & "'>Manage</a></td>"

				Response.write "<td>" & trim(RS("truckName")) & "</td>"
				Response.write "<td>" & trim(RS("job")) & "</td>"
				Response.write "<td>" & trim(RS("floor")) & "</td>"
				Response.write "<td>" & trim(RS("truckNum")) & "</td>"
				
				if RS("active") = True then
					Response.write "<td>Active</td>"
					Response.write "<td>" & trim(RS("dockNum")) & "</td>"
				else
					Response.write "<td> Closed/Shipped </td>"
					Response.write "<td>" & trim(RS("shipDate")) & "</td>"
					
				end if
				
				
			
				Response.write "</tr>"
				
		rs.movenext
		loop
		response.write "</table></li>"
		rs.close
		set rs = nothing
		DBConnection.close
		Set DBConnection = Nothing

%>
  </ul>
</body>
</html>
