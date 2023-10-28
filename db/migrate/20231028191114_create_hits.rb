class CreateHits < ActiveRecord::Migration[7.1]
  def change
    create_table :hits do |t|
      t.references :user
      t.string :endpoint, null: false

      t.timestamps
    end
  end
end
