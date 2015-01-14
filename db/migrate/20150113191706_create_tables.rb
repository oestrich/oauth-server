class CreateTables < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :client_applications, :id => :uuid do |t|
      t.string :name
      t.text :redirect_uri, :null => false
      t.uuid :client_id, :null => false
      t.uuid :client_secret, :null => false

      t.timestamps
    end

    create_table :authorizations, :id => :uuid do |t|
      t.uuid :client_application_id
      t.uuid :user_id
      t.text :state
      t.text :redirect_uri, :null => false
      t.text :scopes, :array => true
      t.uuid :code, :null => false
      t.boolean :active, :null => false

      t.timestamps
    end

    create_table :access_tokens, :id => :uuid do |t|
      t.uuid :authorization_id
      t.uuid :access_token, :null => false
      t.uuid :refresh_token, :null => false
      t.boolean :active, :null => false
      t.integer :expires_in, :null => false

      t.timestamps
    end

    create_table :users, :id => :uuid do |t|
      t.string :email, :null => false
      t.text :password_digest, :null => false

      t.timestamps
    end
  end
end
