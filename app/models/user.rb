class User < ActiveRecord::Base
  has_secure_password

  has_many :access_tokens
  has_many :authorizations

  has_many :connected_applications, -> {
    joins(:authorizations).where(:authorizations => { :active => true }).uniq
  }, :through => :authorizations, :class_name => "ClientApplication", :source => :client_application

  def disable_application!(client_application_id)
    authorizations.where(:client_application_id => client_application_id).
      update_all(:active => false)
  end
end
