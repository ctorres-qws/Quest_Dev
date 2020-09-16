<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--This page is a copy of the QRloop.asp code written by Jody Cash -->
<!-- It has been modified to include a write command to the X_Shipping table for each record that has a printed label -->


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>Cross-Browser QRCode generator for Javascript</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
<style type="text/css">
body,td,th {
	font-family: Verdana, Geneva, sans-serif;
	font-weight: bold;
	font-size: 30px;
}
@page {
margin-left:1mm;
margin-right:1mm;
margin-top:1mm;
margin-bottom:1mm;
}
@media print
{
table {page-break-after:always}
}
</style>
</head>
<!--#include file="dbpath.asp"-->

<% 

Set rs = Server.CreateObject("adodb.recordset")
strSQL = "Select * FROM X_BARCODE ORDER BY DATETIME DESC"
rs.Cursortype = 2
rs.Locktype = 3
rs.Open strSQL, DBConnection

'Create a Query
   ' SQL = "Select * FROM X_BARCODE ORDER BY DATETIME DESC"
'Get a Record Set
    'Set RS = DBConnection.Execute(SQL)
	
	
'Added New Recordsets for X_SHIPPING
' Filters adjusted Below

 Set rs2 = Server.CreateObject("adodb.recordset")
strSQL2 = "Select JOB, Rate From Z_RATES ORDER BY JOB"
rs2.Cursortype = 2
rs2.Locktype = 3
rs2.Open strSQL2, DBConnection	
	
	
' End of New Record Sets	

	STAMPVAR = month(now) & "/" & day(now) & "/" & year(now)
ccTime = hour(now) & ":" & minute(now)
cHour = hour(now)
cDay = day(now)
cYesterday = cDay - 1
cMonth = month(now)
cMonthy = cMonth
cYear = year(now)
cYeary = cYear
currentDate = Date
weekNumber = DatePart("ww", currentDate)

' Replacing old code (with errors) stored as backup in TodayandYesterday.inc, MIchael Bernholtz, January 2014
' If broken down into 4 parts - each with the months add by one for setting last month end
' April has 30 days, so May 1st sets - April 30, so if current month is may, set length of days in April
' Months with 31 (January, March, May, July, August, October, December)
' Months with 30 ( April, June, September, November)
' February Leap years for 2016 until 2032 coded
' January starts a new Year
If cDay = 1 then
	if cMonth = 2 OR cMonth = 4 OR cMonth = 6 OR cMonth = 8 OR cMonth = 9 OR cMonth = 11 OR cMonth = 1 then
	cYesterday = 31
	end if
	if cMonth = 5 OR cMonth = 7 OR cMonth = 10 OR cMonth = 12 then
	cYesterday = 30
	end if
	if cMonth = 3 then
		if cyear = 2016 OR cyear = 2020 OR cyear = 2024 OR cyear = 2028 OR cyear = 2032  then 
			cYesterday = 29
		else
			cYesterday = 28
		end if
	end if
		
	cMonthy = cMonth - 1	
		
	if cMonth = 1 then
	cMonthy = 12
	cYeary = cYear - 1
	end if
	
	

end if
%>
<body>

<%
  rs.filter = "DAY = " & cDay & " AND MONTH = " & cMonth & " AND YEAR = " & cYear & " AND DEPT = 'GLAZING' "
  rs.movefirst
do while not rs.eof
if rs("print") = 1 then
else
'qr = rs("barcode") & ";ID=" & rs("ID")
job = UCASE(trim(rs("job")))
floor = UCASE(trim(rs("floor")))
tag = UCASE(trim(rs("tag")))
qr = job & floor & tag
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
    <td rowspan="4">Job:
      <% response.write job %>
      <br>
      Floor:
  <% response.write floor %>
      <br>
      Tag:
  <% response.write tag %>
    </td>
    <td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
    <td rowspan="4"><img src="qlogo.jpg" width="75" height="278" /></td>
    <td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
    <td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
    <td><img src="https://chart.googleapis.com/chart?chs=100x100&cht=qr&chl=<% response.write qr %>&choe="UTF-8" alt="QR code" /></td>
  </tr>
</table>


<p>
  <% 
 ' New Code added here for the Addition to the X_Shipping table
 ' Addition is simple but takes one large step to get Price.
 ' Open Master Job Table collect Width and Height
 ' Open Z_rates and collect Rate for JOB
 ' Price = Multiply SQFT (WXH) * Rate 

  'Validation if Item not found, return average Value
 AverageWidth = 10
 AverageHeight = 10
 AveragePrice = 10
 
 WindowID = 35
 
 currentDate =Date()
 

  'Create a Query
   
	 Set rs1 = Server.CreateObject("adodb.recordset")
	strSQL1 = "Select X, Y, JOB, FLOOR, TAG From [" & job & "] ORDER by JOB, FLOOR,TAG ASC"
	rs1.Cursortype = 2
	rs1.Locktype = 3
	rs1.Open strSQL1, DBConnection	
	
	
	
 ' Collect Price
 ' Collect Width and Height from Master JOB table
	
	rs1.filter = ""
	
	rs1.filter = " JOB = '" & job & "' AND FLOOR = '" & floor & "' AND TAG = '" & Tag & "'"
	if rs1.bof then
		width = AverageWidth
		height = AverageHeight
		error = True
	else
		rs1.movefirst
		width = rs1("X")
		height = rs1("Y")
	end if
	rs1.filter = ""
 
 
 ' Get Rate from Z_Rate table
 
 
 
 
	
	rs2.filter = " JOB = '" & job & "'"
 	if rs2.eof then
		rate = AveragePrice
		error2 = True
	else
		rs2.movefirst
		rate = rs2("rate")

	end if
	rs2.filter = ""

 
 price = (width * height / 144)* rate 
 
 qrerror = "Imported on " & currentDate
 if error then
	qrerror = qrerror & ", Error matching Job/Floor/Tag"
end if
if error2 then
	qrerror = qrerror & ", Error Reading Price Rate "
end if
 
 'Query to create X_shipping Records
 
  'Create a Query
    SQL = "INSERT INTO X_SHIPPING (JOB, FLOOR, TAG, DESCRIPTION, WIDTH, HEIGHT, PRICE, LIBRARYID, CREATEDDATE, QTY, PRICEUNIT) VALUES ('" & job & "', '" & floor & "', '" & tag & "', '" & qrerror & "', '" & width & "', '" & height & "', '" & price & "', '" & windowid & "', '" & currentDate & "', '1', 'each')"
'Get a Record Set
    Set RS_Ship = DBConnection.Execute(SQL)
  

  
  
rs.fields("print") = 1   
rs.update
end if

 set rs1 = nothing
rs.movenext
loop

rs.close
set rs = nothing

 rs2.close
 set rs2 = nothing
		DBConnection.close
		set DBConnection =nothing 
%>
</p>
<p>&nbsp;</p>


</body>