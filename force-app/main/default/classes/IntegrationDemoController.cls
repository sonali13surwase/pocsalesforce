public with sharing class IntegrationDemoController {
    @AuraEnabled(cacheable=false)
    public static String testZoom() {
        return JSON.serialize(ZoomService.createMeeting('POC Meeting', Datetime.now().addDays(1), 30));
    }
    @AuraEnabled(cacheable=false)
    public static String testTeams(String teamId, String channelId, String msg) {
        return JSON.serialize(TeamsService.postChannelMessage(teamId, channelId, msg));
    }
    @AuraEnabled(cacheable=false)
    public static String testStripe() {
        return JSON.serialize(StripeService.createCheckoutSession(1999, 'usd', URL.getSalesforceBaseUrl().toExternalForm() + '/apex/success', URL.getSalesforceBaseUrl().toExternalForm() + '/apex/cancel'));
    }
}
