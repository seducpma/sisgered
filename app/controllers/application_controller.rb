
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

   before_filter :set_current_user

   ## LEMBRETE <++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   #  para liberar notas bimestre è necessàrio:
   #    1) ALTERAR  atribuicaos - edit
   #    2) ALTERAR  notas - edit
   #    3) ALTERAR  notas - lacamentos miltiplos

   # verificar tabém a questão de FALTAS NULL pois ocorre erro se totalização das faltas qdo. houver faltas NULL


    def set_current_user
      User.current = current_user
    end
  private

 # def current_classe
 #   if current_user.unidade_id == 53
 #     @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ?", Date.today.strftime("%Y").to_i], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
 #   else
 #     @classes = Aluno.all(:select => "id_classe, classe_descricao, classe_ano, id_escola",:conditions => ["classe_ano = ? and id_escola = ?", Date.today.strftime("%Y").to_i, current_user.unidade.unidades_gpd_id], :group => ["id_classe,classe_descricao, classe_ano,id_escola"] , :order => "classe_descricao")
 #   end

 # end

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
         'CESARIANA'=> 'CESARIANA',
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
          'DESTRO'=>'DESTRO',
          'AMBIDESTRO'=>'AMBITESTRO',
          'NÃO ALFABETIZADO'=>'NÃO ALFABETIZADO'
        }

CASA ={ 'PRÓPRIA'=>'PRÓPRIA',
        'ALUGADA'=>'ALUGADA',
        'EMPRESTADA'=>'EMPRESTADA',
        'EM CONSTRUÇÃO' => 'EM CONSTRUÇÃO',
       }

CASATIPO ={ 'ALVENARIA'=>'ALVENARIA',
            'MADEIRA'=>'MADEIRA',
            'OUTRO MATERIAL'=>'OUTRO MATERIAL'
           }

ELETRICIDADE ={ 'REDE PÚBLICA'=> 'REDE PÙBLICA',
                'GERADOR PRÓPRIO'=>'GERADOR PRÒPRIO',
                'NÃO TEM'=> 'NÃO TEM'
              }

ESGOTO ={ 'REDE PÙBLICA' => 'REDE PÚBLICA',
          'FOSSA'=> 'FOSSA',
         'NÃO TEM'=> 'NÃO TEM'
         }

AGUA ={ 'REDE PÙBLICA' => 'REDE PÚBLICA',
        'POÇO ARTESIANO'=> 'POÇO ARTESIANO',
         'NÃO TEM'=> 'NÃO TEM'
         }

TIPOUNIDADE ={ "CAIC" =>"1",
               "CASA DA CRIANCA" =>"2",
               "EDUCAÇÃO ESPECIAL"  =>"3",
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
             "NEOPENTECOSTAL"=>"NEOPENTECOSTAL",
             "ASSSEMBLEIA DE DEUS" => "ASSEMBLEIA DE DEUS",
             "CONGREGAÇÃO CRISTÃ" => "CONGRAGAÇÃO CRISTÃ",
             "EVANGELICA TRADICONAL"=> "EVANGÉLICA TRADICONAL",
             "EVANGELICA PENTECOSTAL"=> "EVANGÉLICA PENTECOSTAL",
             "METODISTA"=> "METODISTA"
}

TURMA ={ "1" =>"1",
         "2" =>"2",
         "3"  =>"3",
         "4" => "4",
         "5" =>"5",
         "6" =>"6",
         "7" =>"7",
         "8" =>"8",
         "9" =>"9"
        }


ANO   ={ "2016" =>"2016",
         "2015" =>"2015",
         "2014" =>"2014",
         "2013"  =>"2013",
         "2012" => "2012",
         "2011" =>"2011",
         "2010" =>"2010",
         "2009" =>"2009",
         "2008" =>"2008",
         "2007" =>"2007",
         "2006" =>"2006",
         "2005" =>"2005",

        }
# Acrescentei o ano de "2016" e não retirei o "2007" ###Alex


CURRICULO={ 'B '=>'BASICO',
            'D'=> 'DIVERSIFICADO'
          }

NUM = { '  1'=> '1',
           '2'=> '2',
           '3'=> '3',
           '4' => '4',
           '5' => '5',
           '6'=> '6',
           '7'=> '7',
           '8' => '8',
           '9' => '9',
           'AEE'=>'AEE',
           'EJA'=>'EJA',
        }

NUMI = {  '--Selecionar--'=>'',
       'AEE'=> 'AEE',
       'BI'=> 'BI',
       'BII'=> 'BII',
       'MI'=> 'MI',
       'MII' => 'MII',
       'NI'=> 'NI',
       'NII'=> 'NII',
       'PA'=> 'PA',
       'BA(multis.)'=> 'BA',
       'BB(multis.)'=> 'BB',
       'BM(multis.)'=> 'BM',
       'MM(multis.)'=> 'MM',
       'MU(multis.)'=> 'MU',
       'PR(multis.)'=> 'PR',
       }


LETRA = {  'A'=> 'A',
           'B'=> 'B',
           'C' => 'C',
           'D' => 'D',
           'E'=> 'E',
        }
SEMESTRE = {'1º Semestre'=> '1',
            '2º Semestre'=> '2',
            'Anual'=> '3',
        }

AVALIACAO= {' Recebeu on_line'=> 'R-Ol',
            ' Recebeu impresso'=> 'R-Im',
            'Não recebeu'=> 'N-Re' ,
            'Devolveu' => 'Dev',
            'Devolveu em branco'=> 'Dev-B'

             }

ATIVIDADETIPO= {'NÃO AVALIATIVA'=> 1,
            'AVALIATIVA' => 0  ,
           }


BIM1INI ='2022-02-07'
BIM1FIM ='2022-04-29'
BIM2INI ='2022-05-02'
BIM2FIM ='2022-07-08'
BIM3INI ='2022-08-01'
BIM3FIM ='2022-09-30'
BIM4INI ='2022-10-03'
BIM4FIM ='2022-12-21'

BIM1INIP ='07/02/2022'
BIM1FIMP ='29/04/2022'
BIM2INIP ='02/05/2022'
BIM2FIMP ='08/07/2022'
BIM3INIP ='01/08/2022'
BIM3FIMP ='30/09/2022'
BIM4INIP ='03/10/2022'
BIM4FIMP ='21/12/2022'

BIM1F= 54
BIM2F= 47
BIM3F= 48
BIM4F= 54

BIM1I= 54
BIM2I= 47
BIM3I= 48
BIM4I= 54
