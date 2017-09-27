class AulasEventual < ActiveRecord::Base
  belongs_to :eventual
  belongs_to :unidade
  belongs_to :classe
end
