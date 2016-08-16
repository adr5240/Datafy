require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_primary = through_options.primary_key
      through_foreign = through_options.foreign_key

      source_table = source_options.table_name
      source_primary = source_options.primary_key
      source_foreign = source_options.foreign_key

      value = self.send(through_options.foreign_key)

      query = <<-SQL
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
        ON
          #{through_table}.#{source_foreign} = #{source_table}.#{source_primary}
        WHERE
          #{through_table}.#{through_primary} = ?
      SQL

      results = DBConnection.execute(query, value)

      source_options.model_class.parse_all(results).first
    end
  end
end
