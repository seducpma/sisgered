class AulasFalta < ActiveRecord::Base
  belongs_to :professor
  belongs_to :funcionario
  belongs_to :unidade
end
