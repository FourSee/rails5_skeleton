[![Maintainability](https://api.codeclimate.com/v1/badges/42ada200dc7fa826a16f/maintainability)](https://codeclimate.com/github/FourSee/rails5_skeleton/maintainability)

# A skeleton GDPR-compliant Rails 5.2/Ruby 2.5.1 application

Runs on PostgreSQL 9.6 because I fucking love that database.

Users can't actually log in yet, because no devise. Haven't decided if I want it yet. Knock is better for pure APIs, anyway.


### Current features:

* Per-row encryption available on any model that has a `user`
* Fields are individually encryptable
* Encrypted fields are virtual attributes (eg: `encrypted_email` is available as `email`)
* Encryption keys are stored in Redis, and deleted when the `user` is destroyed. This renders all personal data unrecoverable
* User emails are case-insensitively unique via peppered RIPEMD one-way-hash, making the validation O(1) instead of O(n), where n is the number of user records. Also, peppering makes Googling the hash useless
* Actions on users can be gated via the users `consents` EG: `Consent.find_by(key: 'email').users` gives a list of all users that have consented to recieve email
* Consent can be expired by flagging the `user_consent.up_to_date` as `false`
* `user.consents` and `consent.users` are scope-filtered by being `up_to_date` and `consented` (ie: if user hasn't revoked consent)
* `User.consented_to(consent)` scope, hopefully with efficient DB indexes
* `user.consented_to?(consent)` method
* `User.emails` class accessor, for efficient email fetching (repeatable pattern for other encrypted attributes)
* Has an easy user-owned data export feature via `user.export_personal_information`, which goes through every model that has a `user_id` and returns not-false for `self.personal_information`. Each model is responsible for returning a hash of attributes considered `personal_information`

### OMG LOSING THE DECRYPTION KEY MEANS PERMANENT DATA LOSS

Yes, deleting the user's decryption key from redis means permanent data loss. That's the whole point of the GDPR "right-to-be-forgotten" clause.

To prevent accidental data loss, Redis should be persisted & snapshotted regularly. User data is still recoverable as long as a snapsot exists. As such, snapshots should be kept for 30 days, then `shred`ed.  

### Non-GDPR features:

* I18n on model attributes via the `json_translate` gem (see `Consent` model for example)


### TODO:
* Database indexes need a lot of love
