require_relative 'lib/sql_object'
# require 'dragons.db'
# require 'dragons.sql'

DEMO_DB_FILE = 'dragons.db'
DEMO_SQL_FILE = 'dragons.sql'

# SCHEMA
# Dragon
# Columns: 'id', 'name', 'owner_id'
#
# Targaryen
# Columns: 'id', 'fname', 'lname', 'rival_id'
#
# Rival
# Columns: 'id', 'house'

`rm '#{DEMO_DB_FILE}'`
`dragon '#{DEMO_SQL_FILE}' | sqlite3 '#{DEMO_DB_FILE}'`

DBConnection.open(DEMO_DB_FILE)

class Dragon < SQLObject
  belongs_to :targaryen, foreign_key: :owner_id
  has_one_through :rival, :targaryen, :rival

  finalize!
end

class Targaryen < SQLObject
  self.table_name = "targaryens"
  has_many :dragons, foreign_key: :owner_id
  belongs_to :rival

  finalize!
end

class Rival < SQLObject
  has_many :targaryens,
    class_name: "Targaryen",
    foreign_key: :rival_id,
    primary_key: :id

  finalize!
end
