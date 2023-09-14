public with sharing class HttpSampleCallout {
    
    public void makingCallout() {
        String endpoint = 'https://postman-echo.com/get?foo1=bar1&foo2=bar2';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        Http http = new Http();

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            // If the response is successful (status code 200), print the response body
            String responseBody = response.getBody();
            System.debug('HTTP Response Body: ' + responseBody);
        } else {
            // If the response is not successful, print the status code and error message
            System.debug('HTTP Request Failed with Status Code: ' + response.getStatusCode());
            System.debug('Error Message: ' + response.getStatus());
        }
    }
}
