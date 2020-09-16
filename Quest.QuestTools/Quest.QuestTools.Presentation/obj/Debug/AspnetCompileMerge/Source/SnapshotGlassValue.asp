<!--#include file="dbpath_secondary.asp"-->
<!-- Added a script to include Sorttable.js to allow tables to be sorted on screen - January 21st, 2014 Michael Bernholtz-->
<!-- Created for Mahesh Mohanlall and Vanessa Abraham by Michael Bernholtz April 2019-->
<!-- Read and Report Glass information -->
<!-- SnapshotGlassSelect SnapshotGlassValue-->

<!--Date: June 28, 2019
	Modified By: Michelle Dungo
	Changes: Modified to get price from _qws_Inv_GlassPrices table
			 Look-up on pricing table will get latest price in pricing table for that inventory is price is not entered for that period
			 Added Download and fixed issue with sorting
			 Removed exchange rate and rolling total as requested
			 Modified headers to reflect values in CAD for Canada report and USD for US
	
	Date: August 30, 2019
	Modified By: Michelle Dungo
	Changes: Modified calculation of exchange rate to take entry date when price taken is not from the same period
			Add column to display lites, update logic of getting nearest available price
			Add column to display period price was taken, set to blank when no price available for any period

-->

<%

	If Request("Download") = "YES" Then
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-Disposition", "attachment; filename=GlassInventoryReport.xls"
	Else
%>
<style>
	body { font-family: arial; }
	td { font-size: 13px; }
</style>
 <script src="sorttable.js"></script>
  <script >
 table {
border-collapse:collapse;
}
</script>
<%
	End If
Dim b_Debug: b_Debug = False

Country = Request.Querystring("Country")
ReportName1 = Request.Querystring("ReportName1")
ReportName2 = Request.Querystring("ReportName2")
if Country ="USA" then
	ReportName = Request.Querystring("ReportName1")
else
	ReportName = Request.Querystring("ReportName2")
end if

ReportMonth = Left(Right(ReportName,6),2)
IF Left(ReportMonth,1) = 0 Then
	ReportMonth = Right(ReportMonth,1)
end if
ReportYear = Right(ReportName,4)
RecordNumbers = 0
pricePeriod = ""

' Canada View NASHUA USA view JUPITER - for future reports
if Country ="USA" then
	strSQL = "SELECT * FROM [" & ReportName & "] WHERE (Quantity > 0) order by MasterID ASC"
else
	strSQL = "SELECT * FROM [" & ReportName & "] WHERE (Quantity > 0) order by MasterID ASC"
end if

Set rs = Server.CreateObject("adodb.recordset")

rs.Cursortype = 2
rs.Locktype = 3
rs.Open strSQL, DBConnection2

'response.buffer = false 
%> 
<!-- January 21 - turned <Table> into <table border='1' class='sortable'> and added the sortable table script-->
<h2> Glass Inventory As of  <%Response.write ReportMonth%> / <%Response.write ReportYear%></h2>
<h3> Using Inventory from: <%Response.write ReportName%></h3>
<h3> Viewing <%Response.write Country%></h3>
<% If Request("Download") <> "YES" Then %>
<a href="SnapshotGlassValue.asp?Country=<%response.write Country%>&ReportName=<%response.write ReportName%>&reportname1=<%response.write ReportName1%>&reportname2=<%response.write ReportName2%>&Download=YES" target="_self"><b>Download Excel Copy</a><br/>
<% End If %>

<table border='1' class='sortable'>
	<tr>
<% If b_Debug Then %>
	<th>Master ID</th>
<% End If %>	
	<th>Item Name</th>
	<th>Size</th>
    <th>Serial Number</th>
    <th>Manufacturer</th>
	<th>Qty</th>
	<th>Lites/Pack</th>
	<th>SQFT <br>(Per Pack)</th>
	<% 
	if Country ="USA" then
	%>
	<th>$/SQFT ($USD)</th>
	<%
	else
	%>	
    <th>$/SQFT ($CAD)</th>
	<%
	end if
	%>
	<th>Price Period</th>
	<% If b_Debug Then %>	
	<th>ExchangeRate <br> (CAD per USD)</th>
	<%
	End if
	%>
	<th>Value
	<% 
	if Country ="USA" then
		Response.write " ($USD) <br> (Qty * SQFT * Price)"
	else  
		Response.write " ($CAD) <br> (Qty * SQFT * Price)"
	end if
	%>
	</th>
	<th>Entry Date</th>
<% If b_Debug Then %>	
	<th>Rolling Total
	<% 
	if Country ="USA" then
		Response.write " ($USD)"
	else  
		Response.write " ($CAD)"
	end if
	%>
	</th>
<% End If %>	
    </tr>

<%

