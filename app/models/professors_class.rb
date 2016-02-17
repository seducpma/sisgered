class ProfessorsClass < ActiveRecord::Base
  belongs_to :classe_id
  belongs_to :professor_id
end
