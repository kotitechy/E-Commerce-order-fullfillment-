%dw 2.0
output text/plain
---
"Dear " ++ (vars.notifyData.customerName default "Customer") ++ ",\n\n" ++
"Thank you for your order. We have received your payment and your order is now being prepared for dispatch.\n\n" ++
"Order Number: " ++ (vars.orderId default "") ++ "\n" ++
"Invoice Number: " ++ (vars.notifyData.invoiceNumber default "") ++ "\n" ++
"Payable Total: " ++ (vars.notifyData.currency default "INR") ++ " " ++ (vars.notifyData.payableTotal as String default "0") ++ "\n\n" ++
"Delivery Address:\n" ++
(vars.notifyData.shippingAddress.line1 default "") ++ ", " ++ (vars.notifyData.shippingAddress.city default "") ++ "\n\n" ++
"Your tax invoice is attached to this email.\n\n" ++
"Regards,\nNPN Retail Customer Care"