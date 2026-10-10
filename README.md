# E-Commerce-order-fullfillment-
Cognizant Mulesoft Hackathon
**PROBLEMS FACED AND APPROACH**
**SMTP Authentication Rejection:** The notification consumer repeatedly failed with a `535 5.7.8 BadCredentials` error during email dispatch. **Tackled by:** Identifying and correcting a domain typo (`@gamil.com` to `@gmail.com`) in the `properties.yaml` file to restore the secure Gmail SMTP connection.

**AMQP TLS Connection Refusals:** The LavinMQ cloud instance rejected initial listener connections on port 5671. **Tackled by:** Explicitly enabling the TLS context (`useTls="true"`) in the MuleSoft AMQP connector configuration to satisfy the strict secure port requirement.

**YAML Numeric String Parsing Errors:** Early deployments failed because the property parser misinterpreted numeric port values as integers rather than strings. **Tackled by:** Enforcing strict YAML string quoting rules (e.g., `port: "587"`) in `properties.yaml` to satisfy MuleSoft's type expectations.

**AMQP Routing Key XML Syntax:** The publisher configurations threw XML validation errors when attempting direct-to-queue messaging. **Tackled by:** Refactoring the specific XML syntax for the routing key within the AMQP publish operation to properly target `order.fulfilment.queue`.

**Handling Duplicate Client Requests:** The pipeline initially risked double-charging and double-processing if a client accidentally fired the same request twice. **Tackled by:** Implementing an idempotency guard using the `X-Request-Id` header to check against the `processed_messages` database table, bypassing the queue and returning existing order details immediately if a duplicate is found.

**Inventory Shortfall Management:** High-quantity orders were not gracefully handling stock limits, risking negative inventory balances. **Tackled by:** Implementing a conditional SQL update (`WHERE sku = :sku AND available_qty >= :qty`). When the query affects 0 rows, the DataWeave logic dynamically shifts the line item and header status from `RESERVED` to `BACKORDERED`.

**Poison Message Bottlenecks:** Malformed JSON payloads risked crashing the asynchronous AMQP listeners and blocking subsequent orders in the queue. **Tackled by:** Configuring a Dead Letter Queue (`order.fulfilment.queue.DLQ`) within the error handling strategy to seamlessly intercept and sideline unprocessable payloads.

**Architecture Modularity Penalties:** The initial functional prototype was built as a single monolithic XML file (`e-commerce-pipeline.xml`), which violates standard hackathon grading rubrics for API-led connectivity. **Tackled by:** Establishing the Phase 3 roadmap to physically isolate the code into strict Experience, Process, and System API layers before the final JAR export.
