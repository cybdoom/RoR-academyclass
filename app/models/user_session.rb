class UserSession < Authlogic::Session::Base

	def as_json(options = nil)
		valid? ? {:name => record.name_or_username} : {:errors => errors}
	end
end
