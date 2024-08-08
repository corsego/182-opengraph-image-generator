class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.string :start_date
      t.string :url

      t.timestamps
    end
  end
end
