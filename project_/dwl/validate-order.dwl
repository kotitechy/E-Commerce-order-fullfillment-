%dw 2.0
output application/json
var supportedCurrencies = ["INR", "USD", "EUR"]
var items = payload.items default []
var invalidLineTotals = items filter ((item) -> (item.quantity * item.unitPrice) != item.lineTotal)
var invalidQuantities = items filter ((item) -> item.quantity <= 0 or item.unitPrice < 0)
var calculatedOrderTotal = sum(items.lineTotal default [0])
---
if (isEmpty(items))
    "Empty order: items array cannot be empty."
else if (!isEmpty(invalidQuantities))
    "Invalid item quantity or price: quantity must be > 0 and price >= 0."
else if (!isEmpty(invalidLineTotals))
    "Line total mismatch: item lineTotal does not equal quantity * unitPrice."
else if (!contains(supportedCurrencies, payload.currency))
    "Unsupported currency: " ++ (payload.currency default "")
else if (payload.orderTotal != calculatedOrderTotal)
    "Order total mismatch: header orderTotal does not equal sum of item totals."
else
    null