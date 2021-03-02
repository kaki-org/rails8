class AddPublisherIdToBooks < ActiveRecord::Migration[6.1]
  def change
    add_reference :books, :publisher, null: false, foreign_key: true
    # change_column :books, :publisher_id, :integer, null: false # SQLiteの時はここを変更しておかないと駄目
  end
end
