# frozen_string_literal: true

class CreateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :snapshots do |t|
      t.string :image_url, null: false
      t.string :token, null: false
      t.timestamps
    end
  end
end
