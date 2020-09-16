<!--#include file="dbpath.asp"-->
                       
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
            <!--#include file="connect_barcodeqc.asp"-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Quest Dashboard</title>
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

'Create a Query
  '  SQL = "Select * FROM X_BARCODE ORDER BY DATETIME DESC"
'Get a Record Set
 '   Set RS = DBConnection.Execute(SQL)
	
	
Set rs2 = Server.CreateObject("adodb.recordset")
strSQL = "SELECT * From X_Barcode_Lineitem ORDER by JOB, Floor"
rs2.Cursortype = 2
rs2.Locktype = 3
rs2.Open strSQL, DBConnection

Set rs4 = Server.CreateObject("adodb.recordset")
strSQL4 = "SELECT * From X_WIN_PROD"
rs4.Cursortype = 2
rs4.Locktype = 3
rs4.Open strSQL4, DBConnection

'Set rs5 = Server.CreateObject("adodb.recordset")
'strSQL5 = "SELECT * From X_EMPLOYEES"
'rs5.Cursortype = 2
'rs5.Locktype = 3
'rs5.Open strSQL5, DBConnection

'Set rs6 = Server.CreateObject("adodb.recordset")
'strSQL6 = "SELECT * From X_BARCODEGA ORDER BY DATETIME DESC"
'rs6.Cursortype = 2
'rs6.Locktype = 3
'rs6.Open strSQL6, DBConnection

Set rs7 = Server.CreateObject("adodb.recordset")
strSQL7 = "SELECT * From Z_RATES ORDER BY ID DESC"
rs7.Cursortype = 2
rs7.Locktype = 3
rs7.Open strSQL7, DBConnection


totalg = 0
totalg2 = 0
totalg2y = 0
totalgy = 0
totalay = 0
totala = 0
totalc = 0
totalsu = 0
totalsp = 0
%>
<!--#include file="todayandyesterday.asp"-->
<%

sixweeks = weekNumber - 6


%>
</head>

<body>

    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
                <a class="button leftButton" type="cancel" href="index.html#_Report" target="_webapp">Reports</a>
        <a class="button" href="#searchForm" id="clock"></a>
    </div>

<ul id="screen1" title="Quest Dashboard" selected="true">


	              <li class="group">This Month's Revenue</li>
        
<%

wcount=0
JFCHECKID=0
	
	RS2.MOVEFIRST
	rs2.filter = "MONTH = " & cMonth & " AND YEAR = " & cYear & " AND DEPT = 'GLAZING'"
	'rs2.sort = "Job, Dept"
	do while not rs2.eof
	
	rs4.filter = "Job = '" &  rs2("Job") & "' AND Floor = '" &  rs2("Floor") & "'"
	if rs4.bof then
	else
		if rs7.bof then
			rs7.filter = "JOB = '" & rs2("Job") & "'"
		rate = rs7("Rate")
		else
		rate = 30
		end if
	fraction = (rs2("Tag") / rs4("TotalWin"))
	calcsqft = (rs4("TotalSqft")*fraction)*rate
		response.write "<li>" & " " & rs2("Job") & " " & rs2("Floor") & " " & rs2("Tag") & "/" & rs4("TotalWin") & " $" & round(calcsqft,2) & "</li>"
	cmsqft = cmsqft + calcsqft
	end if
	rs2.movenext
	
	loop
	
	
	RESPONSE.WRITE "<li class='group'>Current Month Revenue Total</li>"
	RESPONSE.WRITE "<li>$" & round(cmsqft,2) & "</li>"
	RESPONSE.WRITE "<li class='group'>Last Month's Revenue</li>"
	
	RS2.MOVEFIRST
	rs2.filter = "MONTH = " & cMonth & " AND YEAR = " & cYear & " AND DEPT = 'GLAZING'"
	'rs2.sort = "Job, Dept"
	do while not rs2.eof
	
	rs4.filter = "Job = '" &  rs2("Job") & "' AND Floor = '" &  rs2("Floor") & "'"
	if rs4.bof then
	else
		if rs7.bof then
			rs7.filter = "JOB = '" & rs2("Job") & "'"
		rate = rs7("Rate")
		else
		rate = 32
		end if
	fraction = (rs2("Tag") / rs4("TotalWin"))
	if fraction < 0.1 then
	fraction = 0
	end if
	calcsqft = (rs4("TotalSqft")*fraction)*rate
		response.write "<li>" & rs2("Job") & " " & rs2("Floor") & " " & rs2("Tag") & "/" & rs4("TotalWin") & " $" & round(calcsqft,2) & "</li>"
	cmsqft2 = cmsqft2 + calcsqft
	end if
	rs2.movenext
	
	loop
	
	
	RESPONSE.WRITE "<li class='group'>Last Month Revenue Total</li>"
	RESPONSE.WRITE "<li>$" & round(cmsqft2,2) & "</li>"
	
	%> 
 

        </ul>
        
        
      
<% 

'rs.close
'set rs=nothing
rs2.close
set rs2=nothing
'rs3.close
'set rs3=nothing
rs4.close
set rs4=nothing
'rs5.close
'set rs5=nothing
'rs6.close
'set rs6=nothing
rs7.close
set rs7 = nothing
DBConnection.close
set DBConnection=nothing
%>




</body>
</html>



