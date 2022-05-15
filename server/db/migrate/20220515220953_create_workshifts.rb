class CreateWorkshifts < ActiveRecord::Migration[7.0]
  def change
    create_table :workshifts do |t|
      t.datetime :timestamp
      t.references :user, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
