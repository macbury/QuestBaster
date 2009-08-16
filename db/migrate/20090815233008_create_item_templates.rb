class CreateItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :item_templates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :item_templates
  end
end
