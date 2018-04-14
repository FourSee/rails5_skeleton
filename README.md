# A skeleton GDPR-compliant Rails 5.2/Ruby 2.5.1 application

Runs on PostgreSQL 9.6 because I fucking love that database.

Users can't actually log in yet, because no devise. Haven't decided if I want it yet. Knock is better for pure APIs, anyway.


### Current features:

* Per-row encryption available on any model that has a `user`
* Fields are individually encryptable
* Encrypted fields are virtual attributes (eg: `encrypted_email` is available as `email`)
* Encryption keys are stored in Redis, and deleted when the `user` is destroyed. This renders all personal data unrecoverable
* User emails are case-insensitively unique via peppered RIPEMD one-hash, making the validation O(1) instead of O(n), where n is the number of user records
* Actions on users can be gated via the users `consents` EG: `Consent.find_by(key: 'email').users` gives a list of all users that have consented to recieve email
* Consent can be expired by flagging the `user_consent.up_to_date` as `false`
* `user.consents` and `consent.users` are scope-filtered by being `up_to_date` and `consented` (ie: if user hasn't revoked consent)
* Has an easy user-owned data export feature via `user.export_personal_information`, which goes through every model that has a `user_id` and returns not-false for `self.personal_information`. Each model is responsible for returning a hash of attributes considered `personal_information`

### Non-GDPR features:

* I18n on model attributes via the `globalize` gem (see `Consent` model for example) - uses a 5.2 compatible fork until `globalize` updates their gemspec


### TODO:
* automatically expire `user_consents` when the `consent` is updated
* add a `consented_to?(key)` method on user for easy function gating