rs.movefirst
do while not rs.eof
masterid = rs("masterid")
SerialNumber = rs("SerialNumber")
Quantity = rs("Quantity")
EntryDate = rs("EntryDate")
DateNumeric = Trim(ReportYear & Left(Right(ReportName,6),2))
If IsNumeric(DateNumeric) Then 
	If CLng(DateNumeric) > 201906 Then 
		LitesQty = rs("LitesQty")
	Else 
		LitesQty = 0
	End If
End If	
errormsg = 0

'Create a Query
    SQL2 = "SELECT * FROM [MS Access;DATABASE=" & "F:\database\QualityControlDB.mdb" & "].[QC_MASTER_GLASS] where ID = " & masterid & " order BY ID DESC"
'Get a Record Set
    Set RS2 = DBConnection.Execute(SQL2)
	
	Dim cn_SQL: Set cn_SQL = Server.CreateObject("adodb.connection")		
	DBOpen cn_SQL, True
	
	SQLGlassPrice = "SELECT * FROM _qws_Inv_GlassPrices order BY Period DESC"
	Set rs_GlassPrices = GetDisconnectedRS(SQLGlassPrice, cn_SQL)
	
	SQLExchange = "SELECT * FROM _qws_Inv_SupplierPrices order BY Period DESC"
	Set rs_ExchangeRate = GetDisconnectedRS(SQLExchange, cn_SQL)
	
	if rs2.eof then
		errormsg = 1
		price = 0
		Description = "Error in Description - Value 0"
	else
		'itemName  = rs2("ItemName")
		itemName  = rs2("ItemName")
		Size  = "" & rs2("Width") & " X " & rs2("Height")
		Manufacturer  = rs2("Manufacturer")
		' if snapshot LitesQty column has no value get value from QC_MASTER_GLASS
		If IsNull(LitesQty) Or Trim(LitesQty) = 0 Or Trim(LitesQty) = "0" Or Trim(LitesQty) = "" Or UCASE(Trim(LitesQty)) = "NULL" Or LitesQty = NULL Then
			Pack = rs2("Pieces")			
		Else
			Pack = LitesQty			
		End If
		
		DateMonth = Month(EntryDate)
		if Len(DateMonth) = 1 then
			DateMonth = "0" & DateMonth
		end if
		DateYear = Year(EntryDate)
		
		reportPeriod = DateYear & DateMonth
		if Len(reportPeriod) = 6 then
		price = GetPrice(masterid, itemName, reportPeriod)
		else
		errormsg = 1
		end if
		SQFT = Round((rs2("Width") * rs2("Height") * Pack)/144,2)
		errormsg = 0
		
	end if
	rs2.close
	set rs2 = nothing



if errormsg = 1 then
response.write part & "(" & rs("id") & ")" &" not in Glass master <BR>"
end if


If Not IsNull(Quantity) Then

	'gets exchange rate value for the entry date period / used for debug only
		PartMonth = Month(EntryDate)
		if Len(PartMonth) = 1 then
			PartMonth = "0" & PartMonth
		end if
		PartYear = Year(EntryDate)
		
		str_Period = PartYear & PartMonth
		if Len(str_Period) = 6 then
		else 
				'Use Default Exchange Rate Set by Mahesh April 2019 - 1.3
				ExchangeRate = 1.3
		end if
		
		'Dim cn_SQL: Set cn_SQL = Server.CreateObject("adodb.connection") michelle
		
		'DBOpen cn_SQL, True michelle
		
		SQL2 = "SELECT * FROM _qws_Inv_SupplierPrices order BY Period DESC"
		Set rs_Prices = GetDisconnectedRS(SQL2, cn_SQL)
		
		rs_Prices.Filter = "Period=" & str_Period + 0
		If Not rs_Prices.EOF Then
				ExchangeRate = rs_Prices.Fields("ExchangeRate")
		ELSE
				'Use Default Exchange Rate Set by Mahesh April 2019 - 1.3
				ExchangeRate = 1.3
		End if

	
	TempValue = (Price * SQFT * Quantity) 
	TotalValue = TotalValue + TempValue	

%>

	<tr>
<% If b_Debug Then %>	
	<td><% response.write masterid %></td>
<% End If %>		
	<td><% response.write itemName %></td>
    <td><% response.write Size %></td>
    <td><% response.write SerialNumber %></td>
    <td><% response.write Manufacturer %></td>
	<td><% response.write Quantity %></td>
	<td><% response.write Pack %></td>
	<td><% response.write SQFT %></td>
	<td>$<% response.write round(Price,2) %></td>
	<td><% 
	If Len(pricePeriod) = 6 Then
		response.write Right(pricePeriod, 2) & "/" & Left(pricePeriod, 4)
	Else
		response.write pricePeriod 
	End If
	%></td>	
<% If b_Debug Then %>
	<td><% response.write ExchangeRate %></td>
<% End If %>			
    <td>$<% response.write round(tempvalue,2) %></td>
	<td><% response.write EntryDate %></td>		
