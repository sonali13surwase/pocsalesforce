public with sharing class ZoomService {
    private static final String NC = 'Zoom_API';
    public class MeetingRequest {
        public String topic;
        public Integer type = 2;
        public String start_time;
        public Integer duration;
        public String timezone;
    }
    public class MeetingResponse {
        public String id;
        public String join_url;
        public String start_url;
        public String password;
        public String status;
    }
    public static MeetingResponse createMeeting(String topic, Datetime start, Integer minutes) {
        MeetingRequest reqBody = new MeetingRequest();
        reqBody.topic = topic;
        reqBody.start_time = start.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        reqBody.duration = minutes != null ? minutes : 30;
        reqBody.timezone = 'UTC';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NC + '/users/me/meetings');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(reqBody));
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            return (MeetingResponse) JSON.deserialize(res.getBody(), MeetingResponse.class);
        }
        throw new CalloutException('Zoom createMeeting failed: ' + res.getStatusCode() + ' ' + res.getBody());
    }
}
