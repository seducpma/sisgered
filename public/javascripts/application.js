function Imprimir(){
window.print();
}
function MM_openBrWindow(theURL,winName,features) {
window.open(theURL,winName,features);
}

function PrintDiv(div)
{
	$('#'+div).printElement();
}

function MascaraMoeda(objTextBox, SeparadorMilesimo, SeparadorDecimal, e){
    var sep = 0;
    var key = "";
    var i = j = 0;
    var len = len2 = 0;
    var strCheck = '0123456789';
    var aux = aux2 = '';
    var whichCode = (window.Event) ? e.which : e.keyCode;
    if (whichCode == 13) return true;
    key = String.fromCharCode(whichCode); // Valor para o código da Chave
    if (strCheck.indexOf(key) == -1) return false; // Chave inválida
    len = objTextBox.value.length;
    for(i = 0; i < len; i++)
        if ((objTextBox.value.charAt(i) != '0') && (objTextBox.value.charAt(i) != SeparadorDecimal)) break;
    aux = '';
    for(; i < len; i++)
        if (strCheck.indexOf(objTextBox.value.charAt(i))!=-1) aux += objTextBox.value.charAt(i);
    aux += key;
    len = aux.length;
    if (len == 0) objTextBox.value = "";
    if (len == 1) objTextBox.value = "0"+ SeparadorDecimal + "0" + aux;
    if (len == 2) objTextBox.value = "0"+ SeparadorDecimal + aux;
    if (len > 2) {
        aux2 = "";
        for (j = 0, i = len - 3; i >= 0; i--) {
            if (j == 3) {
                aux2 += SeparadorMilesimo;
                j = 0;
            }
            aux2 += aux.charAt(i);
            j++;
        }
        objTextBox.value = "";
        len2 = aux2.length;
        for (i = len2 - 1; i >= 0; i--)
        objTextBox.value += aux2.charAt(i);
        objTextBox.value += SeparadorDecimal + aux.substr(len - 2, len);
    }
    return false;
}