<% If b_Debug Then %>		
	<td>$<% response.write round(totalvalue,2) %></td>
<% End If %>			
    </tr>
	

<%	

ELSE
RESPONSE.WRITE "QTY IN INVENTORY IS ZERO <BR>"
END IF

	
RecordNumbers = RecordNumbers + 1
rs.movenext
loop
rs.close
set rs=nothing

DBConnection.close
set DBConnection = nothing
DBConnection2.close
set DBConnection2 = nothing
if Country ="USA" then
cn_SQL.close
set cn_SQL = nothing
end if

%> 
</Table> 

<%

response.write "<BR><HR>"
response.write "Total Glass Material $" & round(Totalvalue,2) & "<BR>"
response.write RecordNumbers & " Records"& "<BR>"

%>
</body>
</html>
<%
	Function GetPrice(strMasterID, strItemName, str_Period)
		Dim str_Ret: str_Ret = "0"
		
		rs_GlassPrices.Filter = "MasterID=" & strMasterID & " AND Period=" & str_Period

		'if price for item and given period found
		If Not rs_GlassPrices.EOF Then			
			'filter by masterid and period
			rs_GlassPrices.Filter = "MasterID=" & strMasterID & " AND Period=" & str_Period
			pricePeriod = str_Period

			'provided amount is in USD
			If rs_GlassPrices.Fields("PricePerSqftUSD") > 0 Then
				If Country ="USA" Then
					str_Ret = rs_GlassPrices.Fields("PricePerSqftUSD")
				Else
					str_Ret = rs_GlassPrices.Fields("PricePerSqftUSD") * GetExchangeRate(str_Period)
				End If					
			'provided amount is in CAD				
			Else 
				If Country ="USA" Then
					str_Ret = rs_GlassPrices.Fields("PricePerSqftCAD") / GetExchangeRate(str_Period)
				Else
					str_Ret = rs_GlassPrices.Fields("PricePerSqftCAD")
				End If		
			End If		
		'get nearest price in table if item doesn't have price for that period
		Else		
			'filter by masterid
			rs_GlassPrices.Filter = "MasterID=" & strMasterID

			'if any price exists
			If Not rs_GlassPrices.EOF Then
				pricePeriodOlder = ""
				pricePeriodNewer = ""
				pricePeriodCurrent = ""				
				'sort ascending by period
				rs_GlassPrices.Sort = "Period ASC" 
				'convert entry date period to Long 
				entryPeriod = CLng(str_Period)
				Do While Not rs_GlassPrices.EOF
					'convert current price table period to Long 
					pricePeriodCurrent = CLng(rs_GlassPrices.Fields("Period"))					
					
					'sets value to nearest period available less than entry date (old price)
					If entryPeriod > pricePeriodCurrent Then
						pricePeriodOlder = pricePeriodCurrent
					ElseIf entryPeriod < pricePeriodCurrent Then
						'sets value to  the first period available greater than the entry date (future price)
						If pricePeriodNewer = "" Then
							pricePeriodNewer = pricePeriodCurrent
						End If
					End If
					rs_GlassPrices.MoveNext
				Loop
				
				'always use older price if available, else use future price
				If pricePeriodOlder <> "" Then
					pricePeriod = pricePeriodOlder
				Else
					pricePeriod = pricePeriodNewer
				End If
				
				' filter given masterid and nearest available price period
				rs_GlassPrices.Filter = "MasterID=" & strMasterID & " AND Period=" & pricePeriod
				
				'provided amount is in USD
					If rs_GlassPrices.Fields("PricePerSqftUSD") > 0 Then
						If Country ="USA" Then
							str_Ret = rs_GlassPrices.Fields("PricePerSqftUSD")
						Else
							str_Ret = rs_GlassPrices.Fields("PricePerSqftUSD") * GetExchangeRate(str_Period)
						End If					
					'provided amount is in CAD				
					Else 
						If Country ="USA" Then
							str_Ret = rs_GlassPrices.Fields("PricePerSqftCAD") / GetExchangeRate(str_Period)
						Else
							str_Ret = rs_GlassPrices.Fields("PricePerSqftCAD")
						End If		
					End If
				
			'if no price available
			Else
				b_Error = True
				pricePeriod = "" ' set to blank period
			End If
		End If			
		
		GetPrice = str_Ret
	End Function
	
	' get Exchange Rate from USD to CAD given the datein period, multiply to USD to get CAD, divide CAD with this value to get USD
	Function GetExchangeRate(str_Period)
		Dim str_Ret: str_Ret = "1.3" ' default exchange rate

		rs_ExchangeRate.Filter = "Period=" & str_Period
		If Not rs_ExchangeRate.EOF Then
			str_Ret = rs_ExchangeRate.Fields("ExchangeRate")
		End If
		
		GetExchangeRate = str_Ret
	End Function	
%>