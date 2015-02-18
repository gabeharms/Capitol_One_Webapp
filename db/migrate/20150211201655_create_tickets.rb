class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :customer,        index: true
      t.references :employee,        index: true
      t.references :ticket_category, index: true
      t.references :ticket_status,   index: true
      t.boolean "visible", :default => true 
      t.boolean "created_by_customer"
      t.boolean "ticket_open"
      t.string  "title",   :limit => 50

      t.timestamps null: false
    end
    add_index("tickets", "created_at")
  end 
end