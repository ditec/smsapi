class SmsCreateTables < ActiveRecord::Migration[5.1]
  def change

    ############################ create table config ############################
    create_table :sms_configs do |t|
      t.string :delivery_method, null: false
      t.text :template, null: false
      t.time :time
      t.integer :cant, default: 0
      t.string :key, null: false

      t.timestamps
    end

    ############################ create table messages ############################
    create_table :sms_messages do |t|
      t.text :text, null: false
      t.string :phone, null: false
      t.datetime :date, null: false
      t.references :config, index: true, null: false
      t.string :status, null: false
      t.text :error

      t.timestamps
    end

    ############################ create table responses ############################
    create_table :sms_responses do |t|
      t.text :text, null: false
      t.references :message, index: true, null: false

      t.timestamps
    end
  end
end
