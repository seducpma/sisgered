class ConsultasController < ApplicationController
before_filter :sede_unidade

layout :define_layout
helper_method :sort_column, :sort_direction
  def define_layout
      current_user.layout
  end

  def index
  end


  def search
  end


private

 protected
  def sede_unidade
    if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
      #@unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)',:joins => "inner join professors on professors.sede_id = unidades.id",  :conditions=> ["professors.desligado = 0"], :order => 'nome ASC')
      @unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)',:order => 'nome ASC')
    else
      #@unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)',:joins => "inner join professors on professors.sede_id = unidades.id",  :conditions=> ["professors.desligado = 0 and (professors.sede_id = ? or sede_id = 54)", current_user.unidade_id ], :order => 'nome ASC')
      @unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)', :order => 'nome ASC')
      
    end
  end

  

end
