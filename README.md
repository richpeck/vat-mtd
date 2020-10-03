[[ img ]]

HMRC's [**MTD** (Making Tax Digital)](https://www.gov.uk/guidance/making-tax-digital-for-vat) has opened a number of API endpoints to developers.

The [**VAT-MTD** endpoint](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#endpoints) allows us to create, amend and submit VAT returns for companies authenticated with the service.

Thus, as an ode to [100% Free VAT Bridge](http://www.comsci.co.uk/100PcVatFreeBridge.html), we decided to try and create a comparable tool in Ruby (using the Sinatra web framework).

---

### 💻 Code

Written in [Ruby](https://www.ruby-lang.org/en/) with the [Sinatra](http://sinatrarb.com/) web framework.

Has several modules:

- **Authentication**

  Uses warden to provide session-logging. This enables us to store passwords & user credentials & validate against them when the user tries to log in.

- **oAuth**

  Connects to MTD authentication endpoint to provide system with the ability to interact with the client's VAT account.

- **Returns**

  Interacts with the VAT-MTD "[GET] Returns" endpoint to list the most recent VAT returns for users.

- **Submissions**

  Creates new submission for the client, using data from an uploaded XLS (Excel) spreadsheet.

-

Goal was to make a system which:

1. Authenticates with the VAT-MTD service
2. Is able to populate the authenticated client's previous returns
3. Is able to submit new returns, populated with data from XLS (Excel) spreadsheets
4. Can validate the success of said returns

---

### ⚖️ Copyrights/Licenses

Copyrights owned by respective contributors.

Repository is published under the [MIT license](LICENSE), meaning anyone is free to clone, distribute and edit the code however they please.

If this is done with malicious intent, appropriate recourse will be exercised.

The repository does not represent a professional tool, and is designed as a technical demonstration.

Use of this code, and accompanying online demonstration, is provided “as is” without warranty of any kind, express or implied, including but not limited to warranties of performance, merchantability, fitness for a particular purpose, accuracy, omissions, completeness, currentness and delays. Users agree that outputs from the software will not, under any circumstances, be considered legal or professional advice and are not meant to replace the experience and sound professional judgment of professional advisors in full knowledge of the circumstances and details of any matter on which advice is sought.

---

©️ <a href="http://www.frontlineutilities.co.uk" title="Frontline Utilities LTD"><img src="private/fl.jpg" align="absmiddle" /></a> <a href="https://www.github.com/richpeck" title="Richard Peck"><img src="https://avatars2.githubusercontent.com/u/1104431?v=3&s=460" height="22" align="absmiddle" /></a>
