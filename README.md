[[ img ]]

HMRC's [MTD (Making Tax Digital)](https://www.gov.uk/guidance/making-tax-digital-for-vat) has opened a variety of API endpoints to developers.

The [VAT-MTD](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0) service facilitates the creation & submission of VAT returns for authenticated companies.

As an ode to [100% Free VAT Bridge](http://www.comsci.co.uk/100PcVatFreeBridge.html), we decided to create a comparable tool (in Ruby & Sinatra).

---

### 💻 Code

Written in [Ruby](https://www.ruby-lang.org/en/) with the [Sinatra](http://sinatrarb.com/) web framework.

Several modules:

- **Authentication**

  Uses warden to provide session-logging. This enables us to store passwords & user credentials & validate against them when the user tries to log in.

- **oAuth**

  Connects to MTD authentication endpoint to provide system with the ability to interact with the client's VAT account.

- **Returns**

  Interacts with the VAT-MTD "[GET] Returns" endpoint to list the most recent VAT returns for users.

- **Submissions**

  Creates new submission for the client, using data from an uploaded XLS (Excel) spreadsheet.

---

### ⚖️ Copyrights/Licenses

Copyrights owned by respective contributors.

This is a technical demonstration. The code, and corresponding demo service, are provided "as-is" with no warranty.

---

©️ <a href="http://www.frontlineutilities.co.uk" title="Frontline Utilities LTD"><img src="https://i.imgur.com/xwejn02.jpg" align="absmiddle" /></a> <a href="https://www.github.com/richpeck" title="Richard Peck"><img src="https://avatars2.githubusercontent.com/u/1104431?v=3&s=460" height="22" align="absmiddle" /></a>
