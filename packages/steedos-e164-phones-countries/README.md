e164-phones-countries [![Build Status](https://travis-ci.org/geneh/e164-phones-countries.svg?branch=master)](https://travis-ci.org/geneh/e164-phones-countries)
=====================

A small utility which maps E.164 international phone numbers to ISO 3166 country codes as well as the ISO 3166 country codes to country phone codes.

## Motivation
The utility is targeted for a use case such as retrieving [E.164](http://en.wikipedia.org/wiki/E.164) from a web API or sending it back and displaying a list of countries next to a phone number in a browser's drop down.

The existing [Google's libphonenumber](https://code.google.com/p/libphonenumber/) is too big.
This utility was inspired by [e164.js](https://github.com/pdeschen/e164.js). I wanted to use it initially but it did not completely serve my needs.

##Installation
	bower install e164-phones-countries

## Usage
	E164.findIso3166('12010000000'); //Returns US
	E164.findIso3166('12040000000'); //Returns CA
	E164.findPhoneCountryCode('US'); //Returns 1
	E164.findPhoneCountryCode('GB'); //Returns 44
See tests for more examples.

## Useful Links
[E.164](http://en.wikipedia.org/wiki/E.164)

[List of country calling codes](http://en.wikipedia.org/wiki/List_of_country_calling_codes)

[ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1)

[List of North American Numbering Plan area codes](http://en.wikipedia.org/wiki/List_of_North_American_Numbering_Plan_area_codes)
