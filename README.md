[![Maintainability](https://api.codeclimate.com/v1/badges/42ada200dc7fa826a16f/maintainability)](https://codeclimate.com/github/FourSee/rails5_skeleton/maintainability)

* Ruby 2.5.1
* Rails 5.2.2.1
* Postgres and Redis required

# The Birthday Email problem

Forked off a GDPR-compliant Rails 5 skeleton ([readme found here](https://github.com/FourSee/rails5_skeleton))

## Scenario

In production, our `users` table has approximately 250,000 users from all over the world, speaking multiple languages. Each user has a `birthdate`. This field is not encrypted. Each user also has a `locale`, which represents their ISO 639 preferred language.

There is no email provider configured yet, and there's no ActiveJob currently set up.

Not all users want to recieve emails. To determine if a user wants to recieve email, there are some scopes and methods to help:

* `Consent.find_by(key: 'email').users`, to get a list of users who want to get email
* `User.consented_to(Consent.find_by(key: 'email'))`, will also get a list of users who want to get email
* `user.consented_to?(Consent.find_by(key: 'email'))` will return `true` or `false` if a specific user wants to get email

## New feature requirement

We would like to send an email to all users on their birthday. Marketing hasn't written the birthday email copy yet, so placeholder text in the template is fine. It will need to be locale-aware for non-English speaking users.

We also need to only send email to users who want to get email.

Use whatever gems, email providers, ActiveJob adapters, etc. you'd like to enable this feature.