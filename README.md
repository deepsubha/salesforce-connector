# salesforce-connector
This is to make an external callout in Salesforce
<hr />
Demo Sites:

[click here](https://apicallouts-developer-edition.ap24.force.com/) to go to source site Url from where we make an external callout.

[click here](https://demo-callouts-developer-edition.ap17.force.com/AccountAPI/) to go to target site Url to where we make an external callout.

<hr />
Salesforce-JS custom connector ( Code Base summary)<br />
Source org: https://deepsubha-2021-dev-ed.my.salesforce.com/<br />
Components:<br />
calloutDemo.vfp   /* UI made on visualforce page */<br />
CalloutDemoController.apxc    /* controller class */<br />
AccountAPISFToSF.apxc   /* main callout class */<br />
AccountApiGetResponse  /* wrapper class */<br />

Target org: https://deepsubha16-dev-ed.my.salesforce.com/<br />
Components:<br />
Account_Api.vfp /* UI page to see available accounts */<br />
Account_APIController.apxc /* controller class */<br />
AccountApi.apxc  /* expose API for Account */<br />

<hr />
Note: Right click in the browser page > inspect > Application > local storage > change the UserId value as 'TestUser_All' , if you can't see Created Account(s) in Target Org. (Not to exceed govrn limit in callouts in Salesforce developer edition org, that way we can minimize the no of callouts)

