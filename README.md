# salesforce-connector
This is to make an external callout in Salesforce

Demo Sites:

[click here](https://apicallouts-developer-edition.ap24.force.com/) to go to source site Url from where we make an external callout.

[click here](https://demo-callouts-developer-edition.ap17.force.com/AccountAPI/) to go to target site Url to where we make an external callout.

Salesforce-JS custom connector

Source org: https://deepsubha-2021-dev-ed.my.salesforce.com/
Components:
calloutDemo.vfp   /* UI made on visualforce page */
CalloutDemoController.apxc    /* controller class */
AccountAPISFToSF.apxc   /* main callout class */
AccountApiGetResponse  /* wrapper class */

Target org: https://deepsubha16-dev-ed.my.salesforce.com/
Components:
Account_Api.vfp /* UI page to see available accounts */
Account_APIController.apxc /* controller class */
AccountApi.apxc  /* expose API for Account */


