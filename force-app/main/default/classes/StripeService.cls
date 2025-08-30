public with sharing class StripeService {
    private static final String NC = 'Stripe_API';
    public class LineItemPriceData {
        public String currency;
        public Integer unit_amount;
        public Map<String,String> product_data;
    }
    public class LineItem {
        public LineItemPriceData price_data;
        public Integer quantity = 1;
    }
    public class SessionRequest {
        public String mode = 'payment';
        public String success_url;
        public String cancel_url;
        public List<LineItem> line_items;
    }
    public class SessionResponse { public String id; public String url; }
    public static SessionResponse createCheckoutSession(Integer amountCents, String currency,
                                                        String successUrl, String cancelUrl) {
        LineItem li = new LineItem();
        li.price_data = new LineItemPriceData();
        li.price_data.currency = currency;
        li.price_data.unit_amount = amountCents;
        li.price_data.product_data = new Map<String,String>{ 'name' => 'Marketplace Service' };
        SessionRequest body = new SessionRequest();
        body.success_url = successUrl;
        body.cancel_url = cancelUrl;
        body.line_items = new List<LineItem>{ li };
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NC + '/v1/checkout/sessions');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Map<String, String> form = new Map<String,String>{
            'mode' => body.mode,
            'success_url' => body.success_url,
            'cancel_url' => body.cancel_url,
            'line_items[0][price_data][currency]' => li.price_data.currency,
            'line_items[0][price_data][product_data][name]' => li.price_data.product_data.get('name'),
            'line_items[0][price_data][unit_amount]' => String.valueOf(li.price_data.unit_amount),
            'line_items[0][quantity]' => '1'
        };
        req.setBody(encodeForm(form));
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            return (SessionResponse) JSON.deserialize(res.getBody(), SessionResponse.class);
        }
        throw new CalloutException('Stripe Checkout failed: ' + res.getStatusCode() + ' ' + res.getBody());
    }
    private static String encodeForm(Map<String,String> data){
        List<String> parts = new List<String>();
        for (String k : data.keySet()) {
            parts.add(EncodingUtil.urlEncode(k, 'UTF-8') + '=' + EncodingUtil.urlEncode(data.get(k), 'UTF-8'));
        }
        return String.join(parts, '&');
    }
}
