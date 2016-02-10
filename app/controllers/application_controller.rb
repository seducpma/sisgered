# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  
  
  
   before_filter :set_current_user

    def set_current_user
      User.current = current_user
    end




  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private

  def current_classe
    if current_user.unidade_id == 53
      @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ?", Date.today.strftime("%Y").to_i], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
    else
      @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ? and id_escola = ?", Date.today.strftime("%Y").to_i, current_user.unidade.unidades_gpd_id], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
    end

  end

  def current_cart
    @current_cart ||= Cart.first(:conditions => ["user_id = ?", current_user]) || Cart.create(:user_id => current_user.id)
  end

end

PESSOA = { 'ALUNO'=> 'ALUNO',
           'PAI'=> 'PAI',
           'MÃE'=> 'MÃE',
           'AVÔ' => 'AVÔ',
           'AVÓ' => 'AVÓ',
           'RESPONSÁVEL'=> 'RESPONSÁVEL',
           'ENTEADO(A)'=> 'ENTEADO(A)',
           'OUTROS' => 'OUTROS'
        }
RESIDECOM = {'PAI'=> 'PAI',
           'MÃE'=> 'MAE',
           'PAIS'=> 'PAIS',
           'RESPONSÁVEL'=> 'RESPONSAVEL',
        }
PARENTE = {'MADRASTA'=>'MADRASTA',
           'PADRASTO'=>'PADRASTO',
            'AVÔ' => 'AVÔ',
           'AVÓ' => 'AVÓ',
           'TIO(A)'=> 'TIO(A)',
           'ENTEADO(A)'=> 'ENTEADO(A)',
           'OUTROS' => 'OUTROS'
        }


PROFISSAO = { 'DESEMPREGADO'=> 'DESEMPREGADO',
              'AUTÔNOMO'=> 'AUTÔNOMO',
              'CARTEIRA ASSINADA'=> 'CARTEIRA ASSINADA',
              'APOSENTADO' => 'APOSENTADO',
              'ESTUDANTE'=>'ESTUDANTE',
              'EMPRESÁRIO'=>'EMPRESÁRIO',
              'DO LAR' =>'DO LAR',
              'AUTROS' => 'OUTROS'
        }

SEXO = { 'MASCULINO'=> 'MASCULINO',
         'FEMININO' => 'FEMININO'

        }

CIVIL = { 'Solteiro'=> 'Solteiro',
          'Casado' => 'Casado',
          'Divorciado'=>'Divorciado',
          'Separado'=>'Separado',
          'União_Estável' =>'União_Estável'
        }

ESCOLARIDADE = { 'Analfabeto'=> 'Analfabeto',
                 'Semi_Analfabero' => 'Semi_Analfabero',
                 'Fundamental (completo)'=>'Fundamental (completo)',
                 'Fundamental (incompleto)'=> 'Fundamental (incompleto)',
                 'Ensino_Médio (completo' => 'Ensino_Médio (completo)',
                 'Ensino_Médio (incompleto)' => 'Ensino_Médio (incompleto)',
                 'Superior (completo)'=>'Superior(completo)',
                 'Superior (incompleto)'=>'Superior (incompleto)',
                 'Pós-graduação (completo)'=> 'Pós-graduação (completo)',
                 'Pós-graduação (incompleto)' => 'Pós-graduação (incompleto)'
               }

        
CARGO = {'Diretor Ed. Básica'=> 'Diretor Ed. Básica',
          'Prof. Coordenador'=>'Prof. Coordenador',
          'Pedagogo'=> 'Pedagogo',
          'ADI'=>'ADI',
          'Prof. de Creche'=>'Prof. de Creche',
          'PEB1 - Ed. Infantil'=> 'PEB1 - Ed. Infantil',
          'PEB1 - Ensino Fundamental'=> 'PEB1 - Ensino Fundamental',
          'PEB2 - Artes'=> 'PEB2 - Artes',
          'PEB2 - Ed. Física'=> 'PEB2 - Ed. Física',
          'PEB2 - História'=> 'PEB2 - História',
          'PEB2 - Geografia'=> 'PEB2 - Geografia',
          'PEB2 - Matemática'=> 'PEB2 - Matemática',
          'PEB2 - Português'=> 'PEB2 - Português',
          'PEB2 - Inglês'=> 'PEB2 - Inglês',
          'PEB2 - Ciências'=> 'PEB2 - Ciências',
          'PEB - Ed. Especial'=> 'PEB - Ed. Especial',
          'TODOS' => 'TODOS'
          }

