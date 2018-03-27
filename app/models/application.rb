class Application < ActiveRecord::Base
	self.table_name= "applications"
  self.primary_key = "id"

	has_many :user, :foreign_key => 'user_id'
end
