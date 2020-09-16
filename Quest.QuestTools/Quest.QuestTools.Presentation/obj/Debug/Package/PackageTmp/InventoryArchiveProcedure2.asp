<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="dbpath_Quest_ArchiveLists.asp"-->
		 
<!-- Stored Procedure to be run on the first of each month-->
<!-- Removes all the old CUT, HCUT, DMSAW Tables by matching 2 month old data from Stored Procedure-->
<!-- Updated August 2014, To mark Cutlists inactive from Z_Cutlists -->


<!--Input form to take snapshot of Y_Inv and add to another ACCESS DATABASE using new DBPATH in next page-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Archive Program</title>
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
 
Server.ScriptTimeout=300
 TableCount = 0
 
currentDate = Date()

currentMonth = Month(Now)
currentYear = Year(Now)

	' Set 2 Months Ago by Subtracting Two Months
TwoAgoMonth = Month(DateAdd("m",-2,Now))
TwoAgoYear = Year(DateAdd("m",-2,Now))

 
 
Set rs = Server.CreateObject("adodb.recordset")
strSQL = "Select JOB, FLOOR from X_BARCODE_LINEITEM WHERE MONTH = " & TwoAgoMonth & "AND YEAR = " & TwoAgoYear 

rs.Open strSQL, DBConnection

' WITH CYCLES

cycle = "c1"
i = 1
do until i>3
	rs.movefirst
	Select Case i
		Case 1
			Prefix = "Cut_"
			Copied = "Copied Tables from: Cut, "
		Case 2
			Prefix = "HCut_"
			Copied = Copied & "HCut, "
		Case 3
			Prefix = "STOP_"
			Copied = Copied & "Stop, "
		Case 4
			response.write "TOO MANY"
	End Select

	do while not rs.eof
	
		TableName = Prefix & RecordJob & RecordFloor & cycle 

		Set rs2 = Server.CreateObject("adodb.recordset")

			strSQL2 = "Select * into [MS Access;DATABASE=f:\database\ArchiveLists.mdb]." & TableName &  " FROM [MS Access;DATABASE=f:\database\quest.mdb]." & TableName
				On Error Resume Next  
					rs2.Open strSQL2, DBConnection2
				On Error GoTo 0
				
			
				SQL3 = "Drop TABLE " & TableName 
					On Error Resume Next  
				Set RS3 = DBConnection.Execute(SQL3)
				if Err.Number = 0 then
					Response.write TableName
				end if 
				
				
				
					On Error GoTo 0
			

			
				SQL4 = "UPDATE Z_Cutlists SET ACTIVE = FALSE WHERE CUTLIST = '" &TableName &  "'"
				On Error Resume Next  
					RS4 = DBConnection.Execute(SQL4)
				On Error GoTo 0
			

			If rs2.State = 1 Then 
				TableCount = TableCount + 1
				rs2.Close
				set rs2 = nothing
			End If
			
		Select Case cycle
			Case "c1"
				cycle = "c2"
			Case "c2"
				cycle = "c3"
			Case "c3"
				cycle = "c4"
			Case "c4"
				cycle = "c5"
			Case "c5"
				cycle = "c6"
			Case "c6"
				cycle = "c7"
			Case "c7"
				cycle = "c8"
			Case "c8"
				cycle = "c1"
				rs.movenext	
		End Select

	loop

i = i+1
loop
 
 
 ' WITHOUT CYCLES
 
