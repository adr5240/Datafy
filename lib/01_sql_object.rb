require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    return @columns if @columns

    query = <<-SQL
      SELECT *
      FROM "#{table_name}"
    SQL
    @columns = DBConnection.execute2(query).first
    @columns.map! { |el| el.to_sym }
  end

  def self.finalize!
    columns = self.columns
    columns.each do |col|

      define_method(col) do
        attributes[col]
      end

      define_method("#{col}=") do |val|
        attributes[col] = val
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.downcase + 's'
  end

  def self.all
    query = <<-SQL
      SELECT *
      FROM "#{table_name}"
    SQL

    hash_objects = DBConnection.execute(query)
    self.parse_all(hash_objects)
  end

  def self.parse_all(results)
    new_obj = []

    results.each do |hash|
      new_obj << self.new(hash)
    end

    new_obj
  end

  def self.find(id)
    all_objects = self.all
    all_objects.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    attr = self.class.columns
    params.each do |key, value|
      raise "unknown attribute '#{key.to_sym}'" unless attr.include?(key.to_sym)
      send("#{key.to_sym}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| self.send(attr) }
  end

  def insert
    col_name = self.class.columns.dup
    question_marks = (["?"] * (col_name.length)).join(',')

    query = <<-SQL
      INSERT INTO #{self.class.table_name} (#{col_name.join(', ')})
      VALUES (#{question_marks})
    SQL

    DBConnection.execute(query, attribute_values)
    self.id = DBConnection.last_insert_row_id

  end

  def update
    set_line = self.class.columns.map { |attr_name| "#{attr_name} = ?"}

    query = <<-SQL
      UPDATE #{self.class.table_name}
      SET #{set_line.join(', ')}
      WHERE id = #{self.id}
    SQL

    DBConnection.execute(query, attribute_values)
  end

  def save
    self.class.find(self.id) ? self.update : self.insert
  end

end
