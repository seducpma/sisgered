class ClassesdiariosController < ApplicationController

  # before_filter :load_professors
  before_filter :load_classes
  # before_filter :load_alunos
  

 def load_classes
   @ano =   Classe.find(:all,:select => 'distinct(classe_ano_letivo) as ano',:order => 'classe_ano_letivo ASC')
   if current_user.unidade_id == 53 or current_user.unidade_id == 52
        @classe = Classe.find(:all, :joins => "INNER JOIN  unidades  ON  unidades.id = classes.unidade_id",:select => "classes.id, CONCAT(classes.classe_classe, ' - ',unidades.nome) AS classe_classe", :conditions => ['classes.classe_ano_letivo = ? AND classes.sala !=52', Time.now.year  ], :order => 'classes.classe_classe ASC')
    else
        @classe = Classe.find(:all, :conditions => ['unidade_id = ? and classe_ano_letivo = ? ', current_user.unidade_id, Time.now.year  ], :order => 'classe_classe ASC')
        @classe_td =  Classe.find(:all,:select => 'distinct(classe_ano_letivo)',:order => 'classe_ano_letivo ASC')

    end
 end

def diario_classe
   t=0
end

def classe_diario
       session[:classe_id]=params[:classe][:id]
       @classe = Classe.find(:all,:conditions =>['id = ?', params[:classe][:id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', params[:classe][:id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', params[:classe][:id]], :order => 'classe_num ASC')
       render :update do |page|
          page.replace_html 'classe_alunos', :partial => 'alunos_classe'
       end
end

def impressao_diario
       @classe = Classe.find(:all,:conditions =>['id = ?', session[:classe_id]])
       @atribuicao_classe = Atribuicao.find(:all, :joins => :disciplina,:conditions =>['classe_id = ? AND ativo=?', session[:classe_id],0], :order =>'disciplinas.ordem ASC ' )
       @matriculas = Matricula.find(:all,:conditions =>['classe_id = ?', session[:classe_id]], :order => 'classe_num ASC')
       render :layout => "impressao"
end

end
