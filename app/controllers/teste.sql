-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tempo de Geração: 05/07/2016 às 13h30min
-- Versão do Servidor: 5.5.43
-- Versão do PHP: 5.3.10-1ubuntu3.18

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Banco de Dados: `sisgered_development`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `notas`
--

CREATE TABLE IF NOT EXISTS `notas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `aluno_id` int(11) NOT NULL,
  `atribuicao_id` int(11) DEFAULT NULL,
  `professor_id` int(11) DEFAULT NULL,
  `unidade_id` int(11) DEFAULT NULL,
  `disciplina_id` int(11) DEFAULT NULL COMMENT 'Utilizada para históricos de anos anteriores e transferências (Naor e Alex 20160621)',
  `classe` int(3) DEFAULT NULL,
  `ano_letivo` int(4) NOT NULL,
  `bimestre` int(11) DEFAULT NULL,
  `nota1` decimal(10,2) DEFAULT NULL,
  `faltas1` int(3) DEFAULT NULL,
  `nota2` decimal(10,2) DEFAULT NULL,
  `faltas2` int(2) DEFAULT NULL,
  `nota3` decimal(10,2) DEFAULT NULL,
  `faltas3` int(2) DEFAULT NULL,
  `nota4` decimal(10,2) DEFAULT NULL,
  `faltas4` int(2) DEFAULT NULL,
  `nota5` decimal(10,2) DEFAULT NULL,
  `faltas5` int(2) DEFAULT NULL,
  `obs1` varchar(600) CHARACTER SET utf8 DEFAULT NULL,
  `ativo` int(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=52910 ;

--
-- Extraindo dados da tabela `notas`
--

INSERT INTO `notas` (`id`, `aluno_id`, `atribuicao_id`, `professor_id`, `unidade_id`, `disciplina_id`, `classe`, `ano_letivo`, `bimestre`, `nota1`, `faltas1`, `nota2`, `faltas2`, `nota3`, `faltas3`, `nota4`, `faltas4`, `nota5`, `faltas5`, `obs1`, `ativo`, `created_at`, `updated_at`) VALUES
(1, 127, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(2, 128, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(3, 129, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(4, 130, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(5, 131, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(6, 132, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:11', '2016-05-18 20:27:11'),
(7, 133, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:12', '2016-05-18 20:27:12'),
(8, 134, 17, 531, 49, 6, NULL, 2016, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2016-05-18 20:27:12', '2016-05-18 20:27:12');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
