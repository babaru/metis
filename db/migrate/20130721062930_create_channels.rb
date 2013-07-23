class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.references :website
      t.string :name

      t.timestamps
    end
    add_index :channels, :website_id
  end
end
