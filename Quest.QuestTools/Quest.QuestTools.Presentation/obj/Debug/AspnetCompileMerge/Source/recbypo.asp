<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath.asp"-->

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
    
    <%
	
Set rs = Server.CreateObject("adodb.recordset")
strSQL = "SELECT * FROM Y_INV ORDER BY WAREHOUSE, PART"
rs.Cursortype = 2
rs.Locktype = 3
rs.Open strSQL, DBConnection



%>
 
    </head>
<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a class="button leftButton" type="cancel" href="index.html#_Inv" target="_self">Stock</a>
        </div>
   
   
         
       
        <ul id="Profiles" title="Profiles" selected="true">
        
        
<% 

bc = request.QueryString("bc")

rs.filter = "WAREHOUSE<>'GOREWAY'"
rs.filter = "PO='" & bc & "'"

response.write "<li class='group'>SAPA PENDING</li>"

do while not rs.eof
part = rs("part")
qty = rs("qty")
id = rs("ID")
shelf = rs("shelf")
colour = rs("colour")
		

%>

<li><a href="stockbyrackedit.asp?id=<% response.write id %>" target="_self"> <%response.write part & ", " & qty & " SL" & ", " & Colour  %></a></li>
<%

aisle = rs("aisle")
rack = rs("Rack")
rs.movenext
loop

rs.filter = "WAREHOUSE='DURAPAINT'"

response.write "<li class='group'>DURAPAINT PENDING</li>"

do while not rs.eof
part = rs("part")
qty = rs("qty")
id = rs("ID")
shelf = rs("shelf")
colour = rs("colour")
		

%>
<li><a href="stockbyrackedit.asp?id=<% response.write id %>" target="_self"> <%response.write part & ", " & qty & " SL" & ", " & Colour %></a></li>
<%

aisle = rs("aisle")
rack = rs("Rack")
rs.movenext
loop

rs.filter = "WAREHOUSE='EXTAL SEA'"

response.write "<li class='group'>EXTAL SEA PENDING</li>"

do while not rs.eof
part = rs("part")
qty = rs("qty")
id = rs("ID")
shelf = rs("shelf")
colour = rs("colour")
		

%>
<li><a href="stockbyrackedit.asp?id=<% response.write id %>" target="_self"> <%response.write part & ", " & qty & " SL"  & ", " & Colour %></a></li>
<%

aisle = rs("aisle")
rack = rs("Rack")
rs.movenext
loop

rs.close
set rs = nothing
DBConnection.close
Set DBConnection = nothing

%>
      </ul>                      
</body>
</html>
