# End-to-End POC — Salesforce ⇄ Zoom, Teams, Stripe

> Tested with: Salesforce Trial Dev org.

## 0) Create project & scratch org
See README quick start for SFDX commands and scratch org creation.

## 1) Configure authentication in Salesforce
Use External Credentials + Named Credentials. Create:
- Zoom (Server-to-Server OAuth)
- Microsoft Graph (OAuth 2.0 client credentials)
- Stripe (Custom header with API key)

## 2) Apex services (place under force-app/main/default/classes/)
Files included:
- ZoomService.cls
- TeamsService.cls
- StripeService.cls
- IntegrationDemoController.cls

(See classes folder in repo for full Apex source.)

## 3) Permission Sets
Two permission sets included to assign Apex class access and to remind to grant External Credential access.

## 4) Named/External Credential names used by code
- Zoom_API -> https://api.zoom.us/v2
- MS_Graph -> https://graph.microsoft.com/v1.0
- Stripe_API -> https://api.stripe.com

## 5) Testing & cURL sanity checks
Examples for Zoom, Teams, Stripe cURL commands are in the classes comments and the README.

## 6) Enterprise Notes / Gotchas
- Token management: rely on Named/External Credentials.
- Retry & logging.
- Stripe webhooks: handle checkout.session.completed.
- Governor limits: use async for large volumes.

