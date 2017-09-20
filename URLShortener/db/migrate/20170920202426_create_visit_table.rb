class CreateVisitTable < ActiveRecord::Migration[5.1]
  def change
    create_table :visit_tables do |t|
      t.integer :user_id, null: false
      t.integer :shortened_url_id, null: false
      t.timestamps 
    end
  end
end