i =1
do until i>11
	rs.movefirst
	Select Case i
		Case 1
			Prefix = "PANEL_"
			Suffix = ""
			Copied = Copied & "Panel, "
		Case 2
			Prefix = "SHIP_"
			Suffix = ""
			Copied = Copied & "Ship, "
		Case 3
			Prefix = "QSU_"
			Suffix = ""
			Copied = Copied & "QSU, "
		Case 4
			Prefix = "QSP_"
			Suffix = ""
			Copied = Copied & "QSP, "
		Case 5
			Prefix = "DMSAW_"
			Suffix = ""
			Copied = Copied & "Dmsaw, "
		Case 6
			Prefix = "DMSDR_"
			Suffix = ""
			Copied = Copied & "Dmsdr, "
		Case 7
			Prefix = "SCRN_"
			Suffix = ""
			Copied = Copied & "SCRN, "
		Case 8
			Prefix = "SCRNPROD_"
			Suffix = ""
			Copied = Copied & "SCRNPROD, "
		Case 9
			Prefix = "STOP_"
			Suffix = "_AWN"
			Copied = Copied & "Stop_AWN, "
		Case 10
			Prefix = "R3PANEL_"
			Suffix = ""
			Copied = Copied & "R3Panel, "
		Case 11
			Prefix = "SHIFT_"
			Suffix = ""
			Copied = Copied & "Shift. "
			
	End Select
	rs.movefirst
	do while not rs.eof
		RecordJob = rs("JOB")
		RecordFloor = rs("FLOOR")

		
		TableName = Prefix & RecordJob & RecordFloor & Suffix


	'CUT TABLES	
		Set rs2 = Server.CreateObject("adodb.recordset")

			strSQL2 = "Select * into [MS Access;DATABASE=f:\database\ArchiveLists.mdb]." & TableName &  " FROM [MS Access;DATABASE=f:\database\quest.mdb]." & TableName
				On Error Resume Next  
					rs2.Open strSQL2, DBConnection2
					if Err  Then
						TableCount = TableCount -1
						
					End If
				On Error Resume Next 
				

			SQL3 = "Drop TABLE " & TableName 
			On Error Resume Next  
			Set RS3 = DBConnection.Execute(SQL3)
			On Error Resume Next 
			
		'	XSQL3 = "Drop TABLE SHIP_" & TableName 
		'	On Error Resume Next  
		'	Set XRS3 = DBConnection.Execute(XSQL3)
		'	On Error Resume Next 

			SQL4 = "UPDATE Z_Cutlists SET ACTIVE = FALSE WHERE CUTLIST = '" & TableName &  "'"
				On Error Resume Next  
					RS4 = DBConnection.Execute(SQL4)
				On Error Resume Next 
			
			
			TableCount = TableCount + 1

			If rs2.State = 1 Then 
				rs2.Close
				set rs2 = nothing
			End If
			

	rs.movenext	
	loop

i = i+1
loop
 
 
'ReportCreate = "Cutlists_" & TwoAgoMonth & TwoAgoYear
'Set rs4 = Server.CreateObject("adodb.recordset")
'strSQL4 = "Select * from  INV_Reports"
'rs4.Cursortype = 2
'rs4.Locktype = 3
'rs4.Open strSQL4, DBConnection2
'rs4.filter = "ReportName = '" & ReportCreate & "'"
 
' if rs4.eof then
 
' rs4.addnew
 'rs4.fields("ReportName") = ReportCreate
 'rs4.fields("CreatedDate") = currentDate
 'rs4.fields("SnapMonth") = TwoAgoMonth
 'rs4.fields("SnapYear") = TwoAgoYear
 'rs4.fields("TableCount") = TableCount
 
' rs4.update
' end if
 
rs.close
set rs = nothing
'rs4.close
'set rs4 = nothing

DBConnection.close
set DBConnection = nothing
DBConnection2.close
set DBConnection2 = nothing
 
%>
 
    </head>
<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a class="button leftButton" type="cancel" href="index.html#_Report" target="_self">Reports</a>
        </div>
   
   
   
    <ul id="Profiles" title="SnapShot of Inventory " selected="true">
	<% if IsError = True then %>
	<li>Report Not Generated: <%response.write error %>
	<%else%>
	<li>Items copied: <%response.write TableCount %></li>
	<%response.write Copied %>
	<%end if%>
	</ul>
 

<% 

%>
 
</body>
</html>