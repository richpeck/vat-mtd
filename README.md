## HMRC's recent creation of [MTD (Making Tax Digital)](https://www.gov.uk/guidance/making-tax-digital-for-vat) has opened a number of API endpoints to developers.

The VAT endpoint is particularly interesting.

This web application is a simple integration into the [VAT-MTD endpoint](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#endpoints), allowing users to view their past submissions, create & submit new ones. The system has been developed with Sinatra (Ruby/Rack framework).

---

#### Authentication

In order to integrate with HMRC, applications need to perform an oAuth request.

This is a simple procedure which creates a token to act in place of a password.

Since we're using a homebrew authentication solution (based on warden), we have integrated the oAuth process directly into our app. If you're using the likes of Devise, there are pre-built solutions available already.

---

#### Returns

The backbone of the system is the ability to view & create VAT returns.

The creation functionality is dependent on external data (spreadsheet), but the core return objects can all be obtained from HRMC through the API.

Like other REST API's the process of achieving this is relatively simple.

---

#### Submission

Finally, submitting new VAT returns is where the real use value of a tool like this resides.

In order to create a compatible submission solution, the system needs to be able to parse data (from a spreadsheet) and send it to HMRC. This, obviously, needs to be mathematically correct, as well as simple & easy to use.

---

©️ <a href="http://www.frontlineutilities.co.uk" title="Frontline Utilities LTD"><img src="private/fl.jpg" align="absmiddle" /></a> <a href="https://www.github.com/richpeck" title="Richard Peck"><img src="https://avatars2.githubusercontent.com/u/1104431?v=3&s=460" height="22" align="absmiddle" /></a>
