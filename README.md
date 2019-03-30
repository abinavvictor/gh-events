# gh-events

A proof-of-concept web application using the GitHub Events API to display a
given user's recent activity. 

The application uses the [Octokit](https://github.com/octokit/octokit.rb)
client library to access the API.

## Developers

There is one controller,
[`EventsController`](app/controllers/events_controller.rb), and one action,
[`events#index`](app/controllers/events_controller.rb#L5-L19).

Apart from that, and the [`views/events`](app/views/events) directory, most
of `app` is Rails boilerplate that could be cleaned up at some point. The
application is stateless, and has no models.

An npm `package.json` file is present, but only for (optional) SCSS style
checks -- see below under [UI Library](#ui-library).

### Rake

Following Rails 5 conventions, Rake tasks can be run with `rails <task>`
as well as with `bundle exec rake <task>`.

### Testing

Currently, the only tests are the Capybara/Selenium feature specs in
[`spec/features`](spec/features). They can be run with `rails spec` (which
would also run other specs, if there were any) or with `rails
spec:features`.

### Style checks

Code style is checked with RuboCop based on the opinionated configuration in
[`.rubocop.yml`](.rubocop.yml). The checks can be run with `rails rubocop`
(or `rails rubocop:auto_correct` to auto-correct problems where possible),
or with `bundle exec rubocop` (optionally with `-a`).

### UI Library

For quick iteration, static HTML mockups of the `events#index` view can be
found in the [`ui-library`](ui-library) directory, along with SCSS
stylesheets in [`ui-library/scss`](ui-library/scss). The SCSS stylesheets
can be compiled to CSS and to the [`public/stylesheets`](public/stylesheets)
directory with `rails ui:compile`.

If npm is available, `npm install` in the application root directory will
install the `sass-lint` SCSS style checker. The `rails ui:check` task runs
`sass-lint` against the files in `ui-library/scss`, and is a prerequisite
for `rails ui:compile`, but will be skipped if `sass-lint` is not
installed.
