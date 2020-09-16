<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--#include file="QCdbpath.asp"-->
<!-- Created June 2nd, by Michael Bernholtz - Labels to be Printed for Glass using multiple checkboxes-->
<!-- QC_Glass Table created for Victor at Request of Jody Cash, Implemented by Michael Bernholtz-->
<!-- Created at the request of Victor -->
<!-- One of 4 Tables - QC_GLASS, QC_SPACER, QC_SEALANT, QC_MISC-->
<!-- February 2019 - Added USA Table -->


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>Label Printer</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
<style type="text/css">
@page {
margin-left:4mm;
margin-right:1mm;
margin-top:4mm;
margin-bottom:1mm;
}

@media print {
    html, body {
        height: 99%;    
    }
}

@media print
{
table {page-break-after:always}
}

</style>
</head>

<body>
<%
Dim item
for each item in Request.QueryString("QCID")
	QCID = item
	
	if CountryLocation ="USA" then
		strSQL = "SELECT MG.ItemName, G.SerialNumber, G.EntryDate, G.printed, MG.Code, G.LitesQTY, G.Id FROM QC_GLASS_USA AS G INNER JOIN QC_MASTER_GLASS AS MG ON MG.id = G.MasterID ORDER BY G.ID ASC"
	else
		strSQL = "SELECT MG.ItemName, G.SerialNumber, G.EntryDate, G.printed, MG.Code, G.LitesQTY, G.Id FROM QC_GLASS AS G INNER JOIN QC_MASTER_GLASS AS MG ON MG.id = G.MasterID ORDER BY G.ID ASC"
	end if
	
	Set rs = Server.CreateObject("adodb.recordset")
	rs.Cursortype = 2
	rs.Locktype = 3
	rs.Open strSQL, DBConnection
	rs.filter = "ID = " & QCID 
		
if QCID <> 0 then
		
	ItemName = rs("ItemName")
	SerialNumber = rs("SerialNumber")
	EntryDate = rs("EntryDate")
		LitesQty = rs("LitesQTY")
	GlassCode = rs("Code")

	rs("Printed")= 1
	rs.update
end if

%>

<table align= "center" frame="box" width="350px" cellspacing="1" cellpadding="1">
	
	<tr>
		<td colspan="2" align = 'center'> <b><%response.write ItemName %></b></td>
	</tr>
	<tr>
		<td align = 'center' style="font-size: 100%;"> <b><%response.write SerialNumber %></b></td>
		<td align = 'center' style="font-size: 100%;"> <b><%response.write EntryDate %><b></td>
	</tr>
		<tr>
		<td align = 'center' style="font-size: 100%;"> <b><%response.write GlassCode %> - <%response.write LitesQTY  %> Lites</b></td>
		<td rowspan="2" align = 'center'><img src="http://chart.apis.google.com/chart?cht=qr&chs=75x75&chl=<% response.write UCASE(trim(rs("SerialNumber"))) %>&chld=H|0" alt="Barcode" /></td>
	</tr>
	<tr>
		<td align = 'center' style="vertical-align:middle"> <img src="qlogoV.jpg" width="75" height="20" /></td>
	</tr>
</table>
<script>
window.print()
</script>


<%
	
	
next 

rs.close
set rs = nothing
DBConnection.close
set DBConnection = nothing
%>

</body>
</html>