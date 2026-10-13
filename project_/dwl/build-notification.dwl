%dw 2.0
output application/json
---
{
    "eventType": "ORDER_FULFILLED",
    "correlationId": vars.correlationId,
    "orderId": vars.orderId,
    "invoiceNumber": vars.invoiceNum,
    "invoicePath": vars.invoiceFileName,
    "customerEmail": vars.orderData.customer.email,
    "customerName": vars.orderData.customer.name,
    "backorderedLines": vars.backorderedLinesCount,
    "payableTotal": vars.orderData.orderTotal,
    "currency": vars.orderData.currency,
    "shippingAddress": vars.orderData.shippingAddress,
    "items": vars.orderData.items
}