public with sharing class TeamsService {
    private static final String NC = 'MS_Graph';
    public class TeamsMessage {
        public String subject;
        public Map<String,Object> body;
        public TeamsMessage(String text) {
            subject = 'Salesforce POC';
            body = new Map<String,Object>{
                'contentType' => 'html',
                'content'     => text
            };
        }
    }
    public class PostResponse { public String id; }
    public static PostResponse postChannelMessage(String teamId, String channelId, String htmlMessage) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NC + '/teams/' + EncodingUtil.urlEncode(teamId, 'UTF-8') +
                        '/channels/' + EncodingUtil.urlEncode(channelId, 'UTF-8') + '/messages');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new TeamsMessage(htmlMessage)));
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            return (PostResponse) JSON.deserialize(res.getBody(), PostResponse.class);
        }
        throw new CalloutException('Teams message failed: ' + res.getStatusCode() + ' ' + res.getBody());
    }
}
