%dw 2.0
output text/plain
var totalAmount = vars.orderData.orderTotal default 0
var taxableAmount = round((totalAmount / 1.18) * 100) / 100
var totalTax = totalAmount - taxableAmount
var halfTax = round((totalTax / 2) * 100) / 100
---
"==========================================================\n" ++
"TAX INVOICE\n" ++
"==========================================================\n" ++
"Invoice Number: " ++ vars.invoiceNum ++ "\n" ++
"Invoice Date:   " ++ (now() as String {format: "dd-MMM-yyyy"}) ++ "\n" ++
"Order Number:   " ++ vars.orderId ++ "\n" ++
"Order Date:     " ++ (now() as String {format: "dd-MMM-yyyy"}) ++ "\n\n" ++
"SELLER:\n" ++
"NPN Retail Private Limited\n" ++
"Plot 22, Ambattur Industrial Estate, Chennai 600058\n" ++
"GSTIN: 33AABCN1234M1Z7\n\n" ++
"BILL TO:\n" ++
vars.orderData.customer.name ++ "\n" ++
vars.orderData.billingAddress.line1 ++ ", " ++ vars.orderData.billingAddress.city ++ ", " ++ vars.orderData.billingAddress.state ++ " " ++ vars.orderData.billingAddress.postalCode ++ "\n" ++
"GSTIN: " ++ (vars.orderData.billingAddress.gstin default "N/A") ++ "\n\n" ++
"ITEMS:\n" ++
"----------------------------------------------------------\n" ++
((vars.orderData.items map ((item, idx) -> 
    (idx + 1) ++ ". " ++ item.sku ++ " | " ++ item.productName ++ " | QTY: " ++ item.quantity ++ " | RATE: " ++ item.unitPrice ++ " | TOTAL: " ++ item.lineTotal
)) joinBy "\n") ++ "\n" ++
"----------------------------------------------------------\n" ++
"Taxable Amount: " ++ (taxableAmount as String) ++ "\n" ++
"CGST 9%:        " ++ (halfTax as String) ++ "\n" ++
"SGST 9%:        " ++ (halfTax as String) ++ "\n" ++
"PAYABLE TOTAL:  " ++ (totalAmount as String) ++ "\n" ++
"Payment:        " ++ (vars.orderData.paymentMethod default "PREPAID") ++ " Ref: " ++ (vars.orderData.paymentReference default "N/A") ++ "\n" ++
"Status:         PAID\n" ++
"==========================================================\n"