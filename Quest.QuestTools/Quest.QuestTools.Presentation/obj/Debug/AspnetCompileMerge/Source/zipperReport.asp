<!--#include file="dbpath.asp"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- Zipper Reporting - Shows the Items cut based on Profile - Total, This Month, Today -->
<!-- Zipper Blue, Michael Bernholtz, August 2014 -->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Zipper Stats</title>
  <meta name="viewport" content="width=devicewidth; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
  <link rel="apple-touch-icon" href="/iui/iui-logo-touch-icon.png" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <!-- Request from Jody Cash on January 9th 2014 to change the Auto Refresh from 1200 to 90 -->
  <meta http-equiv="refresh" content="90" >
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

<!--#include file="todayandyesterday.asp"-->

</head>
<body onload="startTime()" >

    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
<% 
			Ticket = Request.QueryString("Ticket") 
			If Ticket = "BarcoderTV" then
			BackButton = "BarcoderTV.asp"
			Else
			BackButton = "index.html#_Report"
			End if
%>
                <a class="button leftButton" type="cancel" href="<%Response.Write BackButton %>" target="_self">Reports</a>
        <a class="button" href="#searchForm" id="clock"></a>
    </div>

<ul id="screen1" title="Zipper Stats" selected="true">

		<li class="group">Zipper Machines</li>
		<li class='group'>Today</li>
<%
i =0
TableName = "ProZipperBlue"
Do Until i = 2
Set rs = Server.CreateObject("adodb.recordset")
strSQL = "Select * FROM [" & TableName & "] WHERE DAY = " & cDay & " AND Month = " & cMonth & " AND YEAR = " & cYear & " ORDER BY PROFILEID ASC, JOB ASC, ID ASC "
rs.Cursortype = GetDBCursorType
rs.Locktype = GetDBLockType
rs.Open strSQL, DBConnection

'rs.filter = "DAY = " & cDay & " AND Month = " & cMonth & " AND YEAR = " & cYear		
if rs.eof then
	response.write "<li>" & TableName & " currently has no items of Activity</li>"
else
	response.write "<li class='group'>" & TableName & " Activity:</li>"
Profile1 =  rs("ProfileID")
Profile2 = "0"
Job1 =  rs("Job")
Job2 = "0"
ProfileCount = 0
JobCount = 0
Do while not rs.eof
	Profile2 = Profile1
	Profile1 = rs("ProfileID")
	Job2 = Job1
	Job1 = rs("Job")
	if Profile1 = Profile2 then
		if Job2 = Job1 then
			JobCount = JobCount + 1
		else
			response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
			JobCount = 1
		end if
		
		ProfileCount = ProfileCount + 1
	else 
		response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
		response.write "<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total: " & UCASE(Profile2) & ": " & ProfileCount & "</li>"
		ProfileCount = 1
		JobCount = 1
	end if
rs.movenext
loop
response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
response.write "<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total: " & UCASE(Profile1) & ": " & ProfileCount & "</li>"

end if
TableName = "ProZipperRed"

rs.close
set rs = nothing
i = i+1
loop

i =0
TableName = "ProZipperBlue"
Do Until i = 2
Set rs = Server.CreateObject("adodb.recordset")
strSQL = "Select * FROM [" & TableName & "] WHERE Month = " & cMonth & " AND YEAR = " & cYear & " ORDER BY PROFILEID ASC, JOB ASC, ID ASC "
rs.Cursortype = GetDBCursorType
rs.Locktype = GetDBLockType
rs.Open strSQL, DBConnection

'rs.filter = " Month = " & cMonth & " AND YEAR = " & cYear
if rs.eof then
else
Profile1 =  rs("ProfileID")
Profile2 = "0"
ProfileCount = 0
Job1 =  rs("Job")
Job2 = "0"
JobCount = 0
Response.write "<li class='group'> " & TableName & " This Month</li>"	
Do while not rs.eof
	Profile2 = Profile1
	Profile1 = rs("ProfileID")
	Job2 = Job1
	Job1 = rs("Job")
	if Profile1 = Profile2 then
		if Job2 = Job1 then
			JobCount = JobCount + 1
		else
			response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
			JobCount = 1
		end if
		
		ProfileCount = ProfileCount + 1
	else 
		response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
		response.write "<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total: " & UCASE(Profile2) & ": " & ProfileCount & "</li>"
		ProfileCount = 1
		JobCount = 1

	end if
rs.movenext
loop
response.write "<li>" & UCASE(Profile2) & " - "& UCASE(Job2) & ": " & JobCount & "</li>"
response.write "<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total: " & UCASE(Profile1) & ": " & ProfileCount & "</li>"

end if
TableName = "ProZipperRed"

rs.close
set rs = nothing
i = i+1
loop

%>

	</ul>
        
  
<% 
On Error Resume Next
rs.close
set rs=nothing
rs2.CLOSE
Set rs2= nothing
DBConnection.close
set DBConnection=nothing

%>


</body>
</html>