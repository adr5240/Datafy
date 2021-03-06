require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
    def where(params)
        where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
        values = params.keys.map { |key| params[key] }

        search = <<-SQL
            SELECT
                *
            FROM
                #{self.table_name}
            WHERE
                #{where_line}
        SQL

        results = DBConnection.execute(search, *values)
        parse_all(results)
    end
end
