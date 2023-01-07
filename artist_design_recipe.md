# Artists Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | genre
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Tash', 'R&B');
INSERT INTO artists (name, genre) VALUES ('C.Tangana', 'Hip-hop');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: artists

# Model class
# (in lib/artist.rb)
class Artist
end

# Repository class
# (in lib/artist_repository.rb)
class ArtistRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class Student

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :genre
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: artists

# Repository class
# (in lib/artist_repository.rb)

class ArtistsRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists;

    # Returns an array of Student objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students WHERE id = $1;

    # Returns a single Artist object.
  end

# insert new artist. takes an Artist object in argument
  def create(artist)
  #Execute the SQL query:
  #INSERT INTO artists (name. genre) VALUES ($1, $2);

  # doesn't need to return anything 
  end 

  # deletes an artist record 
  #given its id
  def delete(id)
  #DELETE FROM artists WHERE id = $1;

  #returns nothing (only deletes the record)
  end


  #updates an artist record
  #takes an Artist object (with updated fields)
  def update(artist)
  #Executes SQL query :
  #UPDATE artists SET name = $1, genre = $2 WHERE id = $3;

  #returns nothind ( only ipdates the record)
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all artists

repo = ArtistRepository.new

artists = repo.all
artists.length #=>2
artists.first.id # => '1'
artists.first.name #=> 'Tash'

# create a new artist 
repo = ArtistRepository.new

artist = Artist.new
artist.name = "Beatles"
artist.genre = "Pop"

repo.create(artist) #=> nil
artist = repo.all

last_artist = artist.last
last_artist.name #=> 'Beatles'
last_artist.genre #=> 'Pop'

#
repo = ArtistRepository.new

id_to_delete = 1
repo.delete(id_to_delete)

all_artists = repo.all
all_artists.length # => 1
all_artists.first.id # => '2'

#
repo = ArtistRepository.new

artist = repo.find(1)

artist.name = 'lalala'
artist.genre = 'blabla'

repo.update(artist)

updated_artist = repo.find(1)
updated_artist.name # => 'lalala'
updated_artist.genre # => 'blabla'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/artist_repository_spec.rb

def reset_artists_table
  seed_sql = File.read('spec/seeds_artists.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

