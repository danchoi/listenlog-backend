class CreateDemoDatas < ActiveRecord::Migration
  def self.up
    create_table :demo_datas do |t|
      t.string :udid
      t.text :payload

      t.timestamps
    end
  end

  def self.down
    drop_table :demo_datas
  end
end
