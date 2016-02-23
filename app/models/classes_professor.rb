class ClassesProfessor < ActiveRecord::Base
  belongs_to :classe, :dependent => :destroy
  belongs_to :professor, :dependent => :destroy
end
