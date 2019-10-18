
# Consume Location /ssldecrypt de ../conf.d/lua.conf

curl -X POST \
  -k https://desa.sunat.gob.pe:444/ssldecrypt \
  -H 'cache-control: no-cache' \
  -H 'content-type: text/xml' \
  -H 'postman-token: eb8f1d96-4460-45a9-5a4b-c6ee5ce87b34' \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Header>
      <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1">
         <wsu:Timestamp wsu:Id="TS-87203339-26a0-4fe0-9ee7-9a35e6896492">
            <wsu:Created>2019-09-20T20:52:46.862Z</wsu:Created>
            <wsu:Expires>2019-09-20T20:57:46.862Z</wsu:Expires>
         </wsu:Timestamp>
         <wsse:BinarySecurityToken>MIIC4zCCAkygAwIBAgIEWL33HTANBgkqhkiG9w0BAQUFADCBmjEjMCEGCSqGSIb3DQEJARYUbnF1aXNwZUBzdW5hdC5nb2IucGUxCzAJBgNVBAYTAlBFMQ0wCwYDVQQIDARMaW1hMQ0wCwYDVQQHDARMaW1hMRgwFgYDVQQKDA9ORUNTU0VJTiBTLlIuTC4xGDAWBgNVBAsMD05FQ1NTRUlOIFMuUi5MLjEUMBIGA1UEAwwLMjA0NTI2MjY2OTIwHhcNMTcwMzA2MjM1NjEzWhcNMjAwMzA1MjM1NjEzWjCBmjEjMCEGCSqGSIb3DQEJARYUbnF1aXNwZUBzdW5hdC5nb2IucGUxCzAJBgNVBAYTAlBFMQ0wCwYDVQQIDARMaW1hMQ0wCwYDVQQHDARMaW1hMRgwFgYDVQQKDA9ORUNTU0VJTiBTLlIuTC4xGDAWBgNVBAsMD05FQ1NTRUlOIFMuUi5MLjEUMBIGA1UEAwwLMjA0NTI2MjY2OTIwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAJwxYaUeHNIB6LCCiUdb9PTecWFT6xihrT5R2JHr2nlblFzY7NeVeYhMvNGpKUUZTAeYayyFr20WlxUPu08ZwQgI0X8GsYF0Kd6N4/muh9VMGIj+2ltBygupYLhaTprwRoZr1xrwBQCZkueJizxAVfZ2xZxDFrKSY+vjLRpweaLRAgMBAAGjNDAyMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAOBgNVHQ8BAf8EBAMCBPAwDQYJKoZIhvcNAQEFBQADgYEAPcYS10B2LlFhIITGmyxe+Gm5Rc+jO7O/KPYWHVAuuYJOggIsSzjRSkDYkwhRooBT0yAsqYOdbOOgPOwUyfeEFxsyqNoaGR0rUD/enevV/jGCSF9sdmP6UPRxIsZQVQoO/DKsi391Ht8gwlhlsDFZkWE14LvKyPx39chaV02mvOw=</wsse:BinarySecurityToken>
         <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-7cae9a85-8ccb-40e5-b233-f0f09b02c516">
            <ds:SignedInfo>
               <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                  <ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap" />
               </ds:CanonicalizationMethod>
               <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
               <ds:Reference URI="#id-bbc3dd73-e883-40f7-8db2-660a01dcd462">
                  <ds:Transforms>
                     <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" />
                  </ds:Transforms>
                  <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />
                  <ds:DigestValue>GIsUkbjf3EXqoGnnds1PMKH9WOE=</ds:DigestValue>
               </ds:Reference>
            </ds:SignedInfo>
            <ds:SignatureValue>i+YpefCYOF6Qn73+GvHgthnrAbXbabKwvaegm7DLqU/sSIdVTHysBaT96vgTgyshacsd/Upzt/eSVb61a+PJMbrtyj/Hx/VszMOpLpl9uzytag3pUACOY0VeEv9+IbfXgTMeVpUPgWcLvHme3uSqdqxYMW1Rv8vFk/BVZ1jWoMs=</ds:SignatureValue>
            <ds:KeyInfo Id="KI-84c9491e-0e09-4c27-8d87-ef2ea3ab6cac">
               <wsse:SecurityTokenReference wsu:Id="STR-f813d46f-c00a-4c4d-9c6b-4c49bb6840d4">
                  <wsse:Reference URI="#X509-c66c7536-e936-4d27-8fa8-a968e268cef7" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" />
               </wsse:SecurityTokenReference>
            </ds:KeyInfo>
         </ds:Signature>
      </wsse:Security>
   </soap:Header>
   <soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-bbc3dd73-e883-40f7-8db2-660a01dcd462">
      <ns2:getStatus xmlns:ns2="http://service.sunat.gob.pe">
         <ticket>20520485750-01-FNN1-306</ticket>
      </ns2:getStatus>
   </soap:Body>
</soap:Envelope>
 '
 
 ################################################################
 
 
