def delete_all(tables)
  tables.each do |table|
    BookingForm.connection.execute "DELETE FROM #{table}"
  end
end