class CreateTableReferral < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals do |t|
      t.string :email, null: false
      t.integer :status
      t.integer :resend_count

      t.timestamps
    end

    add_index :referrals, :email, unique: true
    add_reference :referrals, :user, foreign_key: true, index: true
  end
end
