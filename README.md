# Salesforce Integration POC — Zoom, Microsoft Teams, Stripe

**Goal:** Hands-on POC to consume REST APIs from Salesforce (Apex callouts via Named/External Credentials) for:
- Zoom: create meetings via Server-to-Server OAuth.
- Microsoft Teams: post messages to a channel using Microsoft Graph (client credentials).
- Stripe: create Checkout Sessions (test mode) using API key in a custom header.

## Quick Start

1) **Prereqs**
- Salesforce Dev Hub + Trial/Scratch org enabled
- VS Code + Salesforce CLI (sfdx)
- Git
- Zoom admin account (to create S2S OAuth app)
- Azure AD tenant admin consent (Microsoft Graph)
- Stripe test account

2) **Clone & setup**
```bash
git clone <your-repo-url>.git
cd salesforce-integration-poc
sfdx force:org:create -s -f config/project-scratch-def.json -a integPOC
sfdx force:source:push
sfdx force:user:permset:assign -n IntegrationPOC
sfdx force:user:permset:assign -n ExternalCredentialAccess
sfdx force:org:open
```

3) **Configure Named/External Credentials** in Setup:
- **Zoom**: OAuth 2.0 (Server-to-Server) – token from Zoom per docs.
- **Teams (Graph)**: OAuth 2.0 Client Credentials (application permission).
- **Stripe**: External Credential (Custom) + Custom Header `Authorization: Bearer <STRIPE_SECRET>`.

4) **Run demo**
- Open **Developer Console** → `Execute Anonymous`:
```apex
// Zoom demo:
System.debug(ZoomService.createMeeting('My Test Meeting', Datetime.now().addDays(1), 45));

// Teams demo:
System.debug(TeamsService.postChannelMessage('<TEAM_ID>', '<CHANNEL_ID>', 'Hello from Salesforce POC!'));

// Stripe demo:
System.debug(StripeService.createCheckoutSession(1999, 'usd', 'https://example.com/success', 'https://example.com/cancel'));
```

