class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string   "data_file_name",                                 :null => false
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.integer  "assetable_id",                                   :null => false
      t.string   "assetable_type",    :limit => 25,                :null => false
      t.string   "type",              :limit => 25
      t.string   "guid",              :limit => 20
      t.string   "public_token",      :limit => 20
      t.integer  "user_id"
    
      t.timestamps
    end
    
    add_index "assets", ["assetable_type", "assetable_id"]
    add_index "assets", ["user_id"]
    add_index "assets", ["public_token"]
  end
end
