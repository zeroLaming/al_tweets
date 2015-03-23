
# App status:

The app is up and running on Heroku: https://altweets.herokuapp.com

# Getting the app up and running in dev:

1. Copy config/database.example.yml to configd/databse.yml and insert credentials.
2. ```rake db:create db:migrate```


# Running the tests:

1. ```rspec```

# To deploy:

After getting access to the Heroku project, add the remote:

```heroku git:remote -a altweets```

Then deploy:

```git push heroku master```

```heroku run rake db:migrate```

# Fetching app data:

Data can be pulled from Heroku using the command line tools.

1. ```heroku pg:info```
2. Copy the DATABASE_URL (ie HEROKU_POSTGRESQL_PINK_URL)
3. ```heroku pg:pull HEROKU_POSTGRESQL_PINK_URL $local_database_name```
4. For example: ```heroku pg:pull HEROKU_POSTGRESQL_PINK_URL adaptive_coke_dev```
