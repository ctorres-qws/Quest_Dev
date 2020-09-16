<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
		<!--#include file="dbpath.asp"-->
<!-- Created May 5th, by Michael Bernholtz at Request of Valdi and Ben -->
<!-- Stock by Colour  for Sheets list -->
<!-- Drills to StockbycolorSheet -->
<!-- February 2019 - Add USA VIEW -->


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Sheet By Color</title>
  <meta name="viewport" content="width=devicewidth, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
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
        <h1 id="pageTitle">Sheet by Color</h1>
		<% 
		if CountryLocation = "USA" then 
			HomeSite = "indexTexas.html"
			HomeSiteSuffix = "-USA"
		else
			HomeSite = "index.html"
			HomeSiteSuffix = ""
		end if 
		%>
                <a class="button leftButton" type="cancel" href="<%response.write Homesite%>#_Inv" target="_self">Inventory<%response.write HomeSiteSuffix%></a>
    </div>
        <ul id="Profiles" title="Profiles" selected="true">
        <li class='group'>Sheet Colours</li>

<%
	
Set rs = Server.CreateObject("adodb.recordset")

if CountryLocation = "USA" then
	strSQL = FixSQL("SELECT * FROM Y_INV WHERE (Width > 0 OR Height > 0) AND WAREHOUSE = 'JUPITER' ORDER BY Colour ASC")
else
	strSQL = FixSQL("SELECT * FROM Y_INV WHERE (Width > 0 OR Height > 0) AND WAREHOUSE = 'NASHUA' or WAREHOUSE = 'DURAPAINT(WIP)' ORDER BY Colour ASC")
end if

rs.Cursortype = GetDBCursorType
rs.Locktype = GetDBLockType
rs.Open strSQL, DBConnection

Do While Not rs.eof
	colour = rs("Colour")
	If colour2 = colour Then
'
	Else
%>
<li><a href="stockbycolorSheet.asp?colour=<%response.write colour%>" target="_self"><%response.write colour %></a></li>
<%
	End If
	colour2 = colour
	rs.movenext
Loop

rs.close
set rs=nothing

DBConnection.close
set DBConnection=nothing

%>
<li>//END//</li>
/
      </ul>

</body>
</html>