function remove_livro(link) {
    var d = document.getElementById('selecionado');
    var olddiv = document.getElementById(link);
    d.removeChild(olddiv);
}
jQuery(document).ready(function( $ ){


//Ajusta filtros
//
$("#filtro_0").on("click", function(){
   if (document.f1.filtro_ambos.checked == true) {
        document.f1.filtro_ambos.checked = false;
    }
});
$("#filtro_1").on("click", function(){
   if (document.f1.filtro_ambos.checked == true) {
        document.f1.filtro_ambos.checked = false;
    }
});

$("#filtro_ambos").on("click", function(){
    document.f1.filtro_0.checked = false;
    document.f1.filtro_1.checked = false;
});



//

//Tipo emprestimo

$("#type_0").click(function ()
{
    $("#aluno").show();
    $("#tipo_emprestimo").html("Selecionar ---------------------------------------------->");
    $("#funcionario").hide();

});
$("#type_1").click(function ()
{
    $("#funcionario").show();
    $("#tipo_emprestimo").html("Selecionar ---------------------------------------------->");
    $("#aluno").hide();
});


$( "#configuracao_data_criacao" ).datepicker({dateFormat: 'dd-mm-yy', changeYear: true, changeMonth: true, yearRange: '-60:+0'});


// Codigo para jogos

//Codigo para validar quantidade indicada com numero de tombos
$("#jogo_lista_tombos").on("focusout",function(){
var elemento = $("#jogo_lista_tombos").val().split(";");
if ($("#jogo_qtde_jogos").val() != elemento.length){
alert("A quantidade de tombos digitados é diferente da quantidade informada, \nfavor verificar antes de continuar. Numero de tombos atual: " + elemento.length + " e a quantidade informado foi: " + $("#jogo_qtde_jogos").val());
$("#jogo_lista_tombos").focus();
}
});


//Codigo para Multi-tombos - cadastro de midias

$("#type_jogos_0").click(function ()
{
    $("#tipo_tombo").show();
    $("#jogo_qtde_jogos").val("").attr("disabled", false).css("background-color", "#ffffff");
    $("#exibe_aviso").show().fadeOut(3000).fadeIn(3000).fadeOut(3000).css("background-color", "yellow");
});
$("#type_jogos_1").click(function ()
{
    $("#tipo_tombo").show();
    $("#jogo_qtde_jogos").val("1").attr("disabled", true).css("background-color", "#cccccc");
});



// Até aqui



//Tombos midias

//Codigo para validar quantidade indicada com numero de tombos
$("#midia_lista_tombos").on("focusout",function(){
var elemento = $("#midia_lista_tombos").val().split(";");
if ($("#midia_qtde_midias").val() != elemento.length){
alert("A quantidade de tombos digitados é diferente da quantidade informada, \nfavor verificar antes de continuar. Numero de tombos atual: " + elemento.length + " e a quantidade informado foi: " + $("#livro_qtde_livros").val());
$("#midia_lista_tombos").focus();
}
});




//Codigo para gerar 2 multi-selects para alunos_classes
$('#add').click(function() {
  return !$('#todos option:selected').remove().appendTo('#classe_aluno_ids');
 });
 $('#remove').click(function() {
  return !$('#classe_aluno_ids option:selected').remove().appendTo('#todos');
 });
//Fim do codigo

//Codigo para gerar 2 multi-selects para professores_classes
$('#add1').click(function() {
  return !$('#todos1 option:selected').remove().appendTo('#classe_professor_ids');
 });
 $('#remove1').click(function() {
  return !$('#classe_professor_ids option:selected').remove().appendTo('#todos1');
 });
//Fim do codigo


//Codigo para Multi-tombos - cadastro de midias

$("#type_midia_0").click(function ()
{
    $("#tipo_tombo").show();
    $("#midia_qtde_midias").val("").attr("disabled", false).css("background-color", "#ffffff");
    $("#exibe_aviso").show().fadeOut(3000).fadeIn(3000).fadeOut(3000).css("background-color", "yellow");
});
$("#type_midia_1").click(function ()
{
    $("#tipo_tombo").show();
    $("#midia_qtde_midias").val("1").attr("disabled", true).css("background-color", "#cccccc");
});

// Tombos midias até aqui



// Teste progressBar

$("#password").keyup(function(){
    var data = $(this).val();
    var len = data.length;
    console.log(len);


    var total = null;
    total = len * 10;
    barUpdate(total);

});
function barUpdate(total) {
    $("#progressBar").progressbar({
        value: total
    });

}

// Fim Teste

//Codigo Abas log

$("#tabs").tabs();
// Fim codigo

//Codigo para validar quantidade indicada com numero de tombos
$("#livro_lista_tombos").on("focusout",function(){
var elemento = $("#livro_lista_tombos").val().split(";");
if ($("#livro_qtde_livros").val() != elemento.length){
alert("A quantidade de tombos digitados é diferente da quantidade informada, \nfavor verificar antes de continuar. Numero de tombos atual: " + elemento.length + " e a quantidade informado foi: " + $("#livro_qtde_livros").val());
$("#livro_lista_tombos").focus();
}
});


//Codigo para Multi-tombos - cadastro de livros

$("#type_0").click(function ()
{
    $("#tipo_tombo").show();
    $("#livro_qtde_livros").val("").attr("disabled", false).css("background-color", "#ffffff");
    $("#exibe_aviso").show().fadeOut(3000).fadeIn(3000).fadeOut(3000).css("background-color", "yellow");
});
$("#type_1").click(function ()
{
    $("#tipo_tombo").show();
    $("#livro_qtde_livros").val("1").attr("disabled", true).css("background-color", "#cccccc");
});











$("#dicionario_enciclopedia_lista_tombos").on("focusout",function(){
var elemento = $("#dicionario_enciclopedia_lista_tombos").val().split(";");
if ($("#dicionario_enciclopedia_qtde").val() != elemento.length){
alert("A quantidade de tombos digitados é diferente da quantidade informada, \nfavor verificar antes de continuar. Numero de tombos atual: " + elemento.length + " e a quantidade informado foi: " + $("#dicionario_enciclopedia_qtde").val());
$("#dicionario_enciclopedia_lista_tombos").focus();
}
});


//Codigo para Multi-tombos - cadastro de dicionarios

$("#type_10").click(function ()
{
    $("#tipo_tombo").show();
    $("#dicionario_enciclopedia_qtde").val("").attr("disabled", false).css("background-color", "#ffffff");
    $("#exibe_aviso").show().fadeOut(3000).fadeIn(3000).fadeOut(3000).css("background-color", "yellow");
});
$("#type_11").click(function ()
{
    $("#tipo_tombo").show();
    $("#dicionario_enciclopedia_qtde").val("1").attr("disabled", true).css("background-color", "#cccccc");
});

// Emprestimos Livros
$('#add_dpu').click(function() {
  return !$('#todos_dpus option:selected').remove().appendTo('#emprestimo_dpu_ids');
 });
$('#remove_dpu').click(function() {
  return !$('#emprestimo_dpu_ids option:selected').remove().appendTo('#todos_dpus');
 });
//Fim do codigo









//Codigo para gerar 2 multi-selects para assuntos
$('#add').click(function() {
  return !$('#todos option:selected').remove().appendTo('#livro_assunto_ids');
 });
 $('#remove').click(function() {
  return !$('#livro_assunto_ids option:selected').remove().appendTo('#todos');
 });
//Fim do codigo

//Codigo para gerar 2 multi-selects para autores
$('#add_autores').click(function() {
  return !$('#todos_autores option:selected').remove().appendTo('#livro_autor_ids');
 });
 $('#remove_autores').click(function() {
  return !$('#livro_autor_ids option:selected').remove().appendTo('#todos_autores');
 });
//Fim do codigo


//Codigo para gerar 2 multi-selects para musicas
$('#add_musicas').click(function() {
  return !$('#todas_musicas option:selected').remove().appendTo('#midia_musica_ids');
 });
 $('#remove_musicas').click(function() {
  return !$('#midia_musica_ids option:selected').remove().appendTo('#todas_musicas');
 });
//Fim do codigo



//Codigo para gerar 2 multi-selects para cantores
$('#add_cantores').click(function() {
  return !$('#todos_cantores option:selected').remove().appendTo('#midia_cantor_ids');
 });
 $('#remove_cantores').click(function() {
  return !$('#midia_cantor_ids option:selected').remove().appendTo('#todos_cantores');
 });
//Fim do codigo


$("#search").focusout(function(){
  var chard = $(this).val().length;
  if (chard <= 3) {
    $("span#error_message").show().html("Favor digitar mais de 3 letras").fadeOut(3000).css('color','red').css('font','10px');
  }
});


//Cadastro Musica
    $('select#midia_genero_id').change(function(){
      if ($(this).val() == 17){
        $(".musica").show();
      }
      else {
        $(".musica").hide();
      }
    });

// Fim cadastro musica

$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
$("#localizacao_data_aquisicao").datepicker({dateFormat: 'dd-mm-yy', changeYear: true, changeMonth: true, yearRange: '-60:+0'});







  // Inicio Mensagem busca
    $(".txt_busca").val("Digite parte da busca").css("color","gray");
  // Fim Mensagem busca

  // Autocomplete Faixa Etaria
  $("#fe").click(function ()
   {
     $(".consulta").show();
     $(".txt_busca").val("Digite parte da busca").css("color","gray");
     $("#search").show().addClass("autocomplete").removeClass("txt_busca");
     
     $(".autocomplete").autocomplete({
        source: ["a"]
     });

     $(".label_busca").show();

   });

  // Fim autocomplete
  //Filtros consultas mapas
  $(".filtro").click(function ()
   {
     $(".consulta").show();
     $(".txt_busca").show();
     $(".label_busca").show();
     $(".consulta_nome").show();
     $(".txt_busca").val("Digite parte da busca").css("color","gray");
     $(".consulta1").hide();
     $(".consulta_unidade").hide();
     $(".consulta_professor").hide();
     $(".consulta2").hide();
   });

$(".filtro_nome").click(function ()
   {
     $(".consulta1").show();
     $(".txt_busca1").show();
     $(".label_busca1").show();

     $(".consulta").hide();
     $(".consulta2").hide();
     $(".txt_busca2").hide();
     $(".label_busca1").hide();

   });

   $(".filtro_tipo").click(function ()
   { $(".consulta2").show();
     $(".txt_busca2").show();
     $(".label_busca2").show();

     $(".consulta2").show();
     $(".txt_busca2").show();
     $(".label_busca2").show();
     $(".consulta").hide();
     $(".consulta1").hide();

  });
$(".sem_filtro").click(function ()
    { $(".txt_busca2").hide();
      $(".label_busca2").hide();
      $(".txt_busca").val("");
      $(".txt_busca").hide();
      $(".label_busca").hide();
      $(".consulta").show();
      $("#unidade_corrente").hide();
      $(".consulta1").hide();
      $(".consulta2").hide();
      $(".consulta_unidade").hide();
      $(".consulta_data").hide();
      $(".txt_busca4").hide();
      $(".label_busca4").hide();
      $(".consulta_professor").hide();
      $(".txt_busca3").hide();
      $(".label_busca3").hide();
      $(".txt_busca2").hide();
      $(".label_busca2").hide();
      $(".label_busca1").hide();
   });

   $(".filtro_funcionario").click(function ()
   {
     $(".consulta1").show();
     $(".txt_busca1").show();
     $(".label_busca1").show();
     $(".consulta").hide();

  });

 $(".filtro_unidade_status").click(function ()
   { $(".consulta_unidade").show();
     $(".txt_busca2").show();
     $(".label_busca2").show();
     $(".label_busca").hide();
     $(".txt_busca").hide();
     $(".consulta_nome").hide();


  });

   $(".filtro_unidade").click(function ()
   {
     $(".consulta_professor").hide();
     $(".consulta").hide();
     $(".consulta2").show();
     $(".consulta_unidade").show();
     $(".txt_busca2").show();
     $(".label_busca2").show();
     $(".consulta_unidade_m").hide();
     $(".consulta_classe").hide();
     $(".txt_buscam").hide();
     $(".label_buscam").hide();
     $(".consulta_unidade_c").hide();
     $(".txt_buscac").ride();
     $(".label_buscac").ride();
     $(".consulta_unidade_m").ride();
     $(".txt_buscam").hide();
     $(".label_buscam").hide();

     $(".consulta1").hide();
     
     $(".consulta_data").hide();
     $(".label_busca1").hide();
     $(".consulta_classe").hide();
     $(".label_busca").hide();
     $(".txt_busca").hide();
     $(".consulta_nome").hide();



   });

   $(".filtro_unidade_c").click(function ()
   {
     $(".consulta2").show();
     $(".consulta_unidade").hide();
     $(".consulta_unidade_c").show();
     $(".txt_buscac").show();
     $(".label_buscac").show();
     $(".consulta").hide();
     $(".consulta_unidade_m").hide();
     $(".txt_buscam").ride()
     $(".label_buscam").ride();
     $(".consulta1").hide();
     $(".consulta_professor").hide();
     $(".consulta_data").hide();
     $(".label_busca1").hide();
     $(".consulta_classe").hide();
   });

   $(".filtro_unidade_m").click(function ()
   {
     $(".consulta2").show();
     $(".consulta_unidade").hide();
     $(".consulta_unidade_c").hide();
     $(".consulta_unidade_m").show();
     $(".txt_buscam").show();
     $(".label_buscam").show();
     $(".txt_busca2").ide();
     $(".label_busca2").ride();
     $(".consulta").hide();
     $(".txt_buscac").ride();
     $(".label_buscac").ride();
     $(".consulta1").hide();
     $(".consulta_professor").hide();
     $(".consulta_data").hide();
     $(".label_busca1").hide();
     $(".consulta_classe").hide();
   });

   $(".filtro_professor").click(function ()
   {
     $(".consulta_professor").show();
     $(".txt_busca3").show()
     $(".label_busca3").show();
     $(".consulta").hide();
     $(".consulta1").hide();
     $(".consulta_unidade").hide();
     $(".consulta_data").hide();

   });
      $(".filtro_classe").click(function ()
   {
     $(".consulta_classe").show();
     $(".txt_busca3").show()
     $(".label_busca3").show();
     $(".consulta").hide();
     $(".consulta1").hide();
     $(".consulta_unidade").hide();
     $(".consulta_data").hide();

   });

   $(".filtro_data").click(function ()
   {
     $(".consulta_data").show();
     $(".txt_busca4").show()
     $(".label_busca4").show();
     $(".consulta").hide();
     $(".consulta1").hide();
     $(".consulta_empresa").hide();
     $(".consulta_obreiro").hide();
     $(".consulta_2").hide();


   });

   $(".filtro1").click(function ()
   {
     $(".consulta_cantor").show();   
   });

   
   $(".sem_filtro#unidade").click(function ()
    {
      $("#unidade_corrente").show();
      $(".consulta").show();
    });


    $(".txt_busca").focus(function(){
       $(".txt_busca,#search").val("");
    });

  // Fim Filtros

$(".filtro_classe1").click(function ()
   {
     $(".consulta_classe1").show();
     $(".txt_busca3").show()
     $(".label_busca3").show();
     $(".consulta_periodo").hide();
     $(".consulta_professor_nome1").hide();
     $(".txt_busca4").hide()
     $(".label_busca4").hide();

   });

   $(".filtro_periodo").click(function ()
   {
     $(".consulta_periodo").show();
     $(".txt_busca4").show()
     $(".label_busca4").show();
     $(".consulta_professor_nome1").hide();
     $(".consulta_classe1").hide();
     $(".txt_busca3").hide()
     $(".label_busca3").hide();

   });

   $(".filtro_professor_nome1").click(function ()
   {
     $(".consulta_professor_nome1").show();
     $(".consulta_classe1").hide();
     $(".consulta_periodo").hide();
     $(".txt_busca3").hide()
     $(".label_busca3").hide();


   });

// Letras em maiusculo

//$("input").keyup(function(){
//    $(this).val($(this).val().toUpperCase());
//  })

// Fim Letra em maiusculo




	var uls = $('#menu ul');
	uls.hide();

	$('#menu > li').click(function( e ){
		e.stopPropagation();
		uls.hide();
		$( this ).find('ul').show();
	});
	$('#menu ul').click(function( e ){
		e.stopPropagation();
	});
	$('body').click(function(){
		uls.hide();
	});

$(".grid").flexigrid({
    url: 'livros.json'
});

$( "input:submit, .botao" ).button();
$( "#datepicker" ).datepicker();
$( ".tabs" ).tabs();


$("#emprestimo_tipo_emprestimo").on("click",function(){
    $("#tipo").show;
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

function hide_field(link,div) {
  $(div).toggle();
}
$(function() {
$("#fancy, #fancy2").tooltip({
	track: true,
	delay: 0,
	showURL: false,
	fixPNG: true,
	showBody: " - ",
	extraClass: "pretty fancy",
	top: -15,
	left: 5
});

$('#pretty').tooltip({
	track: true,
	delay: 0,
	showURL: false,
	showBody: " - ",
	extraClass: "pretty",
	fixPNG: true,
	left: -120
});

});

});



