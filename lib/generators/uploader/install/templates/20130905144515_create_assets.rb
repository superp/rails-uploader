class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string  :data_file_name, null: false
      t.string  :data_content_type
      t.integer :data_file_size

      t.integer :assetable_id, null: false
      t.string  :assetable_type, limit: 30, null: false
      t.string  :type, limit: 30

      t.string  :guid, limit: 30
      t.string  :public_token, limit: 30

      t.integer :user_id
      t.integer :sort_order, default: 0
      t.integer :width
      t.integer :height

      t.timestamps
    end

    add_index :assets, [:assetable_type, :type, :assetable_id]
    add_index :assets, :user_id
    add_index :assets, :guid
    add_index :assets, :public_token
  end

  def self.down
    drop_table :assets
  end
end
