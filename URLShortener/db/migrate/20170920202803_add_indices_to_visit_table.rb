class AddIndicesToVisitTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :visit_tables, :visits 
    add_index :visits, :shortened_url_id, unique: true
  end
end
