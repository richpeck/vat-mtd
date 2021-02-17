<center>
  <img src="https://img.shields.io/github/downloads/richpeck/vat-mtd/total?style=flat-square" />
  <img src="https://img.shields.io/github/repo-size/richpeck/vat-mtd?logoColor=00FF00&style=flat-square" />
  <img src="https://img.shields.io/github/languages/top/richpeck/vat-mtd?logoColor=00FF00&style=flat-square" />
  <img src="https://img.shields.io/github/stars/richpeck/vat-mtd?style=flat-square" />
  <br /><br />
  <img src="https://img.shields.io/github/license/richpeck/vat-mtd?style=flat-square" />
  <img src="https://img.shields.io/github/issues-raw/richpeck/vat-mtd?style=flat-square" />
</center>
<center>--</center>

Ruby implementation of the [HMRC VAT (MTD) API](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0).

Inspired by [100pcVATFreeBridge](http://www.comsci.co.uk/100PcVatFreeBridge.html), we wanted to explore the technology required to facilitate such a solution.

-

We chose to leave the code open to furnish others with the means to create and manage their own.

You are welcome to use any of the code contained in this repository.

---

##### 💾 Solution

The app provides users with the ability to upload a document (Excel sheet), from which data can be extracted and submitted to HMRC.

Built with the Sinatra framework, it runs on a Ruby stack. The database can be MySQL or PgSQL and can be run on any platform which supports Ruby based deployments. Our staging environment is Heroku and we run an Ubuntu server in production.

-

The flow is simple:

 - Create a user account (allows for the storage of account-centric data, such as VRN number)
 - Authenticate with HMRC (oAuth)
 - Provide means to download return history, view liabilities & payments
 - Support uploading an Excel sheet and associating cells with VAT return boxes 1-9
 - Submit said data to HMRC via POST API endpoint

-

Communication with HMRC is handled via the [REST API](https://developer.service.hmrc.gov.uk/api-documentation/docs/api?filter=vat).

Dealing with the API is simple, but requires correct authentication headers.

--

##### oAuth

The most difficult part of the implementation was the oAuth connectivity.

Due to this using Ruby's Sinatra framework, we have used the [OmniAuth gem](https://github.com/omniauth/omniauth), which provides a framework through which to communicate with oAuth endpoints. We adopted the standard oAuth2 gem, from which we were able to configure it for our this use case.


---

##### ⚖️ Copyrights/Licenses

Copyrights owned by respective contributors.

This is open source software, distributed under the [MIT license](/richpeck/vat-mtd/blob/master/LICENSE). Provided "as-is" with no warranty.

---

©️ <a href="http://www.frontlineutilities.co.uk" title="Frontline Utilities LTD"><img src="https://i.imgur.com/xwejn02.jpg" align="absmiddle" /></a> <a href="https://www.github.com/richpeck" title="Richard Peck"><img src="https://avatars2.githubusercontent.com/u/1104431?v=3&s=460" height="22" align="absmiddle" /></a>
