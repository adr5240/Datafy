# Datafy

## Summary

A lightweight Object-Relational Mapping (ORM) library for Ruby based on Rails's
ActiveRecord.

Perform database operations in an object-oriented fashion while maintaining
readability and DRYness of your code.

## Features

- Intuitive API for ease-of-use.
- Implements similar core functionality of ActiveRecord::Base
- Provides logical syntax and follows Ruby conventions.
- Follows the well-loved 'convention over configuration' mantra for naming
when setting associations. e.g Will search schema for "houses" table if "House"
class.
- Allows simple override of naming convention.

##Demo

1. Clone the repo
2. cd into Datafy (or Datafy-master if saved as such)
3. sqlite3 dragons.db < dragons.sql
4. sqlite3 dragons.db
5. Open a new terminal window, then load `irb` or `pry`
6. Run `load 'demo.rb'`
7. Use API below

## API

SQLObject provides similar core ActiveRecord associations:

- `has_many`
- `belongs_to`
- `has_one_through`

SQLObject provides similar core ActiveRecord methods:

- `::first`
- Finds first table item
    - Targaryen.first == "Aegon Targaryen" (only name shown here)
- `::last`
- Finds last table item
    - Dragon.last == "Stray Dragon" (only name shown here)
- `::find`
- Finds item with given id
    - Dragon.find(3).name == "Balerion"
- `::where`
- Finds all items with given criteria
    - Targaryen.where(lname: "Targaryen") == list of three Targaryens
- `::all`
- Finds all items
- `::parse_all`
- Take in an array and turns all items into table objects
- `::columns`
- Prints out a list of columns from given table
- `#save`
- Saves changes that are made to table item
- `#insert`
- Used by #save, inserts new item into end of table
- `#update`
- Used by #save, updates item if it exists

## Libraries

- SQLite3 (gem)
- ActiveSupport::Inflector

### Insert/Update
![insert:update](./images/Insert:Update.png?raw=true)

### Has Many Options (default values)
![has_many_options](./images/has_many_options.png?raw=true)

### Has One Through
![has_one_through](./images/has_one_through.png?raw=true)


## How It Works

A user provides a database file path to DBConnection, which accesses the database
through the SQLite3 gem. This is done through DBConnection::open(db_file_name)
which instantiates a singleton of SQLite3::Database.

DBConnection uses native SQLite3::Database methods as `#execute`, `#execute2`,
and `#last_insert_row_id` to allow Orb to perform SQL queries in the
form of heredocs.

SQLObject gives the user a plethora of ActiveRecord methods and association
methods which maps to SQL queries. The Associatable module extends SQLObject to
allow for associations such as `has_many`, `belongs_to`, `has_one_through` to be
made. These associations provide sensible default class_name, foreign_key, and
primary_key values if not provided by user.