GRAU = { 'Pai/Mãe'=> 'Pai/Mãe',
         'Irmão(ã)' => 'Irmão(ã)',
         'Avô/Avó' => 'Avô/Avó',
         'Tio/Tia'=> 'Tio/Tia',
         'Enteado(a)'=> 'Enteado(a)',
         'Primo(a)'=> 'Primo(a)',
         'Outros' => 'Outros'
        }

OPCAO ={ 'SIM '=>'SIM',
         'NÃO'=> 'NÃO'
        }


PARTO ={ 'NORMAL '=>'NORMAL',
         'CEZARIANA'=> 'CEZARIANA',
         'FORCEPS' => 'FORCEPS',
         'A TERMO' => 'A TERMO',
         'PREMATURO'=> 'PREMATURO'
        }

SONO ={ 'TRANQUILO '=>'TRANQUILO',
         'AGITADO'=> 'AGITADO',
         'INSONIA' => 'INSONIA',
         'SONAMBOLISMO'=> 'SONAMBOLISMO'
        }

ALIMENTO ={ 'NORMAL'=>'NORMAL',
         'LEITE MATERNO'=> 'LEITE MATERNO',
         'ALIMENTA_SE BEM'=>'ALIMENTA_SE BEM',
         'INTOLERANCIA ALIMENTAR' => 'INTOLERANCIA ALIMENTAR'
        }

SANGUE ={ 'O+'=>'O+',
          'O-'=>'O-',
          'A+'=>'A+',
          'A-'=>'A-',
          'B+'=>'B+',
          'B-'=>'B-',
          'AB+'=>'AB+',
          'AB-'=>'AB-'
        }

HABILIDADE ={ 'CANHOTO'=>'CANHOTO',
          'DESTREO'=>'DESTRO',
          'AMBIDESTRO'=>'AMBITESTRO',
          'NÃO ALFABETIZADO'=>'NÃO ALFABETIZADO'
        }

CASA ={ 'PRÓPRIA'=>'PRÓPRIA',
        'ALUGADA'=>'ALUGADA',
        'EMPRESTADA'=>'EMPRESTADA',
        'EM CONSTRUÇÂO' => 'EM CONSTRUÇÂO',
       }

CASATIPO ={ 'ALVENARIA'=>'ALVENARIA',
            'MADEIRA'=>'MADEIRA',
            'OUTRO MATERIAL'=>'OUTRO MATERIAL'
           }

ELETRICIDADE ={ 'REDE PÚBLICA'=> 'REDE PÙBLICA',
                'GERADOR PRÓPRIO'=>'GERADOR PRÒPRIO',
                'NÃO TEM'=> 'NÂO TEM'
              }

ESGOTO ={ 'REDE PÙBLICA' => 'REDE PÚBLICA',
          'FOSSA'=> 'FOSSA',
         'NÃO TEM'=> 'NÂO TEM'
         }

AGUA ={ 'REDE PÙBLICA' => 'REDE PÚBLICA',
        'POÇO ARTESIANO'=> 'POÇO ARTESIANO',
         'NÃO TEM'=> 'NÂO TEM'
         }

TIPOUNIDADE ={ "CAIC" =>"1",
               "CASA DA CRIANCA" =>"2",
               "EDUCAÇÂO ESPECIAL"  =>"3",
               "CIEP" => "4",
               "CRECHE" =>"5",
               "EMEF" =>"6",
               "EMEI" =>"7",
               "SEDUC" =>"8",
               "ITINERANCIA" =>"9"
               }

RELIGIAO = { "CATÓLICO ROMANO" => "CATÓLICO ROMANO",
             "ADVENTISTA" => "ADVESNTISTA",
             "PENTECOSTAL" => "PENTECOSTAL",
             "ESPIRITA" => "ESPIRITUA",
             "RITUAIS AFROBASILEIROS" => "RITUAIS AFROBASILEIROS",
             "ESPIRITISMO" => "ESPIRITISMO",
             "RITUAIS INDIGENAS" => "RITUAIS INDIGINAS",
             "PRESBITERIANO"=> "PRESBITERIANO",
             "BATISTA" => "BATISTA",
             "NEOPENTECONSTAL"=>"NEOPENTECOSTAL",
             "ASSSEMBLEIA DE DEUS" => "ASSEMBLEIA DE DEUS",
             "CONGREGAÇÂO CRISTÂ" => "CONGRAGAÇÂO CRISTÃ",
             "EVANGELICA TRADICONAL"=> "EVANGELIZA TRADICONAL",
             "EVANGELICA PENSTESCOSTAL"=> "EVANGELICA PENSTECOSTAL",
             "METODISTA"=> "METODISTA"

}