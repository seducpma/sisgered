class DisciplinasController < ApplicationController

    def new_disciplinanota

    end


    def create_discipina_nota

        @disciplina = Disciplina.new(params[:disciplina])
        @disciplina.disciplina=params[:NovaDisciplina]
        @disciplina.curriculo=params[:NovoCurriculo]
        @disciplina.ano_letivo=params[:NovoAnoLetivo]
        @disciplina.tipo_un = 3
        if params[:NovoCurriculo] == 'BÁSICO'
            @disciplina.curriculo = 'B'
            @contador = Disciplina.find(:all, :conditions => ['curriculo = "B"'], :order => 'ordem ASC')
            for contador in @contador
                @disciplina.ordem=(contador.ordem)+1
            end
        else if params[:NovoCurriculo] == 'DIVERSIFICADO'
                @disciplina.curriculo = 'D'
                @contador = Disciplina.find(:all, :conditions => ['curriculo = "B"'], :order => 'ordem ASC')
                for contador in @contador
                    @disciplina.ordem=(contador.ordem)+1
                end
            end
        end

        @nota = Nota.new(params[:nota])
        @nota.aluno_id=session[:aluno_id]
        @nota.nota5 = params[:NovaNota]
        @nota.escola = params[:NovaEscola]
        @nota.cidade = params[:NovaCidade]
        @nota.classe = params[:NovaClasse]
        @nota.ano_letivo = params[:NovoAnoLetivo]

        if @disciplina.save
           @nota.disciplina_id = @disciplina.id
            if  @nota.save
                t=0

                respond_to do |format|
                    t=0
 #                   format.html { redirect_to(@disciplina) }
 #                   format.xml  { render :xml => @disciplina, :status => :created, :location => @disciplina }
  format.html { redirect_to(teste_path) }
                end
                #respond_to do |format|
                    #format.html { redirect_to(historicoContinua_path) }
                    #format.xml  { head :ok }
                #format.html { redirect_to(@disciplina) }
                #format.xml  { render :xml => @disciplina, :status => :created, :location => @disciplina }

               # end
            end
        end

    end

    def teste
            t=0
    end

    def index
        @disciplinas = Disciplina.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @disciplinas }
        end
    end

    def show

        @disciplina = Disciplina.find(params[:id])
        @nota = Nota.find(:all, :conditions => ['disciplina_id = ?',@disciplina.id])
        session[:aluno_id]=  @nota[0].aluno_id
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @disciplina }
        end
    end




    def new
        @ano_letivo=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        @serie=[1,2,3,4,5,6,7,8,9]
        @NOTASH=["SN","10.0","9.5","9.0","8.5","8.0","7.5","7.0","6.5","6.0","5.5","5.0","4.5","4.0","3.5","3.0","2.5","2.0","1.5","1.0","0.5","0.0","A","B","C","D","E","TR","RM","F","NF","ABN"]

        for i in 0..14
            @ano_letivo[i]=Time.now.year.to_i-(15-i)
        end

        @disciplina = Disciplina.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @disciplina }
        end
    end

    def edit
        @disciplina = Disciplina.find(params[:id])
    end


    def create
        @disciplina = Disciplina.new(params[:disciplina])
        @disciplina.disciplina=params[:NovaDisciplina]
        @disciplina.curriculo=params[:NovoCurriculo]
        @disciplina.ano_letivo=params[:NovoAnoLetivo]
        @disciplina.tipo_un = 3
        if params[:NovoCurriculo] == 'BÁSICO'
            @disciplina.curriculo = 'B'
            @contador = Disciplina.find(:all, :conditions => ['curriculo = "B"'], :order => 'ordem ASC')
            for contador in @contador
                @disciplina.ordem=(contador.ordem)+1
            end
        else if params[:NovoCurriculo] == 'DIVERSIFICADO'
                @disciplina.curriculo = 'D'
                @contador = Disciplina.find(:all, :conditions => ['curriculo = "B"'], :order => 'ordem ASC')
                for contador in @contador
                    @disciplina.ordem=(contador.ordem)+1
                end
            end
        end

        @nota = Nota.new(params[:nota])
        @nota.aluno_id=session[:aluno_id]
        @nota.nota5 = params[:NovaNota]
        @nota.escola = params[:NovaEscola]
        @nota.cidade = params[:NovaCidade]
        @nota.classe = params[:NovaClasse]
        @nota.ano_letivo = params[:NovoAnoLetivo]


        respond_to do |format|
            if @disciplina.save
                @nota.disciplina_id = @disciplina.id
                @nota.save
                flash[:notice] = 'Disciplina was successfully created.'
                format.html { redirect_to(@disciplina) }
                format.xml  { render :xml => @disciplina, :status => :created, :location => @disciplina }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @disciplina.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @disciplina = Disciplina.find(params[:id])

        respond_to do |format|
            if @disciplina.update_attributes(params[:disciplina])
                flash[:notice] = 'Disciplina was successfully updated.'
                format.html { redirect_to(@disciplina) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @disciplina.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @disciplina = Disciplina.find(params[:id])
        @disciplina.destroy

        respond_to do |format|
            format.html { redirect_to(disciplinas_url) }
            format.xml  { head :ok }
        end
    end
end
