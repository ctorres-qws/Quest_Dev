<!--#include file="dbpath.asp"-->
                       
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Quest Dashboard</title>
  <meta name="viewport" content="width=devicewidth; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
  <link rel="apple-touch-icon" href="/iui/iui-logo-touch-icon.png" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <script src="sorttable.js"></script>
  <link rel="stylesheet" href="/iui/iui.css" type="text/css" />
  <link rel="stylesheet" title="Default" href="/iui/t/default/default-theme.css"  type="text/css"/>
  <script type="application/x-javascript" src="/iui/iui.js"></script>
  <script type="text/javascript">
    iui.animOn = true;
  
  
  
  </script>
  
  <script>
function startTime()
{
var today=new Date();
var h=today.getHours();
var m=today.getMinutes();
var s=today.getSeconds();
// add a zero in front of numbers<10
m=checkTime(m);
s=checkTime(s);
document.getElementById('clock').innerHTML=h+":"+m+":"+s;
t=setTimeout(function(){startTime()},500);
}

function checkTime(i)
{
if (i<10)
  {
  i="0" + i;
  }
return i;
}
</script>


<% 
Set rs = Server.CreateObject("adodb.recordset")
strSQL = "SELECT * FROM Y_COLOR_SPANDREL ORDER BY CODE ASC"
rs.Cursortype = 2
rs.Locktype = 3
rs.Open strSQL, DBConnection



%>
	</head>
<body onload="startTime()" >

    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
                <a class="button leftButton" type="cancel" href="index.html#_Inv" target="_self">Inventory</a>
        <a class="button" href="#searchForm" id="clock"></a>
    </div>

<ul id="screen1" title="View All Spandrel Colors" selected="true">

   
    <%


response.write "<li class='group'>All Project/Colour Information </li>"
response.write "<li> Click on the Headers of each column to sort Ascending/Descending</li>  "
response.write "<li><table border='1' class='sortable'><tr><th>Code</th><th>Description</th><th>Job</th><th>Notes</th><th>Active</th></tr>"
do while not rs.eof
response.write "<tr>"

response.write "<td>" &  rs.fields("Code") & "</td>"
response.write "<td>" &  rs.fields("Description") & "</td>"
response.write "<td>" &  rs.fields("Job") & "</td>"
response.write "<td>" &  rs.fields("Notes") & "</td>"
response.write "<td>" &  rs.fields("Active") & "</td>"
response.write "</tr>"

rs.movenext
loop

RESPONSE.WRITE "</UL>"


rs.close
set rs=nothing
DBConnection.close
set DBConnection=nothing
%>

</body>
</html>

