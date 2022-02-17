<div align="center">
  <img src="https://img.shields.io/github/downloads/richpeck/vat-mtd/total?style=flat-square" />
  <img src="https://img.shields.io/github/repo-size/richpeck/vat-mtd?logoColor=00FF00&style=flat-square" />
  <img src="https://img.shields.io/github/languages/top/richpeck/vat-mtd?logoColor=00FF00&style=flat-square" />
  <img src="https://img.shields.io/github/stars/richpeck/vat-mtd?style=flat-square" />
  <br /><br />
  <img src="https://img.shields.io/github/license/richpeck/vat-mtd?style=flat-square" />
  <img src="https://img.shields.io/github/issues-raw/richpeck/vat-mtd?style=flat-square" />
</div>
<div align="center">--</div>

Ruby implementation of [HMRC's VAT (MTD) API](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0).

Inspired by [100pcVATFreeBridge](http://www.comsci.co.uk/100PcVatFreeBridge.html), wanted to explore the technology required to facilitate such a solution.

---

# 🧠 Introduction

[VAT (MTD)](https://www.gov.uk/government/publications/vat-notice-70022-making-tax-digital-for-vat/vat-notice-70022-making-tax-digital-for-vat) is an API endpoint of HMRC's [Making Tax Digital](https://en.wikipedia.org/wiki/Making_Tax_Digital) initiative.

MTD was designed to streamline the tax system, allowing tax payers and developers to adopt solutions that boost efficiency and compliance.

The first step to realizing this has been to make VAT digital-only ([self assessment will become digital-only in 2024](https://www.sage.com/en-gb/blog/mtd-for-income-tax-sole-traders) for individuals earning over £10,000 p/a from self-employment). 

[Since April 2019](https://www.gov.uk/government/publications/vat-notice-70022-making-tax-digital-for-vat/vat-notice-70022-making-tax-digital-for-vat#example-1--existing-business-with-taxable-turnover-above-the-vat-registration-threshold-on-1-april-2019), VAT-registered buinesses have not been able to manually submit their VAT returns to HMRC and, instead, need to use a third party application to interface with the API.

Whilst there are a number of "done for you" systems which do this (Xero, Sage etc), there remains people, such as myself, who prefer to keep their financial information private and use the likes of Spreadsheets track expenditure etc. 

For this reason, "[bridging software](https://www.gov.uk/guidance/find-software-thats-compatible-with-making-tax-digital-for-vat)" was developed to connect to the likes of an Excel Spreadsheet and submit its data to HMRC. 

I originally began using [VitalTax](https://vitaltax.uk/), a plugin for Excel. This worked well for a time, and then became paid-only. Thus, I began looking around and found the [100pcVATFreeBridge](http://www.comsci.co.uk/100PcVatFreeBridge.html) software, which is effective and free.

Because of my background with API software development, I felt it would be a good exercise to create my own version of a VAT bridging package. I will detail what I've done in this regard below.

---

# 💻 Technical Scope

The VAT submission process is simple and has not changed with the digital transition.

There are [9 boxes](https://www.gov.uk/guidance/how-to-fill-in-and-submit-your-vat-return-vat-notice-70012#common-requirements-when-completing-boxes-1-to-9) on the VAT return form. These boxes are used to calculate the VAT owed (either by you or as a repayment by HMRC).

VAT returns are submitted each quarter and there is little by way of regulation in terms of the veracity of data submitted. Whilst this has lead to fraudulent claims, it provides flexibility as regards to how your records are kept.

In my case, that's meant a continuation of the "spreadsheet" system I developed to track income and expenses for the business.

The most important part of this has been that I can control it, which means I can change/adapt/improve it over time. I don't want to have to pay for a system that gets access to all of my data and (crucially) locks you in without providing a means of escape.

I think it's healthy to provide the means for people to create solutions that encourage transarency and efficiency. The old, opaque, systems provided by HMRC were shrouded in mystery and constantly caused confusion & issues. By opening up their API's to the public, the flows of data to HMRC will become much more robust and efficient, permitting developers (such as myself) to create solutions around them.

---

# 📒 Submission Process

To submit a VAT return, a VAT-registered business is required to present HMRC with a 9-box form at the end of each quarter.

The structure of these forms is well documented so I won't cover them here.

I will, however, explain how the new VAT-MTD API endpoints work with them, and what that means for the development of software solutions.

--

HMRC's "Making Tax Digital" system is - at its heart - a series of [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) [API endpoints](https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0).

Because these endpoints are standardized, it means that we're able to create software which interact with them.

Whilst the software may vary, the pattern remains the same - an HTTP request is made to HMRC's servers with a payload of data. HMRC's application then computes the data, storing it on their system and providing a response to our application.

The endpoints are protected with the [oAuth standard](https://developer.service.hmrc.gov.uk/api-documentation/docs/authorisation), which makes interfacing with them relatively simple.

Once authenticated with a user's account, your software should be able to submit and manage their VAT returns using the above URLs.

---

# 💾 Software

My implementation is coded in [Ruby](https://www.ruby-lang.org/en/) and utilizes the [Sinatra](http://sinatrarb.com/) web framework.

Due to its web-based nature, it is multi-tenant. This means there are two layers of authentication - creating a user account on my app and then connecting with HMRC via oAuth.

The system's flow is modelled after the 100pcVATFreeBridge product above - inside the user area, you can see a list of VAT returns (both past and present), upload a spreadsheet and allocate data to different boxes of a VAT return.

Whenever a new VAT return is made available, you are able to send the spreadsheet data through the API and receive a response.

To highlight how this works from a code standpoint, I will detail the different elements below: -

<p>-</p>

## 1️⃣ Sinatra

Sinatra is the basis of the application, as it provides an interface between [Rack](https://en.wikipedia.org/wiki/Rack_(web_server_interface)) and Ruby.

It allows us to create a web based experience without having to load Rails, making it efficient and robust.

The entrypoint for a Sinatra app is the `config.ru` file, which, in the case of my app, loads another file called [`./config/autoload.rb`](https://github.com/richpeck/vat-mtd/blob/master/config/autoload.rb).

This calls a number of Sinatra extensions, which aren't overly important. The most important is the interface with [ActiveRecord](https://github.com/sinatra-activerecord/sinatra-activerecord), which allows us to build database-driven applications utilizing [ActiveRecord](https://github.com/rails/rails/tree/main/activerecord) from the Rails core team.

<p>-</p>

## 2️⃣ oAuth

The oAuth system is necessary to connect to HMRC and interact with user accounts.

I have implemented my own version of this, which you can see [here](https://github.com/richpeck/vat-mtd/blob/master/lib/omniauth/strategies/hmrc_vat.rb).

As the authentication with HMRC is handled with oAuth, we are able to take advantage of the various oAuth gems to create a reliable and efficient system.

I'll come back and explain this stuff more specifically when I get the app fully functioning.

<p>-</p>

## 3️⃣ HMRC

A requirement to have an application registered with HMRC is present.

Once this is in place, you are able to accept inbound oAuth requests, ultimately allowing users to grant permission to interface with their HMRC account.

As with the oAuth policy, I will explain this more specifically when it's polished.

<p>-</p>

## 4️⃣ Submit

Finally, to submit the VAT returns, we are simply creating an API payload for the appropriate VAT return.

I'll detail this another time.

---

# ✔️ Contributions

You are welcome to contribute as you wish: -

- Fork the repo and clone it locally
- Make the changes you want/need
- Commit your local repo and push to your remote repository
- Create a PR to bring the new changes into our master branch
- Anyone is welcome to contribute whatever they wish.

Please be aware that we are not responsible for any product/solution which uses the code from this repository. 

---

##### ⚖️ Copyrights/Licenses

Copyrights owned by respective contributors.

This is open source software, distributed under the [MIT license](/richpeck/vat-mtd/blob/master/LICENSE). Provided "as-is" with no warranty.

---

©️ <a href="http://www.frontlineutilities.co.uk" title="Frontline Utilities LTD"><img src="https://i.imgur.com/xwejn02.jpg" align="absmiddle" /></a> <a href="https://www.github.com/richpeck" title="Richard Peck"><img src="https://avatars2.githubusercontent.com/u/1104431?v=3&s=460" height="22" align="absmiddle" /></a>
