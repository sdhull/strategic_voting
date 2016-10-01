# MakeMineCount
An app to facilitate vote swapping to strategically keep Donald Trump out of the White House while boosting the number of 3rd party votes.

## Contribution guidelines
1. Fork the project.
2. Create a feature or bugfix branch.
3. Submit a Pull Request.

## Running
Note that Postgres is required
```bash
bundle install
bundle exec rake db:setup db:migrate
bundle exec rake assets:precompile
bundle exec rails server
```